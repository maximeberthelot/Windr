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

class LoginViewController: LoginDefaultController, FBSDKLoginButtonDelegate, UITextFieldDelegate{
    
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
            
            self.logOut()
            //self.switchView()
            //return
        
        }
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged in..")
        }
        else{
            self.switchView()
        }
        
        //------o Return Textfield
        InputMail.delegate = self
        InputPswd.delegate = self
        
    }
    
    //-----o Config FB & methode
    
    func setFBBtn(){
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        loginButton.frame = CGRectMake(20, 20, 200,45)
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    
    }
    
    func errorView(){
        
        let alert = UIAlertController(title: "Ops...!", message: "Une erreur c'est produite lors de votre authentification. Mail ou mot de passe invalide. :(", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        
        var message = ""
        
        if (!self.validate(InputMail.text!) || InputMail.text!.isEmpty) {
            
            message = InputMail.text!.isEmpty ? "Vous n'avez pas renseigné votre adresse mail" : "Adresse mail non valide"
            errorRegister(message)
            return
            
        }
        
        if(InputPswd.text!.characters.count >= 8 || InputPswd.text!.isValidPassword ){
            
            message = InputPswd.text!.isEmpty ? "Vous n'avez pas renseigné votre mot de passe" : "Votre mot de passe doit contenir plus de 8 caractères et doit être composé uniquement de chiffre et/ou de lettre"
            errorRegister(message)
            return
            
        }
        
        UserModel.login(InputMail.text!, pswd: InputPswd.text!) {
            (isFinished) -> Void in
            
            if(isFinished){
                self.switchView()
            }
            else{
                self.errorView()
            }
            
        }
    }
    
    func dismessKeyboard(){
        
        self.InputMail.resignFirstResponder()
        self.InputPswd.resignFirstResponder()
        
    }
    
    override func textFieldShouldReturn(_: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func logOut(){
        try! Locksmith.deleteDataForUserAccount("currentUser")
    }
    
    //-----o Error
    
    func errorRegister(message: String){
        
        let alert = UIAlertController(title: "Vous ne pouvez pas vous connecter", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "J'ai compris", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(YourEMailAddress)
    }

    
}