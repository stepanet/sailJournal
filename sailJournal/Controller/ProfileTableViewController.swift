//
//  ProfileTableViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 01.03.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit



class ProfileTableViewController: UITableViewController {
    
    var usersData:[UsersData]?
    var searchText: String?
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePictures: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var aboutUserTextView: UITextView!
    @IBOutlet weak var logOutBtn: UIButton!
    
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictures.layer.cornerRadius = profilePictures.frame.height / 2
        profilePictures.clipsToBounds = true
        aboutUserTextView.textContainerInset.left = 10
        aboutUserTextView.textContainerInset.right = 10
        
        
        //read data from database
        if let currentUser = userDefaults.object(forKey: "user_id") {
            print("ProfileTableViewController user found \(currentUser)")
            
            searchText = "\(currentUser)"
            usersData = CoreDataHandler.filterDataUser(filterText: searchText!, strong: 1)
            
            nameTextField.text = usersData?[0].name?.capitalized
            emailTextField.text = usersData?[0].email
            aboutUserTextView.text = usersData?[0].comment
            profilePictures.image = UIImage(data: (usersData?[0].imageData)!)
            
//            let urlString = (usersData![0].photourl)!
//            if urlString.contains("https://") && Reachability.isConnectedToNetwork() {
//                let url = URL(string: urlString)
//                profilePictures.downloadedFrom(url: url!)
//            } else {
//
//                profilePictures.image = UIImage(named: "no_avatar")
//            }
            
            }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentUser = userDefaults.object(forKey: "user_id") {
            print("ProfileTableViewController user found \(currentUser)")
            
            searchText = "\(currentUser)"
            usersData = CoreDataHandler.filterDataUser(filterText: searchText!, strong: 1)
            
            nameTextField.text = usersData?[0].name?.capitalized
            emailTextField.text = usersData?[0].email
            aboutUserTextView.text = usersData?[0].comment
            profilePictures.image = UIImage(data: (usersData?[0].imageData)!)
            
//            let urlString = (usersData![0].photourl)!
//            if urlString.contains("https://") && Reachability.isConnectedToNetwork() {
//                let url = URL(string: urlString)
//                profilePictures.downloadedFrom(url: url!)
//            } else {
//                
//                profilePictures.image = UIImage(named: "no_avatar")
//            }
            
        }
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        //self.userDefaults.setValue(0, forKey: "user_id")
        self.userDefaults.removeObject(forKey: "user_id")
        self.userDefaults.synchronize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
