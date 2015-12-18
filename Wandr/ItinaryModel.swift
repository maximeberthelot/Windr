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

class ItinaryModel {
   
    //----o get Checkpoints
    class func getCheckpoints(time: Int,ll: String, mode:String, type:String, token: String,completion: (isFinished: Bool) -> Void) -> Void{
        
        Alamofire.request(.GET, APIURL + "checkpoints", parameters: ["time": time, "ll" : ll, "mode": mode, "type": type, "token": token, "limit": limitR])
            .responseJSON { response in
                
                if let data = response.result.value!["data"] as? NSObject {
                    
                    checkpointsData = data as! NSArray
                    
                    let dictionaryCheckpoints = Locksmith.loadDataForUserAccount("checkpoints")
                    
                    //----o Save & Secure data info on DataCore
                    if((dictionaryCheckpoints) != nil){
                        
                        try! Locksmith.updateData(["checkpoints": checkpointsData], forUserAccount: "checkpoints")
                        
                         try! Locksmith.updateData(["time": time, "ll": ll, "mode":mode, "type": type], forUserAccount: "choose")
                        
                        completion(isFinished: true)
                        
                    }
                    else{
                        
                        try! Locksmith.saveData(["checkpoints": checkpointsData], forUserAccount: "checkpoints")
                        
                        completion(isFinished: true)
                        
                         try! Locksmith.saveData(["time": time, "ll": ll, "mode":mode, "type": type], forUserAccount: "choose")
                        
                    }
                }
                else{
                  print(response.result)
                }
                
        }
    }
    
    //----o get Checkpoints
    class func getItinirary(stepsArray: String,completion: (isFinished: Bool) -> Void) -> Void{
        
        //-----o Assign != var
        let dictionaryChoose = Locksmith.loadDataForUserAccount("choose")
        let dictionaryUser = Locksmith.loadDataForUserAccount("currentUser")
        
        
        var time = ""
        var mode = ""
        var ll = ""
        var type = ""
        var token = ""
        
        if  ((dictionaryChoose!["time"] as? Int) != nil) {
            time = "\(dictionaryChoose!["time"])"
        }
        if  ((dictionaryChoose!["ll"] as? String) != nil) {
            ll = dictionaryChoose!["ll"] as! String
        }
        if  ((dictionaryChoose!["mode"] as? String) != nil) {
            mode = dictionaryChoose!["mode"] as! String
        }
        if  ((dictionaryChoose!["type"] as? String) != nil) {
            type = dictionaryChoose!["type"] as! String
        }
        if  ((dictionaryUser!["token"] as? String) != nil) {
            token = dictionaryUser!["token"] as! String
        }
        
        Alamofire.request(.GET, APIURL + "calculate", parameters: ["time": time, "ll" : ll, "mode": mode, "type": type,"fs_ids": stepsArray, "token": token, "limit": limitR])
            .responseJSON { response in
               
                if let data = response.result.value!["data"] as? NSObject {
                    
                    try! Locksmith.saveData(["itinary": data], forUserAccount: "itinary")
                    
                    completion(isFinished: true)
                    
                }
                else{
                    print(response.result)
                }
                
        }
    }
    
}
