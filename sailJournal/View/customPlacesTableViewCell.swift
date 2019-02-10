//
//  customPlacesTableViewCell.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 11.01.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class customPlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placesCellView: UIView!
    @IBOutlet weak var placesImg: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var view: UIView!

    let userDefaults = UserDefaults.standard

    override func awakeFromNib() {
        super.awakeFromNib()

        placesImg.layer.cornerRadius = placesImg.frame.height / 2
        //view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))
        view.layer.borderColor = UIColor(named: "GrayColor")?.cgColor
        
    }
    
    func roundUI(radius: CGFloat) {

        view.layer.cornerRadius = radius
        
    }
    
    override func prepareForReuse() {

        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))
    }
    
}
