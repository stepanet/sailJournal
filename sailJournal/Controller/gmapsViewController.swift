//
//  gmapsViewController.swift
//  sailJournal
//
//  Created by Dmitry Pyatin on 19.11.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//  test git

import UIKit
//import Foundation
import GoogleMaps

class gmapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //refresh data poiPlace
    let refreshDataPoiPlaces: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ОБНОВИТЬ", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Thin", size: 15)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(named: "btnBackgrndColor")
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(startLoadPoiPlaces), for: .touchUpInside)
        return btn
    }()
    
    

    var newPoiPlaces = [NewPoiPlacesStruct]()
    var poiPlacesData:[PoiPlacesData]?
    var currentLat:Double?
    var currentLon:Double?
    var didTapAtLat: Double?
    var didTapAtLon: Double?
    var lineFromLocatonToPoint: GMSPolyline?
    var currentPolygon: GMSPolygon?
    var distanceToPoint: Double?
    var newDistanceToPoint: Double?
    var newDistanceAngel: Double?
    var lineFromLocatonToCourse: GMSPolyline?
    

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var earthMapButton: UIButton! //кнопка показа вид со спутника
    @IBOutlet weak var zoomInButton: UIButton! // зум карты +
    @IBOutlet weak var zoomOutButton: UIButton! //зум карты -
    @IBOutlet weak var geoLocation: UIButton! //включение геолокации
    @IBOutlet weak var speedLbl: UILabel! //отображение скорости
    @IBOutlet weak var distanceToPoinLbl: UILabel!
    
    @IBOutlet weak var showPlacesOnMap: UISwitch!
    

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 14.0
    var mapStyleSattelite   =  0
    var countPlaces = 0
    var poiPlacesMemory = 0
    var actionButtonValue = false
    var showOwnerPoi = false
    var geoOnOff = false
    var i = 0 //счетчик для геолокации. регулирует частоту передачи данных на сервер
    var infoView = UIView()
    var infoTextView = UITextView()
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        print("gmapsViewController viewDidLoad")
        //MARK: трансформация  и добавление на карту кнопок
        //print(calculateDistanceTwoPoint(llat1: 77.1539, llong1: 120.398, llat2: 77.1804, llong2: 129.55))

        
        showSubView()
        showMapProperty()
        setupDataRefreshPoiPlace()
    }
    
    
    
    @objc func startLoadPoiPlaces() {
        
        let a = FrameworkKitClass.coordinateString(latitude: currentLat!, longitude: currentLon!, oneString: 1)
        print(a)
        
    }

    func showInfoView(show: Int, description: String) {
  
        
        let w = Int(Double(mapView.frame.size.width) / 1.6)
        let h = Int(Double(mapView.frame.size.height) / 4.77) //200
        
        let x = (Int(mapView.frame.size.width) - w)  / 2
        let y = ((Int(mapView.frame.size.height) - h)  / 2) + h
        
    
        self.infoTextView.frame = CGRect(x: x, y: y, width: w, height: h)
        self.infoTextView.backgroundColor = UIColor(named: "PrimaryColor")//UIColor.init(displayP3Red: 0.85, green: 0.43, blue: 0.26, alpha: 1)
        self.infoTextView.textColor = UIColor.white
        self.infoTextView.textAlignment = .center
        self.infoTextView.text = description
        self.infoTextView.font = UIFont.systemFont(ofSize: 16)
        self.infoTextView.isEditable = false
        self.infoTextView.contentInset = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.infoTextView.layer.cornerRadius = 10
        self.infoTextView.clipsToBounds = true
        


        if show == 1 {
            infoTextView.isHidden = false
            self.view.addSubview(infoTextView)
        } else {
            infoTextView.isHidden = true
        }
    }
    
    
    func showMapProperty() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 30
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading() //update
        locationManager.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true //отображение компаса в 3д
        mapView.settings.myLocationButton = true //отображение кнопки мое местоположение
        self.mapView.mapType = .normal //тип карты
        self.earthMapButton.setImage(UIImage(named:"earth_st_primary"), for: UIControlState.normal)
    }
    
    func showSubView() {
        self.speedLbl.layer.cornerRadius = 5
        self.distanceToPoinLbl.layer.cornerRadius = 5
        self.mapView.addSubview(earthMapButton)
        self.mapView.addSubview(zoomInButton)
        self.mapView.addSubview(zoomOutButton)
        self.mapView.addSubview(geoLocation)
        self.mapView.addSubview(speedLbl)
        self.mapView.addSubview(distanceToPoinLbl)
        self.mapView.addSubview(refreshDataPoiPlaces)
        self.view.addSubview(showPlacesOnMap)
        
        
    }
    
    //MARK: Расчет дистанции между точками
    func calculateDistance(pointOneLat: Double, pointTwoLat: Double, pointOneLng: Double, pointTwoLng: Double) -> Double {
        var distance: Double = 0
        let r:Double = 6371000 //middle radius earth
        let angle = Double.pi / 180
        distance = r * acos(sin(pointOneLat*angle)*sin(pointTwoLat*angle) + cos(pointOneLat*angle)*cos(pointTwoLat*angle)*cos(pointTwoLng*angle - pointOneLng*angle)) / 1852
    return distance
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location: CLLocation = locations.last!
        let location = locations[0] as CLLocation
        let dateNow = FrameworkKitClass.datenow()
        var speedNow = location.speed * 3.6 * 0.53996146834962
        if speedNow < 0 {
            speedNow = 0
        }
        speedLbl.text = String(format: "%.2f", speedNow) + "NM"

        currentLat = location.coordinate.latitude
        currentLon = location.coordinate.longitude

        //нарисуем курсовую линию
        lineFromLocatonToCourse?.map = nil
        let endLatPosition = currentLat! + 0.5 * cos(2 * Double.pi * location.course/360)
        let endLngPosition = currentLon! + 0.5 * sin(2 * Double.pi * location.course/360)
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: currentLat! , longitude: currentLon!))
        path.add(CLLocationCoordinate2D(latitude: endLatPosition, longitude: endLngPosition))
        let polyline1 = GMSPolyline(path: path)
        polyline1.strokeWidth = 2.0
        polyline1.strokeColor = UIColor.init(displayP3Red: 0.63, green: 0.21, blue: 0.35, alpha: 1)
        polyline1.map = mapView
        lineFromLocatonToCourse = polyline1
        
        //нарисуем линию от нашей точки до нажатой точки и будем ее перерисовывать
        if lineFromLocatonToPoint != nil {
            lineFromLocatonToPoint?.map = nil
        }
        
        //MARK сделаем линию
        if didTapAtLat != nil {
                let path = GMSMutablePath()
                path.add(CLLocationCoordinate2D(latitude: currentLat! , longitude: currentLon!))
                path.add(CLLocationCoordinate2D(latitude: didTapAtLat!, longitude: didTapAtLon!))
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 2.0
                polyline.strokeColor = UIColor.init(displayP3Red: 0.63, green: 0.21, blue: 0.35, alpha: 1)
                polyline.map = mapView
                lineFromLocatonToPoint = polyline
            
           distanceToPoint = calculateDistance(pointOneLat: currentLat!, pointTwoLat: didTapAtLat!, pointOneLng: currentLon!, pointTwoLng: didTapAtLon!)
            distanceToPoinLbl.text = String(format: "%.0f", distanceToPoint!) + "NM"
        }

         //передавать координаты устройства в зависимости от настроек
         if geoOnOff { 
         if Reachability.isConnectedToNetwork() {

         if i == 0 { //передаем координаты один раз в 5 минут
            
            if let currentUser = userDefaults.object(forKey: "user_id") {
                
                //let currentUserToken = userDefaults.object(forKey: "user_token")
                print("user found gmapsViewController\(currentUser)")
                createJsonFileCurrentLocation(name: currentUser as! Int, lat: location.coordinate.latitude, lng: location.coordinate.longitude, speed: location.speed, course: location.course, dateNow:dateNow)
            }

            i = 50
         }
            i = i - 1
         }
    }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    

    //MARK метод создания JSON с координатами текущего места и отправка файла на сервер
    func createJsonFileCurrentLocation(name: Int, lat: Double, lng: Double,speed: Double, course: Double , dateNow: String) {
    
        print("отправляем координаты - имя\(name) лат\(lat) лонг\(lng) скорость\(speed) курс\(course) \(dateNow)")
        
        guard let url = URL(string: "https://s-j-egrozdev.c9users.io/getswift/7-Jr6slsYIBe1oGSn3qnQQ/online") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newPost = UserLocationData(name: name, lat: lat, lng: lng, speed: speed, course: course, dateNow: dateNow)

        do  {
            let jsonBody = try JSONEncoder().encode(newPost)
            request.httpBody = jsonBody
        } catch {}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print ("вывести значение json = \(json)")
                
            } catch {}
        }
        task.resume()
    }
    

 
    //MARK - function add new place
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        //нарисуем линию при долгом нажатии
        didTapAtLat = coordinate.latitude
        didTapAtLon = coordinate.longitude
        
        if lineFromLocatonToPoint != nil {
            lineFromLocatonToPoint?.map = nil
            currentPolygon?.map = nil
        }
        
        //MARK сделаем линию
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: currentLat! , longitude: currentLon!))
        path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.strokeColor = UIColor.init(displayP3Red: 0.63, green: 0.21, blue: 0.35, alpha: 1)
        polyline.geodesic = true
        polyline.map = mapView
        lineFromLocatonToPoint = polyline
        distanceToPoint = calculateDistance(pointOneLat: currentLat!, pointTwoLat: didTapAtLat!, pointOneLng: currentLon!, pointTwoLng: didTapAtLon!)
        
       // newDistanceToPoint = calculateDistanceTwoPoint(llat1: currentLat!, llong1: currentLon!, llat2: didTapAtLat!, llong2: didTapAtLon!)
        
        distanceToPoinLbl.text = String(format: "%.f", distanceToPoint!) + "NM"
       // distanceToPoinLbl.text = String(format: "%.f", newDistanceToPoint!) + "NM"
   
