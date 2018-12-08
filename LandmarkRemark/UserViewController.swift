//
//  UserViewController.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 9/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit

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
        
        //if sucess
       self.register(name: loginNameTF.text!, password: loginPswTF.text!)
        
        self.login(name: loginNameTF.text!, password: loginPswTF.text!)
        
       
    }
    
    
    func register(name:String,password:String){
        
        
    }
    func login(name:String,password:String) {
        
        //login
        
        standard.set(loginNameTF.text!, forKey: "username")
        standard.set(loginPswTF.text!, forKey: "password")
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
