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
        
        Kumulos.call("checkUserExist", parameters: ["user_name":name as AnyObject])
            .success { (response, operation) in
                if let array = response.payload as? Array<AnyObject> {
                print("it's an array of objects, counts:\(array.count)")
                self.register(name: self.loginNameTF.text!, password: self.loginPswTF.text!)
            }else {
                print("this account have been registered,please use another name")}
                
            }.failure { (error, operation) in
                print("check existing error:\(error)")
        }
    }
    
    func register(name:String,password:String){
        
        Kumulos.call("reigster", parameters: ["user_name":name as AnyObject,"password":name as AnyObject]).success { (response, operation) in
            print("register sucess:\(response.payload)")
           
            self.login(name:name, password: password)
           
            }.failure { (error, operation) in
                print("registereroro:\(error)")
        }
    }
    
    func login(name:String,password:String) {
        
        Kumulos.call("login", parameters: ["user_name":name as AnyObject,"password":name as AnyObject]).success { (response, operation) in
            print("login sucess:\(response.payload)")
            
            self.standard.set(name, forKey: "username")
            self.standard.set(password, forKey: "password")
            
            self.dismiss(animated: true, completion: nil)
            
            }.failure { (error, operation) in
                print("login error:\(error)")
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