//            //создаем alert controller
//            let alertController = UIAlertController(title: "Добавление нового места", message: "Введите название места", preferredStyle: .alert)
//            //создаем кнопки нашего алертКонтроллера
//            let actionButton = UIAlertAction(title: "Добавить", style: .default) { (action) in
//            //название места
//            var nameNewPlace = alertController.textFields?.first?.text
//            //координаты места в широте и долготе
//            let coordinatePlace = self.coordinateString(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            //добавляем точку на карту и в массив
//                if nameNewPlace == ""  {
//                    nameNewPlace = nil
//                }
//            self.addPoiToArray(lat: coordinate.latitude, lng: coordinate.longitude, name: (nameNewPlace ?? "место без названия"))
//            self.addMarketToMap(lat: coordinate.latitude, long: coordinate.longitude, title: (nameNewPlace ?? "место без названия"), snippet:                 coordinatePlace, namedIcon: "icon")
//
//        }
//        let actionButtonNo = UIAlertAction(title: "Отмена", style: .default) { (action) in
//        }
//        //добавим кнопки на алертКонтроллер
//        alertController.addAction(actionButton)
//        alertController.addAction(actionButtonNo)
//        //добавим текстовое поле на алерт контроллер
//        alertController.addTextField(configurationHandler: nil)
//        //выведем наш алертКонтроллер
//        self.present(alertController, animated: true, completion: nil)
    }

 
    // MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //showInfoView(show: 0, description: "")
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
        showInfoView(show: 0, description: "")
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("нажали на информационное окно")
       // showInfoView(show: 1, description: marker.snippet!)
       // alertShow(title: "удаляем?", message: "маркер будет удален", style: .alert)
    }
    

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
        showInfoView(show: 1, description: marker.snippet!)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        print("didCloseInfoWindowOf")
        showInfoView(show: 0, description: "")
    }
    
    //MARK - change map style view
    @IBAction func changeStyle(_ sender: UIButton) {
        mapStyleSattelite += 1
            UIView.animate(withDuration: 1) {
           
            //            switch self.mapStyleSattelite  {
            //            case 2,4 : self.earthMapButton.setImage(UIImage(named:"earth_st"), for: UIControlState.normal)
            //            default: self.earthMapButton.setImage(UIImage(named:"earth_st"), for: UIControlState.normal)
            //                }
                    switch self.mapStyleSattelite {
                    case 1 : self.mapView.mapType = .terrain
                    case 2 : self.mapView.mapType = .satellite
                    case 3 : self.mapView.mapType = .hybrid
                    case 4 : self.mapView.mapType = .normal
                    default : self.mapView.mapType = .normal
                }
            }
        if mapStyleSattelite == 4 {
            mapStyleSattelite = 0
        }
    }
    
    //MARK: следим за ориентацией устройства
