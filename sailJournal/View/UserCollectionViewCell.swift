//
//  UserCollectionViewCell.swift
//  sailJournal
//
//  Created by MacJack on 02.05.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTxtLbl: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        imageView.clipsToBounds = true
    imageView.layer.cornerRadius = imageView.frame.height / 2
    
    
    }

}
