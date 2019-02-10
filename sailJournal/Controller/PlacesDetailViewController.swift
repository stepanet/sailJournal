//
//  PlacesDetailViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 13.01.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit
import MapKit


class PlacesDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    //var user:Users?
    var selectedRow:Int?
    var placesData:[PoiPlacesData]?
    var filterText: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if filterText == "" {
            
            placesData = CoreDataHandler.fetchObjectPoi()
            
        } else {
            
            placesData = CoreDataHandler.filterDataPoi(filterText: filterText!, strong: 0)
        }

        
        //отрисуем карту
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let location = CLLocationCoordinate2DMake(placesData![selectedRow!].lat, placesData![selectedRow!].lng)
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        let latLngString = FrameworkKitClass.coordinateString(latitude: placesData![selectedRow!].lat, longitude: placesData![selectedRow!].lng, oneString: 0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = placesData![selectedRow!].name?.capitalized
        annotation.subtitle = latLngString//"добро пожаловать"
        
        mapView.addAnnotation(annotation)
        
        
        //конец отрисуем карту

        //placesData = CoreDataHandler.fetchObjectPoi()
        imageView.layer.cornerRadius = 5
        nameLbl.layer.cornerRadius = 5
        locationLbl.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        
        let a: CGPoint = CGPoint(x: 0, y: 0)
        commentTextView.setContentOffset(a, animated: true)

        commentTextView.layer.cornerRadius = 5
        commentTextView.textContainerInset.left = 10
        commentTextView.textContainerInset.right = 10

        nameLbl?.text = placesData![selectedRow!].name?.capitalized
        
        let latLongString = FrameworkKitClass.coordinateString(latitude: placesData![selectedRow!].lat, longitude: placesData![selectedRow!].lng, oneString: 1)

        //locationLbl.text = ("lat:" + String(placesData![selectedRow!].lat) + "\n" + "lng:" + String(placesData![selectedRow!].lng))
        locationLbl.text = latLongString
        
        
        
        commentTextView.text = placesData![selectedRow!].descriptionplace
        
       imageView.image = UIImage(data: placesData![selectedRow!].imageData!)
        
        
//        let urlString = placesData![selectedRow!].picture
//
//        
//        if (urlString?.contains("https://"))! && Reachability.isConnectedToNetwork() {
//            imageView.image = UIImage(named: "")
//            let url = URL(string: urlString!)
//            imageView.downloadedFrom(url: url!, contentMode: .scaleToFill)
//        } else {
//            
//            print("no photo")
//        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    

}
