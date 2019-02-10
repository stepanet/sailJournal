
//
//  SettingsTableViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 16.03.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit
//import Foundation

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var refreshDataLabel: UILabel!
    @IBOutlet weak var placeCountLbl: UILabel!
    @IBOutlet weak var usersCountLbl: UILabel!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var radiusLbl: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var clearBtn: UIButton!
    
    /* ключи userDefaults
     
     "updateDate"
     "placeCount"
     "userCount"
     "animation"
     "radius"
 */
    
    
    var usersData:[UsersData]?
    var placesData:[PoiPlacesData]?
    var todaysDate: String = ""
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
 
        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))
        radiusSlider.value = (self.userDefaults.object(forKey: "radius") as! Float)
        radiusLbl.text = String(Int(radiusSlider.value))
        getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("viewWillAppear SettingsTableViewController")
        let switchState = userDefaults.object(forKey: "animation") as! Int
        if  switchState == 1 {
            animationSwitch.isOn = true
        } else {
            animationSwitch.isOn = false
        }
        getData()
    }
    
    @IBAction func radiusChangeSlider(_ sender: UISlider) {
        radiusLbl.text = String(Int(radiusSlider.value))
        self.userDefaults.setValue(CGFloat(radiusSlider.value), forKey: "radius")
        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))
        
    }
    
    
    @IBAction func animationSwitchAction(_ sender: UISwitch) {
        
        if animationSwitch.isOn {
            
            print("switchOn")
            self.userDefaults.setValue(1, forKey: "animation")
        } else {
             print("switchOff")
            self.userDefaults.setValue(0, forKey: "animation")
        }
        
    }

    @IBAction func clearDataBtn(_ sender: UIButton) {
        refreshBtn.isEnabled = false
        placeCountLbl.text = "0"
        usersCountLbl.text = "0"
        CoreDataHandler.cleanDeletePoi()
        CoreDataHandler.cleanDeleteUsers()
        (self.tabBarController as! UITabBarNewController).placeLoadJson()
    }
    
    @IBAction func refreshDataBtn(_ sender: UIButton) {
        //let dateNow = FrameworkKitClass.datenow()
        refreshBtn.isEnabled = false
        placeCountLbl.text = "0"
        usersCountLbl.text = "0"
        
        (self.tabBarController as! UITabBarNewController).placeLoadJson()
        
        //старый вызов загрузки данных
//        (self.tabBarController as! UITabBarNewController).loadJson {
//            (self.tabBarController as! UITabBarNewController).loadJsonUser {
//            }
//        }
     
        //обновим данные
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if Reachability.isConnectedToNetwork(){

                //self.getData()

                self.refreshDataLabel.text = self.userDefaults.object(forKey: "updateDate") as? String
                self.placeCountLbl.text = self.userDefaults.object(forKey: "placeCount") as? String
                self.usersCountLbl.text = self.userDefaults.object(forKey: "userCount") as? String
                self.refreshBtn.isEnabled = true
                } else {
                self.refreshDataLabel.text = "НЕ ОБНОВЛЕНО"
                self.refreshBtn.isEnabled = true
            }
        }
  
    }

    
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        
//        view.tintColor = UIColor(named: "PrimaryColor")
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
//        header.textLabel?.textColor = UIColor.white
//        header.textLabel?.textAlignment = .center
//
//    }
  
    
    public func getData() {
        
        print("запустили getdate!!!!!!")
        
        self.placesData = CoreDataHandler.fetchObjectPoi()
        self.usersData = CoreDataHandler.fetchObjectUsers()
        
        self.placeCountLbl.text = String(self.placesData!.count)
        self.usersCountLbl.text = String(self.usersData!.count)

    }
        
    
    func roundUI(radius: CGFloat) {
        refreshBtn.layer.cornerRadius = radius
        clearBtn.layer.cornerRadius = radius
       // placeCountLbl.layer.cornerRadius = radius
       // usersCountLbl.layer.cornerRadius = radius
       // refreshDataLabel.layer.cornerRadius = radius
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
