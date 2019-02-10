//
//  Created by Dmitry Pyatin on 09.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class UserDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qualification: UILabel!
    @IBOutlet weak var totalNM: UILabel!
    @IBOutlet weak var totalExpedition: UILabel!
    @IBOutlet weak var backDetailView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedRow:Int?
    var filterText: String?
    var usersData:[UsersData]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        if filterText == "" {
            
            usersData = CoreDataHandler.fetchObjectUsers()
            
        } else {
            
            usersData = CoreDataHandler.filterDataUser(filterText: filterText!, strong: 0)
        }

        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        nameLbl.layer.cornerRadius = 5
        qualification.layer.cornerRadius = 5
        totalNM.layer.cornerRadius = 5
        commentTextView.layer.cornerRadius = 5
        totalExpedition.layer.cornerRadius = 5
        backDetailView.layer.cornerRadius = 5
        commentTextView.textContainerInset.left = 10
        commentTextView.textContainerInset.right = 10
        
//        print("выбранная ячейка \(String(describing: selectedRow))")
     
        nameLbl.text = usersData![selectedRow!].name?.capitalized
        qualification.text = usersData![selectedRow!].qualification
        totalNM.text = String(usersData![selectedRow!].totalNM) + " миль за кормой"
        commentTextView.text = usersData![selectedRow!].comment
        totalExpedition.text = String(usersData![selectedRow!].totalExpedition) + " маршрут(ов)"
        imageView.image = UIImage(data: usersData![selectedRow!].imageData!)
        
//        let urlString = (usersData![selectedRow!].photourl)!
//        let url = URL(string: urlString)
//
//        if Reachability.isConnectedToNetwork() {
//            imageView.downloadedFrom(url: url!)
//        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
  
}
