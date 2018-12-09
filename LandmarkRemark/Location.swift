//
//  Location.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 9/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation
struct Location :Decodable{
    
    var latitude: Float
    var longitude:Float
    var user_name: String
    var note:String
  
    var locationID:Int
    
    
    init(with dictionary: [String: Any]) {

        latitude = (dictionary["latitude"] as? NSNumber)!.floatValue
        longitude = (dictionary["longitude"] as? NSNumber)!.floatValue
        user_name = dictionary["user_name"] as! String
        note = dictionary["note"] as! String
      
        locationID = (dictionary["locationID"] as? NSNumber)!.intValue

    }
}
