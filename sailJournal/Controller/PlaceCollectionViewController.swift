//
//  PlaceCollectionViewController.swift
//  sailJournal
//
//  Created by MacJack on 02.05.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//


import UIKit


class PlaceCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var usersData:[UsersData]?
    var placesData:[PoiPlacesData]?
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.layer.cornerRadius = 10
        collectionView.dataSource = self
        collectionView.delegate = self
        self.placesData = CoreDataHandler.fetchObjectPoi()
       // tabBarItem.badgeValue = String(placesData!.count)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return placesData!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCollectionViewCell {
            
            cell.nameTxtLbl.text = placesData![indexPath.row].name
            cell.imageView.image = UIImage(data: placesData![indexPath.row].imageData!)
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.placesData = CoreDataHandler.fetchObjectPoi()
        collectionView.reloadData()
       // tabBarItem.badgeValue = String(placesData!.count)
    }
    
}

