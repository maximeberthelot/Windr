//
//  LoginModel.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import Alamofire
import Locksmith
import UIKit

class UserModel {
    
    //----o Login to API -> token
    class func login(mail : String,pswd: String, completion: (isFinished: Bool) -> Void) -> Void{
        
        Alamofire.request(.POST, APIURL + "login", parameters: ["email": mail, "password" : pswd])
            .responseJSON { response in
                
                let status = response.result.value!.valueForKey("status") as! Int
                
                if (status == 200){
                    if let dataObject = response.result.value!["data"] as? NSObject {
                        
                        let token = dataObject.valueForKey("token") as! String
                        
                        completion(isFinished: true)
                        saveData(token, mail: mail)
                        
                    }
                    else{
                        completion(isFinished: false)
                        print("Request failed with error")
                    }

                }
                else{
                    
                    completion(isFinished: false)
                    print("Request failed with error")

                }
        }
    }
    
    //----o Register user to API -> status
    class func register(mail : String,pswd: String,name:String, completion: (isFinished: Bool) -> Void) -> Void{
        Alamofire.request(.POST, APIURL + "register", parameters: ["email": mail, "password" : pswd, "name": name])
            .responseJSON { response in
                
                let status = response.result.value!.valueForKey("status") as! Int
                
                if (status == 200){
                    if let dataObject = response.result.value!["data"] as? NSObject {
                        
                        let token = dataObject.valueForKey("token") as! String
                        
                        completion(isFinished: true)
                        saveData(token, mail: mail)
                        
                    }
                    else{
                        print("Request failed with error")
                    }
                    
                }
                else{
                    
                    completion(isFinished: false)
                    print("Request failed with error status")
                    
                }
                
        }
    }
    
    
    //----o Save & Secure data info on DataCore
    class func saveData(token: String, mail: String){
        
       let dictionaryUser = Locksmith.loadDataForUserAccount("currentUser")
        
        if((dictionaryUser) != nil){
            
            try! Locksmith.updateData(["token": token], forUserAccount: "currentUser")
            
        }
        else{
            
            try! Locksmith.saveData(["mail": "\(mail)", "token": token], forUserAccount: "currentUser")
            
            
        }
        
    }
    
}
