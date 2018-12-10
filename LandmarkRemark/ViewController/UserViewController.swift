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
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard loginPswTF.text != nil, loginNameTF.text != nil else {
            print("invaild username or password")
            return
        }
        
        self.login(name: loginNameTF.text!, password: loginPswTF.text!)
    }
    

    @IBAction func registerAction(_ sender: Any) {
        guard loginPswTF.text != nil, loginNameTF.text != nil else {
            print("invaild username or password")
            return
        }
        
        checkUserExist(name: loginNameTF.text!)
        
    }
    
    func checkUserExist(name:String) {
        
        let param = ["user_name":name] as [String:AnyObject]
        
        RequestManager.init(APIName: CHECK_EXIST_API, parameter: param).requestMany { (array, error) in
            guard error == nil else {
                print("check existing error:\(error)")
                return
            }
            print(" checkUserExist:\(array?.count)")
            self.register(name: self.loginNameTF.text!, password: self.loginPswTF.text!)
        }
    }
    
    func register(name:String,password:String){
        
        
        
        let param = ["user_name":name,"password":password] as [String:AnyObject]
        RequestManager.init(APIName: REGISTER_API, parameter: param).requestOne { (response, error) in
            
            guard error == nil else {
                print("REGISTER error:\(error?.localizedDescription)")
                return
            }
            self.login(name:name, password: password)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func login(name:String,password:String) {
        
        let param = ["user_name":name,"password":password] as [String:AnyObject]
        RequestManager.init(APIName: LOGIN_API, parameter: param).requestOne { (response, error) in
           
            print(response.debugDescription)
            
            guard error == nil else {
                print("login error:\(error?.localizedDescription)")
                return
            }
            
            self.standard.set(name, forKey: "username")
            self.standard.set(password, forKey: "password")
            
            self.dismiss(animated: true, completion: nil)
            
        }
       
    }
    
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
