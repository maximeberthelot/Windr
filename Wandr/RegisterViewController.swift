//
//  RegisterViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class RegisterViewController: LoginDefaultController {
    @IBAction func RegisterBtn(sender: AnyObject) {
        self.registerToAPI()
    }

    @IBOutlet var InputName: LoginTextField!
    @IBOutlet var InputMail: LoginTextField!
    @IBOutlet var InputPswd: LoginTextField!
    
    override func viewWillAppear(animated: Bool) {
        
    
    }
    
    func dismessKeyboard(){
        
        self.InputMail.resignFirstResponder()
        self.InputName.resignFirstResponder()
        self.InputName.resignFirstResponder()
        
    }
    
    func errorView(){
        
        
    }
    
    func registerToAPI(){
        
        
        UserModel.register(InputMail.text!, pswd: InputPswd.text!, name: InputName.text!) {
            
            (isFinished) -> Void in
            
            if(isFinished){
                self.switchView()
            }
            else{
                self.errorView()
            }
        
        }
        
    }
    
}
