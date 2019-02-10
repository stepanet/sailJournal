//
//  PlacesViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 13.01.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//


//
//  Created by Dmitry Pyatin on 09.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
  //  var usersData:[UsersData]?
    var placesData:[PoiPlacesData]?
    var isSearching = false
    var filterTextFrom: String?
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var tableView: UITableView! //PLACES
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UsersViewController.reloaddata(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "PrimaryColor")
        return refreshControl
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.titleView = searchBar
        tableView.isHidden = false
        searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        //курсор
        textFieldInsideSearchBar?.tintColor = UIColor.white
        searchBar.returnKeyType = UIReturnKeyType.done
        self.tableView.addSubview(self.refreshControl)

    }

    @objc func reloaddata(_ refreshControl: UIRefreshControl) {
        
        (self.tabBarController as! UITabBarNewController).placeLoadJson()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if let refreshPlaceData = self.userDefaults.object(forKey: "refreshPlaceData")  {
                if refreshPlaceData as! Bool {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                        self.placesData = CoreDataHandler.fetchObjectPoi()
                        self.tableView.reloadData()
                        self.updateBadge()
                        self.userDefaults.setValue(false, forKey: "refreshPlaceData")
                        self.userDefaults.synchronize()
                    }
                }
            }
        }

        self.placesData = CoreDataHandler.fetchObjectPoi()
        self.tableView.reloadData()
        updateBadge()
        refreshControl.endRefreshing()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterTextFrom = ""
        placesData = CoreDataHandler.fetchObjectPoi()
        updateBadge()
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text != "") {
           
            filterTextFrom = searchBar.text!
            placesData = CoreDataHandler.filterDataPoi(filterText: searchBar.text!, strong: 0)
            updateBadge()
            tableView.reloadData()
        } else {
            filterTextFrom = ""
            placesData = CoreDataHandler.fetchObjectPoi()
            updateBadge()
            tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("UsersViewController viewWillAppear")
        
        tabBarController?.tabBar.isHidden = false
        
        if (searchBar.text != "") {
            filterTextFrom = searchBar.text!
            placesData = CoreDataHandler.filterDataPoi(filterText: searchBar.text!, strong: 0)
            updateBadge()
            tableView.reloadData()
        } else {
            filterTextFrom = ""
            placesData = CoreDataHandler.fetchObjectPoi()
            updateBadge()
            tableView.reloadData()
        }
        
        let animatedTable = userDefaults.object(forKey: "animation") as! Int
        
        if  animatedTable == 1 {
            
            animateTable()
            
        } else {
            
            self.tableView.reloadData()
        }
        
        updateBadge()
    }
    
    func updateBadge() {
        tabBarController?.tabBar.items![2].badgeValue = String(placesData!.count)
    }
    
    
    //получаем кол-во строчек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchBar.placeholder = "Интересных мест \(placesData!.count)"
        return placesData!.count
    }
    
    //переход на другой вьюконтроллер
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    //подготовка данных для пересылки во вьюконтроллер
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? PlacesDetailViewController {
            destination.selectedRow = (tableView.indexPathForSelectedRow?.row)
            destination.filterText = filterTextFrom
            
        }
        
    }
    
    //начитываем в строчки имена
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! customPlacesTableViewCell
        
        let latLongString = FrameworkKitClass.coordinateString(latitude: placesData![indexPath.row].lat, longitude: placesData![indexPath.row].lng, oneString: 1)
        
        //print("latLongString \(latLongString)")
        
        
        cell.textLbl.text = placesData![indexPath.row].name?.capitalized
        cell.locationLbl.text = latLongString //"lat:" + String(placesData![indexPath.row].lat)  + " " + "lng:" + String(placesData![indexPath.row].lng)
        cell.placesImg.image = UIImage(data: placesData![indexPath.row].imageData!)
        
//        let urlString = (placesData![indexPath.row].thumb)!
//
//        if urlString.contains("https://") && Reachability.isConnectedToNetwork() {
//            let url = URL(string: urlString)
//            //cell.placesImg.downloadedFrom(url: url!)
//
//            cell.placesImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
//
//        } else {
//
//            cell.placesImg.image = UIImage(named: "marinaWhite")
//        }

        return cell
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
}



