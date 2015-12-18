//
//  RegisterViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class RegisterViewController: LoginDefaultController, UITextFieldDelegate {
    @IBAction func RegisterBtn(sender: AnyObject) {
        self.registerToAPI()
    }

    @IBOutlet var InputName: LoginTextField!
    @IBOutlet var InputMail: LoginTextField!
    @IBOutlet var InputPswd: LoginTextField!
    
    override func viewWillAppear(animated: Bool) {
        
        //------o Return Textfield
        InputName.delegate = self
        InputMail.delegate = self
        InputPswd.delegate = self
    
    }
    
    func dismessKeyboard(){
        
        self.InputMail.resignFirstResponder()
        self.InputName.resignFirstResponder()
        self.InputName.resignFirstResponder()
        
    }
    
    func errorView(){
        
        let alert = UIAlertController(title: "Veuillez re-essayer", message: "Une erreur c'est produite", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func registerToAPI(){
        
        var message = ""

        if (!self.validate(InputMail.text!) || InputMail.text!.isEmpty) {
            
            message = InputMail.text!.isEmpty ? "Vous n'avez pas renseigné votre adresse mail" : "Adresse mail non valide"
            errorRegister(message)
            return
            
        }
    
        if(InputPswd.text!.characters.count >= 8 || !InputPswd.text!.isValidPassword ){
            
            message = InputPswd.text!.isEmpty ? "Vous n'avez pas renseigné votre mot de passe" : "Votre mot de passe doit contenir plus de 8 caractères et doit être composé uniquement de chiffre et/ou de lettre"
            errorRegister(message)
            return
            
        }
        
        if(InputName.text!.isEmpty){
        
            message = "Veuillez renseigner votre nom"
            errorRegister(message)
            return

        }

        
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
    
    override func textFieldShouldReturn(_: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func errorRegister(message: String){
    
        let alert = UIAlertController(title: "Vous ne pouvez pas vous inscrire", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "J'ai compris", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(YourEMailAddress)
    }
    
}
