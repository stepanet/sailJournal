//
//  LoginViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 05.03.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    struct UserID: Decodable {
        let user_id: Int
        let user_token: String
    }

    let userDefaults = UserDefaults.standard
    var userID = [UserID]() //json User_ID
    var email: String?
    var password: String?
    var logError = false

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if checkURL(user: email!, password: password!) {
            
            loadJsonUserID(user: email!, password: password!, completed: {
            self.performSegue(withIdentifier: "tabBarStoryBoard", sender: self)})
        } else {
            self.alertShow(title: "у вас проблемы", message: "неверный пароль или логин", style: .alert)
        }
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "registrationView", sender: self) --запрос на вебрегистрацию
        self.performSegue(withIdentifier: "RegistrView", sender: self)
    }
    
    //MARK - check url
    func checkURL(user: String, password: String) -> Bool {
        if URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/login?email=\(user)&password=\(password)") != nil {
            print("true")
            return true
        } else {
             print("false")
            return false
        }
    }
    
    
    //MARK - получение идентификатора пользователя
    public func loadJsonUserID (user: String, password: String, completed: @escaping () ->()) {
 
        if let url = URL(string: "https://sailjournal.com/getswift/7-Jr6slsYIBe1oGSn3qnQQ/login?email=\(user)&password=\(password)") {
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                do {
                    self.userID = try JSONDecoder().decode([UserID].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                        for u in self.userID {
                            self.userDefaults.setValue(u.user_id, forKey: "user_id")
                            self.userDefaults.setValue(u.user_token, forKey: "user_token")
                            self.userDefaults.setValue(0, forKey: "animation")
                            self.userDefaults.setValue(CGFloat(5), forKey: "radius")
                            self.userDefaults.synchronize()
                        }
    
                    }
                    print("JSON user_id load LoginViewController.swift")
                } catch {
                    print("JSON user_id load error LoginViewController.swift")
                    
                    self.userDefaults.removeObject(forKey: "user_id")
                    self.userDefaults.removeObject(forKey: "user_token")
                    self.userDefaults.synchronize()
                    DispatchQueue.main.async {
                    self.alertShow(title: "у вас проблемы", message: "неверный пароль или логин", style: .alert)
                    }
                }
            }
            }.resume()
    }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    //MARK: диалоговое окно
    func alertShow(title: String, message: String, style: UIAlertControllerStyle) {
        //создаем alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        //создаем кнопки нашего алертКонтроллера

        let actionButtonNo = UIAlertAction(title: "попробуй еще разок", style: .default) { (action) in
           
        }
        //добавим кнопки на алертКонтроллер
        alertController.addAction(actionButtonNo)
        //добавим текстовое поле на алерт контроллер
        //alertController.addTextField(configurationHandler: nil)
        
        //выведем наш алертКонтроллер
        self.present(alertController, animated: true, completion: nil)
    }


}
