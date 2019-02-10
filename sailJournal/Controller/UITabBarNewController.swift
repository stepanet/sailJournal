//
//  UITabBarNewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 07.04.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//


import UIKit
//import Foundation

class UITabBarNewController: UITabBarController , UITabBarControllerDelegate {
    
    var poiPlacesData:[PoiPlacesData]? //core data
    var usersData:[UsersData]? //core data
    var newsData:[NewsData]? //core data
    var poiPlaces = [PoiPlaces]() //json POI
    var poiPlacesPage = [PoiPlaces]()
    var users = [Users]() //json Users
    var news = [News]() //json News
    let userDefaults = UserDefaults.standard
    var infoTextView = UITextView()
    var refreshData  = false
    var pages:Int = 0

    @IBOutlet weak var tabBarItems: UITabBar!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UITabBarNewController viewDidLoad")
        
        //настроим навигэшн бар и таб бар
        setNavTabBar()
        
        //заберем данные из COREDATA
        usersData = CoreDataHandler.fetchObjectUsers()
        poiPlacesData = CoreDataHandler.fetchObjectPoi()
        
        //не обновлять данные , если уже есть
        if usersData!.count == 0 || poiPlacesData!.count == 0 {
            placeLoadJson ()
        }
       
       // _ =  CoreDataHandler.cleanDeleteUsers()


    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("UiTabBarController viewWillAppear")
        print(tabBarController?.selectedViewController! ?? "")
    }
    
    func before(value1: String, value2: String) -> Bool {
        // One string is alphabetically first.
        // ... True means value1 precedes value2.
        return value1 < value2;
    }
    
    //MARK: настройка бара навигации и таббара
    func setNavTabBar() {
        //setup for navigation and tabbar
        tabBarItems.unselectedItemTintColor = UIColor(named: "GrayColor")
        tabBarItems.barTintColor = UIColor.black
        
        

        //меняем цвет значков на вкладке еще
        self.moreNavigationController.topViewController?.view.tintColor = UIColor(named: "PrimaryColor")
        self.moreNavigationController.navigationBar.barTintColor = UIColor.white
        //Цвет кнопоки редктировать
        self.moreNavigationController.navigationBar.tintColor = UIColor(named: "PrimaryColor")
        //большой заголовок
        //self.moreNavigationController.navigationBar.prefersLargeTitles = true
        //меняем MORE на свой
        self.moreNavigationController.navigationBar.topItem?.title = "МЕНЮ"
        //меняем текст кнопки EDIT
        self.moreNavigationController.navigationBar.topItem?.rightBarButtonItem?.title = "РЕДАКТ."    //UIImage(named: "no_avatar")

    }

    
    //
    //MARK: new load place from JSON to ARRAY
    public func placeLoadJson() {   //можно вставить в () код completed: @escaping () ->() , тогда после завершения метода можно вызвать любое действие внутри метода

        if Reachability.isConnectedToNetwork(){
                        print("placeLoadJson соединение с интернетом есть")

            let url1 = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/places?place=1")
            
            
            //let url1 = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/places?page=\(i)")
            //let url1 = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/places?version=0")

            URLSession.shared.dataTask(with: url1!) { (data, response, error) in
                if error == nil {
                    do {
                        
                         self.poiPlacesPage = try JSONDecoder().decode([PoiPlaces].self, from: data!)
                         self.poiPlaces += self.poiPlacesPage
                        
                         print("1poiPlaces.count=\(self.poiPlaces.count)")
                        
                        //print(self.poiPlaces)
                        //self.poiPlaces = try JSONDecoder().decode([PoiPlaces].self, from: data!)
                        
                    } catch {
                        print("placeLoadJson1")
                    }

                        print("placeLoadJson2")
                }
                        print("placeLoadJson3 = \(self.poiPlaces.count)")
                
                
                    print("2poiPlaces.count=\(self.poiPlaces.count)")
                    //self.poiPlaces = self.poiPlaces.sorted(by: { Int($0.rating!) > Int($1.rating!) })
                    self.poiPlaces = self.poiPlaces.sorted(by: { ($0.name!) < ($1.name!) })
                    self.poiPlaces = self.poiPlaces.sorted(by: { ($0.id) < ($1.id) })
                    self.userDefaults.setValue(String(self.poiPlaces.count), forKey: "placeCount")
                    self.userLoadJson()


                }.resume()
            
                        print("placeLoadJson4")
        } else {
                        print("placeLoadJson соединение с интернетом отсутствует")
        }
    }
  
    //MARK: New load USERS from JSON to ARRAY
    public func userLoadJson() {
        
        if Reachability.isConnectedToNetwork(){
                        print("userLoadJson соединение с интернетом есть")
  
            let url = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/users")
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    
                    do {
                        self.users = try JSONDecoder().decode([Users].self, from: data!)
                        self.users = self.users.sorted(by: { $0.totalNM > $1.totalNM })
                    } catch {
                        print("userLoadJson user load error")
                    }
                        print("userLoadJson1")
                }
                        print("userLoadJson2")
                        print("userLoadJson2 пользователей = \(self.users.count)")
                self.userDefaults.setValue(String(self.users.count), forKey: "userCount")
                let dateNow = FrameworkKitClass.datenow()
                self.userDefaults.setValue(dateNow, forKey: "updateDate")
                self.userDefaults.synchronize()
                self.placeUserLoadToData()
                }.resume()
                        print("userLoadJson3")
        } else {
                        print("userLoadJson соединение с интернетом отсутствует")
        }
    }
 
    //MARK: New load data from JSON to COREDATA
    public func placeUserLoadToData() {
        
        usersData = CoreDataHandler.fetchObjectUsers()
        poiPlacesData = CoreDataHandler.fetchObjectPoi()
        
        if Reachability.isConnectedToNetwork(){
                        print("placeLoadToData соединение с интернетом есть")

            var cnt:Float = 0.00
            let stepPlace = Float(100 / Float(self.poiPlaces.count))
            let stepUser = Float(100 / Float(self.users.count))
            
            if  (self.poiPlaces.count) != (self.poiPlacesData!.count - 1)
            {
                
                
            self.showInfoView(show: 1, description: "обновляем интересные места")
                
            //запишем что обновляем данные
            self.userDefaults.setValue(true, forKey: "refreshPlaceData")
            self.userDefaults.synchronize()

            //очистим базу данных от мест и загрузим свежие
                
            _ =  CoreDataHandler.cleanDeletePoi()
            
             //print(self.poiPlaces.count)

            for p in self.poiPlaces {
                
                
                let pidArray = [2338,707]

                
                var fullPath = p.thumb!
                if fullPath.contains("https://") {
                    fullPath = (p.thumb!)
                } else {
                    fullPath = "https://sailjournal.com"+(p.thumb!)
                }

                var url:NSURL = NSURL(string: fullPath)!
                print(p.id, url)
                
                
                if pidArray.contains(p.id) {
                                        url = NSURL(string: "https://s3-sail-journal.s3.amazonaws.com/posts/thumb_ID796-2018-05-25%2014%3A37%3A00%20UTC.jpeg")!
                }
          
//                if p.id.pidArray {
//                    url = NSURL(string: "https://s3-sail-journal.s3.amazonaws.com/posts/thumb_ID796-2018-05-25%2014%3A37%3A00%20UTC.jpeg")!
//                }
                
                let myImage = UIImage(data: NSData(contentsOf: url as URL)! as Data)
                let imageData:NSData = UIImagePNGRepresentation(myImage!)! as NSData

                _ = CoreDataHandler.saveObjectPoi(entityName: "PoiPlacesData", lat: p.lat, lng: p.lng, name: p.name!, poiplacesid: p.id, rating: p.rating!, picture: p.picture!, thumb: p.thumb!, user_id: p.user_id, descriptionplace: p.description ?? "описание места в процессе....", imageData: imageData)

                cnt += stepPlace
                self.showInfoView(show: 1, description: "не выключайте приложение,\n обновляем интересные места,\n загружено процентов \(String(format: "%.0f", cnt))%")
            }
            }

            if (self.users.count) != (self.usersData!.count) {
                //print(self.users.count)
                //print(self.usersData!.count)
                cnt = 0
                self.userDefaults.setValue(true, forKey: "refreshUserData")
                self.userDefaults.synchronize()
                
                //загрузим места
                //очистим бд от пользователей для свежей загрузки
                _ =  CoreDataHandler.cleanDeleteUsers()
                var comment = ""
                
                for u in self.users {
                    if u.comment == nil {
                        comment = ""
                    } else {
                        comment = u.comment!
                    }
 
                    var fullPath = u.photourl
                    if fullPath.contains("https://") {
                        fullPath = (u.photourl)
                    } else {
                        fullPath = "https://sailjournal.com"+(u.photourl)
                    }
                    
                    let url:NSURL = NSURL(string: fullPath)!
                    let myImage = UIImage(data: NSData(contentsOf: url as URL)! as Data)
                    let imageData:NSData = UIImagePNGRepresentation(myImage!)! as NSData
                    
                    _ = CoreDataHandler.saveObjectUsers(entityName: "UsersData", name: u.name, qualification: u.qualification, photoURL: u.photourl, totalNM: u.totalNM, comment: comment, totalExpedition: u.totalExpedition,userid: u.id, email: u.email ?? "...", imageData: imageData)

                    cnt += stepUser
                    self.showInfoView(show: 1, description: "обновляем пользователей,\n загружено процентов \(String(format: "%.0f", cnt))%")
                }

            }  else {
             
                self.userDefaults.setValue(false, forKey: "refreshUserData")
                self.userDefaults.setValue(false, forKey: "refreshPlaceData")
                self.userDefaults.synchronize()
                
                
            }
                //конец условия загрузки данных
            
            
            //проверим грузили что-нибудь или нет
            if let refreshUserData = userDefaults.object(forKey: "refreshUserData")  {

                if refreshUserData as! Bool {
                    print("!!!!!!!обновляли данные по юзерам")
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.showInfoView(show: 1, description: "обновляем бд")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.showInfoView(show: 0, description: "")
                        self.userDefaults.setValue(false, forKey: "refreshUserData")
                        self.userDefaults.synchronize()
                        
                    }
                }
            }

            
            self.showInfoView(show: 0, description: "")
        } else {
                        print("placeLoadToData соединение с интернетом отсутствует")
        }
    }

    
    //MARK - загрузка новостей
    public func loadJsonNews (completed: @escaping () ->()){
        if Reachability.isConnectedToNetwork(){
            print("3Internet Connection Available!")
            let url = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/posts")
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.news = try JSONDecoder().decode([News].self, from: data!)
                        if self.news.count > 0 {
                            _ = CoreDataHandler.cleanDeleteNews() //если JSON заполнили данными то очистим таблицу POI и загрузим свежие данные
                        }
                        DispatchQueue.main.async {
                            completed()
                            for p in self.news {
                                var picString = (p.picture.url)
                                if picString.contains("https://") {
                                    picString = (p.picture.url)
                                } else {
                                    picString = "https://sailjournal.com"+(p.picture.url)
                                }
                                
                                _ = CoreDataHandler.saveObjectNews(entityName: "NewsData", id: p.id, picture: picString, user_id: p.user_id, place_id: p.place_id ?? 0, message: p.message, likes: p.likes, created_at: p.created_at, updated_at: p.updated_at, sight_id: p.sight_id ?? 0, restaurant_id: p.restaurant_id ?? 0, marina_id: p.marina_id ?? 0, place_charter_id: p.place_charter_id ?? 0, route_id: p.route_id ?? 0, yacht_id: p.yacht_id ?? 0, anchorage_id: p.anchorage_id ?? 0)
                            }
                        }
                    } catch {
                            print("JSON news load error")
                    }
                }
                }.resume()
        } else {
                            print("Internet Connection not Available!")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: ОТРИСУЕМ ОКНО
    func showInfoView(show: Int, description: String) {
        DispatchQueue.main.async {
            
            let w = Int(Double(self.view.frame.size.width) / 1.6)
            let h = Int(Double(self.view.frame.size.height) / 4.77) //200
            
            let x = (Int(self.view.frame.size.width) - w) / 2
            let y = ((Int(self.view.frame.size.height) - h)  / 2) //+ h
           
            self.infoTextView.frame = CGRect(x: x, y: y, width: w, height: h)
            self.infoTextView.backgroundColor = UIColor(named: "PrimaryColor")
            self.infoTextView.textColor = UIColor.white
            self.infoTextView.textAlignment = .center
            self.infoTextView.text = description
            self.infoTextView.font = UIFont.systemFont(ofSize: 16)
            self.infoTextView.isEditable = false
            self.infoTextView.contentInset = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 10.0, right: 10.0)
            self.infoTextView.layer.cornerRadius = 5
            self.infoTextView.clipsToBounds = true


     
            if show == 1 {
                self.infoTextView.isHidden = false
                self.view.addSubview(self.infoTextView)
            } else {
                self.infoTextView.isHidden = true
            }
        }
    }
}
