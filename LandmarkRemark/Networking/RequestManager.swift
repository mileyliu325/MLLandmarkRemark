//
//  RequestManager.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 9/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation
import KumulosSDK

class RequestManager{
    
    let APIName:String
    let param: [String:AnyObject]
    
    init(APIName:String,parameter:[String:AnyObject]) {
        self.APIName = APIName
        self.param = parameter
    }
    typealias CompletionHandler = (AnyObject?, NSError?) -> Void
    typealias CompletionHandler_2 = (Array<AnyObject>?,NSError?) -> Void
    
    func requestOne(completion:@escaping CompletionHandler) {
        
        Kumulos.call(self.APIName, parameters: param).success { (response, operation) in
            
            print("response:\(response.responseCode)")
            
            guard response.payload != nil else{
                completion(nil,nil)
                return
            }
            
            completion(response,nil)
            }.failure { (error, opertion) in
                
                completion(nil,error)
        }
    }
    
    func requestMany(completion:@escaping CompletionHandler_2){
        
        Kumulos.call(self.APIName, parameters: param).success { (response, operation) in
            
            if let array = response.payload as? Array<AnyObject>, array != nil {
                completion(array,nil)
            }else{
                completion(nil,nil)
            }
            
            }.failure { (error, opertion) in
                completion(nil,error)
        }
    }
}


