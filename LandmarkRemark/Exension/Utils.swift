//
//  Utils.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 10/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation
import UIKit

func getSimpleAlert (title: String, message:String) ->UIAlertController{
    
    let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    return alert
}

func getErrorAlert (error:NSError?) ->UIAlertController{
    
    let alert = getSimpleAlert(title: "ERROR", message: "\(error.debugDescription)")
    
    return alert
}

let standard = UserDefaults.standard

func checkIfLogin()->Bool{
    
    if let _ = standard.string(forKey: "username"), let _ = standard.string(forKey: "password"){
        return true
    }else {return false}
}

func userdefaultLogin (name:String,password:String
    ) {
    standard.set(name, forKey: "username")
    standard.set(password, forKey: "password")
}
func userdefaultLogout () {
    
    standard.removeObject(forKey: "username")
    standard.removeObject(forKey: "password")
    
}