//        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//            if UIDevice.current.orientation.isLandscape {
//                print("Landscape")
//            } else {
//                print("Portrait")
//            }
//        }
    
    //MARK: возьмем данные
        override func viewWillAppear(_ animated: Bool) {
            
        print("gmapsViewController viewWillAppear")
            if showOwnerPoi {
                if let currentUser = userDefaults.object(forKey: "user_id") {

                    poiPlacesData = CoreDataHandler.filterDataPoi(filterText: "\(currentUser)", strong: 1)
                }
            } else {
                poiPlacesData = CoreDataHandler.fetchObjectPoi()
            }
          
//            if userDefaults.object(forKey: "user_id") != nil {
//                _ = userDefaults.object(forKey: "user_token")
//               // print("user found \(currentUser), \(currentUserToken)")
//                
//            } else {
//                print("user not found")
//                
//            }
        createPoiOnMap()
    }
    
    
    func createPoiOnMap() {
        
        distanceToPoinLbl.text = ""
        mapView.isHidden = true
        mapView.clear()
        
        for placeFromCoreData in poiPlacesData! {
            addMarketToMap(lat: placeFromCoreData.lat, long: placeFromCoreData.lng, title: placeFromCoreData.name!, snippet: (placeFromCoreData.name!) + "\n" + FrameworkKitClass.coordinateString(latitude: placeFromCoreData.lat, longitude: placeFromCoreData.lng, oneString: 0) + "\n" + placeFromCoreData.descriptionplace!, namedIcon: "icon_new_red", imageIcon: placeFromCoreData.imageData! as Data)
        }
        showBadge()
        mapView.isHidden = false
    }
    
    
    func showBadge() {
        
        if let badgeValue = (poiPlacesData?.count) {
            tabBarItem.badgeValue = String(badgeValue)
        }
        
    }
    
    
    @IBAction func shopUserPaceOnMapAction(_ sender: UISwitch) {
        
        if showPlacesOnMap.isOn {
            
            print("showPlacesOnMap ON")
            
            showOwnerPoi = true
            if let currentUser = userDefaults.object(forKey: "user_id") {
                print("AppDelegate.swift = \(currentUser)")
                
                poiPlacesData = CoreDataHandler.filterDataPoi(filterText: "\(currentUser)", strong: 1)
                showBadge()
                createPoiOnMap()
                //print(poiPlacesData?.count)
                
            }
        } else {
            
            print("showPlacesOnMap OFF")
            showOwnerPoi = false
            poiPlacesData = CoreDataHandler.fetchObjectPoi()
            //print(poiPlacesData?.count)
            showBadge()
            createPoiOnMap()
        }
    }

    //MARK: добавляем маркеры на карты
    func addMarketToMap(lat: Double, long: Double, title: String, snippet: String, namedIcon: String, imageIcon: Data) {
        //let house = UIImage(named: namedIcon)!
        //let house = UIImage(data: imageIcon, scale:15.0)
        //let markerIcon = UIImageView(image: house)
        let initialLocation = CLLocationCoordinate2DMake(lat, long)
        let marker = GMSMarker(position: initialLocation)
        marker.title = title
        //Добавление информационного окна
        marker.snippet = snippet
        //Настройка автоматического обновления информационного окна
        //marker.tracksInfoWindowChanges = true

        //marker.iconView = markerIcon
        mapView.delegate = self
        marker.map = mapView
    }
    
    
    
    //MARK: добавление нового места
    func addPoiToArray (lat: Double,lng: Double, name: String) {
        let newPlace = NewPoiPlacesStruct(lat: lat, lng: lng, name: name)
        newPoiPlaces.append(newPlace)
        print("gmaps добавлено новое место \(newPlace)")
    }
    
    
    //MARK: диалоговое окно
    func alertShow(title: String, message: String, style: UIAlertControllerStyle) {
        //создаем alert controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        //создаем кнопки нашего алертКонтроллера
            let actionButton = UIAlertAction(title: "Удалить", style: .default) { (action) in
                self.actionButtonValue = true
            }
            let actionButtonNo = UIAlertAction(title: "Отмена", style: .default) { (action) in
                self.actionButtonValue = false
            }
        //добавим кнопки на алертКонтроллер
        alertController.addAction(actionButton)
        alertController.addAction(actionButtonNo)
        
        //добавим текстовое поле на алерт контроллер
        //alertController.addTextField(configurationHandler: nil)
        
        //выведем наш алертКонтроллер
        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK: спрячем статус бар
    //    override var prefersStatusBarHidden: Bool {
    //        return false
    //    }
    
    
    //MARK - btn zoom +
    @IBAction func btnZoomIn(_ sender: Any) {
        zoomLevel = zoomLevel + 1
        self.mapView.animate(toZoom: zoomLevel)
    }
    
    //MARK - btn zoom -
    @IBAction func btnZoomOut(_ sender: Any) {
        zoomLevel = zoomLevel - 1
        self.mapView.animate(toZoom: zoomLevel)
    }
    
    //MARK - btn geolocation
    @IBAction func geoOnOffBtn(_ sender: UIButton) {
                    print("i = \(i)")
        if geoOnOff {
            geoOnOff = false
            self.i = 0;
            self.geoLocation.setImage(UIImage(named:"geoOffNew"), for: UIControlState.normal)
        } else {
            geoOnOff = true
            self.geoLocation.setImage(UIImage(named:"geoOnPrimary"), for: UIControlState.normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func calculateDistanceTwoPoint(llat1: Double, llong1 : Double, llat2: Double, llong2: Double) -> (Double, Double) {
        
        var pi: Double
        var rad: Double
        //радианы
        var lat1: Double
        var lat2: Double
        var long1: Double
        var long2: Double
        //косинусы и синусы
        var cl1: Double
        var cl2: Double
        var sl1: Double
        var sl2: Double
        //-------------------
        var delta: Double
        var cdelta: Double
        var sdelta: Double
        //--------------------
        var y: Double
        var x: Double
        var ad: Double
        var dist: Double
        var z: Double
        var z2: Double
        var anglerad2: Double
        var anglerad: Double
        
        pi = .pi
        rad = 6372795
        
        //select 'в радианы'
        lat1  = (llat1 * pi) / 180
        lat2  = (llat2 * pi) / 180
        long1 = (llong1 * pi) / 180
        long2 = (llong2 * pi) / 180
        
        //select 'косинусы и синусы широт и разницы долгот'
        cl1  = cos(lat1)
        cl2  = cos(lat2)
        sl1  = sin(lat1)
        sl2  = sin(lat2)
        delta = long2 - long1
        cdelta = cos(delta)
        sdelta = sin(delta)
        
        //select 'вычисление длины большого круга'
        y = sqrt(pow(cl2*sdelta,2) + pow(cl1*sl2-sl1*cl2*cdelta,2))
        x = sl1 * sl2 + cl1 * cl2 * cdelta
        ad = atan(y/x)
        dist = ad * rad
        
        //select 'вычисление начального азимута'
        x = (cl1*sl2) - (sl1*cl2*cdelta)
        y = sdelta * cl2
        z = (atan(-y/x)) *  180 / pi

        if (x < 0) {
            z = z + 180
        }
        let tz = (Int(z) + 180) % 360
        z2 = Double(tz) - 180
        z2 = pi * (z2) * -1 / 180

        anglerad2 = z2 - ((2 * pi) * (z2 / (2 * pi)).rounded(.towardZero))
        anglerad = (anglerad2 * 180 ) / pi
 
        return (dist.rounded() / 1852, anglerad)
        
    }
    
    
    //установка констрейтов для loginRegisterSegmentedControl
    func setupDataRefreshPoiPlace() {
        refreshDataPoiPlaces.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        refreshDataPoiPlaces.bottomAnchor.constraint(equalTo: distanceToPoinLbl.topAnchor, constant: -10).isActive = true
        refreshDataPoiPlaces.widthAnchor.constraint(equalTo: distanceToPoinLbl.widthAnchor).isActive = true
        refreshDataPoiPlaces.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
