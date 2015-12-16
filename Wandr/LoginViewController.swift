//
//  LoginViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import Locksmith
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: LoginDefaultController, FBSDKLoginButtonDelegate{
    
    @IBOutlet var InputMail: LoginTextField!
    @IBOutlet var InputPswd: LoginTextField!
    @IBAction func btnConnexion(sender: AnyObject){
        
        self.logIn()
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //-----o Set FB Connect
        self.setFBBtn()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if((Locksmith.loadDataForUserAccount("currentUser")) != nil){
            if(modeDEV){
                print(Locksmith.loadDataForUserAccount("myUserAccount"))
            }
            
            self.switchView()
        }
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged in..")
        }
        else{
            self.switchView()
        }
    }
    
    
    func setFBBtn(){
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        loginButton.frame = CGRectMake(20, 20, 200,45)
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        if error == nil{
            
            print("Login complete.")
            self.switchView()
            
        }
        else{
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("User logged out...")
    }
    
    
    //-------------o End FB API
    
    
    func logIn(){
        
        if(modeDEV){
            
            InputMail.text = "ryanchenkie@gmail.com"
            InputPswd.text = "secret"
            
        }
        
        UserModel.login(InputMail.text!, pswd: InputPswd.text!) {
            (isFinished) -> Void in
            
            if(isFinished){
                self.switchView()
            }
            
        }
    }
    
    func dismessKeyboard(){
        
        self.InputMail.resignFirstResponder()
        self.InputPswd.resignFirstResponder()
        
    }

    
}