//
//  UserViewController.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 9/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import KumulosSDK

class UserViewController: UIViewController {
    
    @IBOutlet weak var loginNameTF: UITextField!
    @IBOutlet weak var loginPswTF: UITextField!
    
    let standard = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button Action
    @IBAction func loginAction(_ sender: Any) {
        
        guard loginPswTF.text != nil, loginNameTF.text != nil else {
            return
        }
        self.login(name: loginNameTF.text!, password: loginPswTF.text!)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard loginPswTF.text != nil, loginNameTF.text != nil else {
            print("invaild username or password")
            return
        }
        //check is duplicated user
        checkUserExist(name: loginNameTF.text!)
    }
    
    func checkUserExist(name:String) {
        
        let param = ["user_name":name] as [String:AnyObject]
        
        RequestManager.init(APIName: CHECK_EXIST_API, parameter: param).requestMany { (array, error) in
            guard error == nil else {
                
               let alert = getErrorAlert(error: error)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            if array?.count == 0 {
                self.register(name: self.loginNameTF.text!, password: self.loginPswTF.text!)
            }
        }
    }
    
    func register(name:String,password:String){
        
        let param = ["user_name":name,"password":password] as [String:AnyObject]
        RequestManager.init(APIName: REGISTER_API, parameter: param).requestOne { (response, error) in
            
            guard error == nil else {
                return
            }
            let alert = UIAlertController(title: "SUCESS", message: "Register sucessful", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                
                self.login(name:name, password: password)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func login(name:String,password:String) {
        
        let param = ["user_name":name,"password":password] as [String:AnyObject]
        RequestManager.init(APIName: LOGIN_API, parameter: param).requestOne { (response, error) in
            
            print(response.debugDescription)
            
            guard error == nil else {
                
                let alert = getErrorAlert(error: error)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            userdefaultLogin(name:name,password:password)
            
            let alert = UIAlertController(title: "SUCESS", message: "Login sucessful", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
