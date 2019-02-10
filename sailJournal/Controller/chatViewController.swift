//
//  chatViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 29.03.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit
import WebKit

class chatViewController: UIViewController {
    @IBOutlet weak var chatRoom: webChatWebView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var forwardBtn: UIBarButtonItem!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoom.scrollView.alwaysBounceVertical = false
        chatRoom.scrollView.alwaysBounceHorizontal = false
        
        if let currentUserToken = userDefaults.object(forKey: "user_token") {
        
        //https://sailjournal.com/mobile/6/conversations

        if let chatURL = URL(string: "https://sailjournal.com/mobile/\(currentUserToken)/conversations") {
            
            print(chatURL)
            
            let request = URLRequest(url: chatURL)
            chatRoom.loadRequest(request)
            
        }
    }
        
    }
    
    @IBAction func goBackAction(_ sender: UIBarButtonItem) {
        
        if chatRoom.canGoBack {
            chatRoom.goBack()
            
        }
    }
    
    @IBAction func goForwardAction(_ sender: UIBarButtonItem) {
        if chatRoom.canGoForward {
            chatRoom.goForward()
            
        }
        
    }
    

}
