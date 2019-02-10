//
//  CustomTableViewCell.swift
//  sailJournal
//
//  Created by Dmitry Pyatin on 14.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var detailTextLbl: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var totalNM: UILabel!
    
    let userDefaults = UserDefaults.standard

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
        //cellView.layer.cornerRadius = 5
        totalNM.layer.borderWidth = 1
        totalNM.layer.borderColor = UIColor.darkGray.cgColor
        //totalNM.layer.cornerRadius = 5
        imageCell.layer.cornerRadius =
        imageCell.frame.height / 2
        //view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "GrayColor")?.cgColor
        
        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))

  
    }
    
    func roundUI(radius: CGFloat) {
        
        cellView.layer.cornerRadius = radius
        totalNM.layer.cornerRadius = 5
        view.layer.cornerRadius = radius

    }
    
    override func prepareForReuse() {
        roundUI(radius: (self.userDefaults.object(forKey: "radius") as! CGFloat))
    }
  
}
