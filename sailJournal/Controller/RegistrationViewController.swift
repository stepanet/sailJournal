//
//  RegistrationViewController.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 07.03.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController , UITextFieldDelegate {

    
    
    @IBOutlet weak var userNameTextFld: UITextField!
    @IBOutlet weak var emailTextFld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordText: UITextField!
    @IBOutlet weak var registrationBtn: UIButton!
    
    var infoView = UIView()
    var infoTextView = UITextView()
    let okBtn = UIButton()
    let cancelBtn = UIButton()
    let activatedCodeTextField = UITextField()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        userNameTextFld.delegate = self
        emailTextFld.delegate = self
        passwordTextField.delegate = self
        rePasswordText.delegate = self
        
        //self.showInfoView(show: 1, description: "введите проверочный код для активации учетной записи")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backToLoginAction(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "registrationView", sender: self)
        self.performSegue(withIdentifier: "BackToLoginView", sender: self)
        
    }

    
    @IBAction func registrationBtnAction(_ sender: UIButton) {
        
        if (userNameTextFld.text?.count)! < 4  {
            
            self.alertShow(title: "упс, у вас проблемы", message: "имя пользователя меньше 4 символов",titleBtn: "попробуй еще раз" ,  style: .alert, actionMove: false)
            
        } else {
            
            let validEmail = isValidEmail(testStr: (emailTextFld.text)!)
            print(validEmail)
            
               //if (emailTextFld.text?.count)! < 6  {
                    if validEmail == false {
                    self.alertShow(title: "упс, у вас проблемы", message: "введите правильный email",titleBtn: "попробуй еще раз", style: .alert, actionMove: false)
    
                } else {
                    
                    if (passwordTextField.text?.count)! < 6 {

                        
                        self.alertShow(title: "упс, у вас проблемы", message: "пароль меньше 6 символов",titleBtn: "попробуй еще раз", style: .alert, actionMove: false)
                        
                    } else {
                        
                        if (passwordTextField.text == rePasswordText.text) {
                        
                            createJsonFileUserRegistration(name: userNameTextFld.text!, email: emailTextFld.text!)
                            self.showInfoView(show: 1, description: "введите проверочный код для активации учетной записи")
                        
                        } else {
                        
                            self.alertShow(title: "упс, у вас проблемы", message: "пароли не совпадают",titleBtn: "попробуй еще раз", style: .alert, actionMove: false)
                        
                    }
                }
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameTextFld.resignFirstResponder()
        self.emailTextFld.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.rePasswordText.resignFirstResponder()
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    
    func createJsonFileUserRegistration(name: String, email: String) {
        
        print("отправляем нового юзера на сервер - имя=\(name) email=\(email)")
            
        guard let url = URL(string: "https://s-j-egrozdev.c9users.io/getswift/7-Jr6slsYIBe1oGSn3qnQQ/online") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userRegistration = UserRegistrationData(name: name, email: email)
        
        do  {
            let jsonBody = try JSONEncoder().encode(userRegistration)
            request.httpBody = jsonBody

            
        } catch {}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print ("вывести значение json = \(json)")
                
            } catch {}
        }
        task.resume()
    }
    

    
    
    
    //MARK: диалоговое окно
    func alertShow(title: String, message: String, titleBtn: String, style: UIAlertControllerStyle, actionMove: Bool) {
        //создаем alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        //создаем кнопки нашего алертКонтроллера
        
        let actionButtonNo = UIAlertAction(title: titleBtn, style: .default) { (action) in
            
            if actionMove {
                    self.performSegue(withIdentifier: "tabBarstoryBoardRegist", sender: self) // BackToLoginView
            }
        }
        //добавим кнопки на алертКонтроллер
        alertController.addAction(actionButtonNo)
        //добавим текстовое поле на алерт контроллер
        //alertController.addTextField(configurationHandler: nil)
        
        //выведем наш алертКонтроллер
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }

    func showInfoView(show: Int, description: String) {
     
        let w = Int(Double(view.frame.size.width) / 1.2)
        let h = Int(Double(view.frame.size.height) / 1.77) //200
        let x = (Int(view.frame.size.width) - w)  / 2
        let y = ((Int(view.frame.size.height) - h)  / 2) // + h
        
        
        self.infoTextView.frame = CGRect(x: x, y: y, width: w, height: h)
        self.infoTextView.backgroundColor = UIColor(named: "PrimaryColor")
        self.infoTextView.textColor = UIColor.white
        self.infoTextView.textAlignment = .center
        self.infoTextView.text = description
        self.infoTextView.font = UIFont.systemFont(ofSize: 20)
        self.infoTextView.isEditable = false
        self.infoTextView.contentInset = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 10.0, right: 15.0)
        self.infoTextView.layer.cornerRadius = 10
        self.infoTextView.clipsToBounds = true
        
        print(self.infoTextView.bounds)
        print(self.infoTextView.bounds.width / 1.75)
        print(self.infoTextView.bounds.height / 1.15)
        print(self.infoTextView.bounds.width - self.infoTextView.bounds.width / 1.4)
        
        //настраиваем поля для ввода текста
        activatedCodeTextField.frame = CGRect(x:  (self.infoTextView.bounds.width - self.infoTextView.bounds.width / 1.3) / 2 , y: self.infoTextView.bounds.height / 2 - 55, width: self.infoTextView.bounds.width / 1.4, height: 55)
        activatedCodeTextField.layer.cornerRadius = 5
        activatedCodeTextField.clipsToBounds = true
        activatedCodeTextField.tintColor = UIColor(named: "PrimaryColor")
        activatedCodeTextField.backgroundColor = UIColor.white
        //activatedCodeTextField.placeholder = "введите проверочный код"
        activatedCodeTextField.textColor = UIColor(named: "PrimaryColor")
        activatedCodeTextField.textAlignment = .center
        activatedCodeTextField.contentMode = .center
        activatedCodeTextField.font = UIFont.systemFont(ofSize: 30)
        activatedCodeTextField.keyboardType = .decimalPad
      
        
        //настраиваем кнопку на окне проверки кода
        okBtn.frame = CGRect(x:  (self.infoTextView.bounds.width - self.infoTextView.bounds.width / 1.3) / 2 , y: self.infoTextView.bounds.height / 1.75, width: self.infoTextView.bounds.width / 1.4, height: 40)
        //okBtn.center = infoTextView.center
        okBtn.layer.cornerRadius = 5
        okBtn.clipsToBounds = true
        okBtn.tintColor = UIColor.white
        okBtn.backgroundColor = UIColor.gray
        okBtn.setTitle("проверить код", for: .normal)
        //okBtn.setTitle("проверяю код", for: .highlighted)
        okBtn.addTarget(self, action: #selector(checkActivatedNumber(sended:)), for: .touchDown)
        
        //настраиваем кнопку на окне проверки кода
        cancelBtn.frame = CGRect(x:  (self.infoTextView.bounds.width - self.infoTextView.bounds.width / 1.3) / 2, y: self.infoTextView.bounds.height / 1.45, width: self.infoTextView.bounds.width / 1.4, height: 40)
        //okBtn.center = infoTextView.center
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.clipsToBounds = true
        cancelBtn.tintColor = UIColor.white
        cancelBtn.backgroundColor = UIColor.gray
        cancelBtn.setTitle("отмена", for: .normal)
        //okBtn.setTitle("проверяю код", for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(cancelAction(sended:)), for: .touchDown)

        
        if show == 1 {
            infoTextView.isHidden = false
            okBtn.isHidden = false
            cancelBtn.isHidden = false
            activatedCodeTextField.isHidden = false
            self.view.addSubview(infoTextView)
            self.infoTextView.addSubview(okBtn)
            self.infoTextView.addSubview(cancelBtn)
            self.infoTextView.addSubview(activatedCodeTextField)
        } else {
            infoTextView.isHidden = true
            okBtn.isHidden = true
            cancelBtn.isHidden = true
            activatedCodeTextField.isHidden = true
        }
    }
    
    @objc func checkActivatedNumber(sended: UIButton) {
        if activatedCodeTextField.text?.count != 0 {
        //print("btn is pressed=\(activatedCodeTextField.text)")
            
            if activatedCodeTextField.text == "111111" {
     
                self.alertShow(title: "активация", message: "пользователь активирован",titleBtn: "вперед в плавание", style: .alert, actionMove: true)
                self.userDefaults.setValue(6, forKey: "user_id")
                self.userDefaults.setValue("Z255eUlMWnFocnRIM3EyUFZzbkR0Zz09LS1EeldyWDlBMTM2QjVWcGFBa3BaU0RBPT0=--1c5a29b3593868dcad2aaab2e2e870a80573e47c", forKey: "user_token")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.performSegue(withIdentifier: "tabBarstoryBoardRegist", sender: self)
                }
            }
        }
    }
    
    @objc func cancelAction(sended: UIButton) {

            self.alertShow(title: "регистрация", message: "регистрация пользователя отменена",titleBtn: "попробуй еще раз", style: .alert, actionMove: false)
            infoTextView.isHidden = true
            okBtn.isHidden = true
            cancelBtn.isHidden = true
            activatedCodeTextField.isHidden = true

    }
    
}
