//
//  DetailCollectionViewController.swift
//  sailJournal
//
//  Created by MacJack on 02.05.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class DetailCollectionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 5
            guard let image = userInfo?.imageData else { return }
            imageView.image = UIImage(data: image)
            
        } }
    
    @IBOutlet weak var commentTextView: UITextView!        { didSet { guard let comment = userInfo?.comment else { return }
        commentTextView.text = comment
        commentTextView.layer.cornerRadius = 5
        }}
    
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet { nameLabel.text = userInfo?.name
            nameLabel.layer.cornerRadius = 5
        }}


    @IBOutlet weak var qualificationLabel: UILabel! {
        didSet { guard let qualification = userInfo?.qualification else { return }
            qualificationLabel.text = qualification
            qualificationLabel.layer.cornerRadius = 5
        }}

    @IBOutlet weak var totalExpeditionLabel: UILabel! {
        didSet { guard let totalExpedition = userInfo?.totalExpedition else { return }
            totalExpeditionLabel.text = String(totalExpedition)
            totalExpeditionLabel.layer.cornerRadius = 5
        }}

    @IBOutlet weak var totalNMLabel: UILabel! {
        didSet { guard let totalNM = userInfo?.totalNM else { return }
            totalNMLabel.text = String(totalNM)
            totalNMLabel.layer.cornerRadius = 5
        }}

    
    var nameCapitan: String?
    var imageData: Data?
    var userInfo: UserCollectionViewDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // commentLabel.text = userInfo?.comment
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}
