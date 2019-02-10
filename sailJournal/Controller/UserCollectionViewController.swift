//
//  UserCollectionViewController.swift
//  sailJournal
//
//  Created by MacJack on 02.05.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class UserCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var usersData:[UsersData]?
    let userDefaults = UserDefaults.standard

    
    var userInfoArray: UserCollectionViewDetail?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.layer.cornerRadius = 10
        collectionView.dataSource = self
        collectionView.delegate = self
        self.usersData = CoreDataHandler.fetchObjectUsers()
        tabBarItem.badgeValue = String(usersData!.count)
    }


    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersData!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCollectionViewCell {
            
            cell.nameTxtLbl.text = usersData![indexPath.row].name?.capitalized
            cell.imageView.image = UIImage(data: usersData![indexPath.row].imageData!)
            return cell
        }
  
        return UICollectionViewCell()
 
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        //self.userInfoArray = UserCollectionViewDetail(name: usersData![indexPath.row].name!, imageData: usersData![indexPath.row].imageData)
        
        self.userInfoArray = UserCollectionViewDetail(name: usersData![indexPath.row].name!, imageData: usersData![indexPath.row].imageData, qualification: usersData![indexPath.row].qualification, totalNM: usersData![indexPath.row].totalNM, comment: usersData![indexPath.row].comment!, totalExpedition: usersData![indexPath.row].totalExpedition)     
        
        self.performSegue(withIdentifier: "showUserDetail", sender: [userInfoArray!])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserDetail" {
            if let vc = segue.destination as? DetailCollectionViewController {
                vc.userInfo = userInfoArray
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

}
