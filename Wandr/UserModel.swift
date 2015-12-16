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
            
                if let tokenObject = response.result.value!["token"] as? NSObject {
                    
                    completion(isFinished: true)
                    saveData(tokenObject as! String, mail: mail)
                    
                }
                else{
                    print("Request failed with error")
                }
            
        }
    }
    
    //----o Register user to API -> status
    class func register(mail : String,pswd: String,name:String, completion: (isFinished: Bool) -> Void) -> Void{
        
        Alamofire.request(.POST, APIURL + "register", parameters: ["email": mail, "password" : pswd, "name": name])
            .responseJSON { response in
                
                if let status = response.result.value!["status"] as? NSObject {
                    
                    completion(isFinished: true)
                    
                    if(status == 200){
                       // saveData(tokenObject as! String, mail: mail)
                    }
                    
                }
                else{
                    print("Request failed with error")
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
