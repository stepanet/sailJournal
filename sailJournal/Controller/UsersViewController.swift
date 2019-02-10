
//
//  Created by Dmitry Pyatin on 09.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit


class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //@IBOutlet weak var navigationText: UserNavigationItem!
    
    var usersData:[UsersData]?
    var isSearching = false
    var filterTextFrom: String?
 

    @IBOutlet weak var tableView: UITableView! //USERS
    @IBOutlet weak var searchBar: UISearchBar!
    let userDefaults = UserDefaults.standard
    
    
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
        searchBar.barTintColor = UIColor(named: "PrimaryColor")
        searchBar.returnKeyType = UIReturnKeyType.done
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        //курсор
        textFieldInsideSearchBar?.tintColor = UIColor.white
        
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.placeholder = "Введите имя"
        self.tableView.addSubview(self.refreshControl)

    }
    

    @objc func reloaddata(_ refreshControl: UIRefreshControl) {

        tabBarController?.tabBar.isHidden = true
        (self.tabBarController as! UITabBarNewController).placeLoadJson()

//        let myVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! UITabBarNewController

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if let refreshUserData = self.userDefaults.object(forKey: "refreshUserData")  {
            if refreshUserData as! Bool {
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    self.usersData = CoreDataHandler.fetchObjectUsers()
                    self.tableView.reloadData()
                    self.userDefaults.setValue(false, forKey: "refreshUserData")
                    self.userDefaults.synchronize()
                }
            }
            }
        }

        self.usersData = CoreDataHandler.fetchObjectUsers()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        tabBarController?.tabBar.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterTextFrom = ""
        usersData = CoreDataHandler.fetchObjectUsers()
        updateBadge()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (searchBar.text != "") {
            filterTextFrom = searchBar.text!
            usersData = CoreDataHandler.filterDataUser(filterText: searchBar.text!, strong: 0)
            updateBadge()
            tableView.reloadData()
        } else {
            filterTextFrom = ""
            usersData = CoreDataHandler.fetchObjectUsers()
            updateBadge()
            tableView.reloadData()
        }
    }
    
    func reloadDataTableView() {
        usersData = CoreDataHandler.fetchObjectUsers()
        updateBadge()
        tableView.reloadData()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("UsersViewController viewWillAppear")
        
        
        tabBarController?.tabBar.isHidden = false
        
        if (searchBar.text != "") {
            filterTextFrom = searchBar.text!
            usersData = CoreDataHandler.filterDataUser(filterText: searchBar.text!, strong: 0)
            updateBadge()
            tableView.reloadData()
        } else {
            filterTextFrom = ""
            usersData = CoreDataHandler.fetchObjectUsers()
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
       tabBarController?.tabBar.items![1].badgeValue = String(usersData!.count)
    }
    
 
    //получаем кол-во строчек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tabBarItem.badgeValue = String(usersData!.count)
        self.searchBar.placeholder = "Участников \(usersData!.count)"
        return usersData!.count
    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "section"
//    }
    
    //переход на другой вьюконтроллер
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        _ = self.navigationController?.popToRootViewController(animated: true)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    //подготовка данных для пересылки во вьюконтроллер
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if let destination = segue.destination as? UserDetailViewController {
            destination.selectedRow = (tableView.indexPathForSelectedRow?.row)
            destination.filterText = filterTextFrom
        }

    }
    
    //начитываем в строчки имена
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell

        cell.textLbl.text = usersData![indexPath.row].name?.capitalized
        cell.detailTextLbl.text = usersData![indexPath.row].qualification
        
        let b = (usersData![indexPath.row].qualification)
        if b == "---" {
            cell.detailTextLbl.isHidden = true
        } else {
            cell.detailTextLbl.isHidden = false
        }
        
        cell.totalNM.text = String(usersData![indexPath.row].totalNM) + "NM"
        
        let a = (String(usersData![indexPath.row].totalNM))
        if a == "0.0" {
            cell.totalNM.isHidden = true
        } else {
            cell.totalNM.isHidden = false
        }
        
        cell.imageCell.image = UIImage(data: usersData![indexPath.row].imageData!)

//        let urlString = (usersData![indexPath.row].photourl)!
//        if urlString.contains("https://") && Reachability.isConnectedToNetwork() {
//                let url = URL(string: urlString)
//                cell.imageCell.downloadedFrom(url: url!)
//            } else {
//                cell.imageCell.image = UIImage(named: "no_avatar")
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
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    

}


