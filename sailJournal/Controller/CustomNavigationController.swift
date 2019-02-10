//
//  CustomNavigationController.swift
//  sailJournal
//
//  Created by Dmitry Pyatin on 15.12.2017.
//  Copyright © 2017 Dmitry Pyatin. All rights reserved.
//

import UIKit
//import Foundation

class CustomNavigationController: UINavigationController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true;
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.backgroundColor = UIColor(named: "PrimaryColor")
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
