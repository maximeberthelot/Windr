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
        
        let limit = limitR
        
        Alamofire.request(.GET, APIURL + "checkpoints", parameters: ["time": time, "ll" : ll, "mode": mode, "type": type, "token": token, "limit": limit])
            .responseJSON { response in
                
                if let data = response.result.value!["data"] as? NSObject {
                    
                    checkpointsData = data as! NSArray
                    
                    let dictionaryUser = Locksmith.loadDataForUserAccount("currentUser")
                    
                    //----o Save & Secure data info on DataCore
                    if((dictionaryUser) != nil){
                        print("update")
                        try! Locksmith.updateData(["checkpoints": checkpointsData, "token": token], forUserAccount: "currentUser")
                        
                    }
                    else{
                        
                        try! Locksmith.saveData(["checkpoints": checkpointsData, "token": token], forUserAccount: "currentUser")
                        
                        
                    }
                    
                    
                    completion(isFinished: true)


                }
                else{
                  print(response.result)
                }
                
        }
    }
    
}
