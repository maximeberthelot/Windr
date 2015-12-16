//
//  LoginClassViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

class LoginDefaultController: UIViewController {
    
    var isKeyboardIsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //----o Keyboard ? Openning or Hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //---o Hide Keyboard on swipe down
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismessKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        
        
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if(!isKeyboardIsOpen){
            self.view.frame.origin.y -= 150
            isKeyboardIsOpen = true
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if(isKeyboardIsOpen){
            self.view.frame.origin.y += 150
            isKeyboardIsOpen = false
        }
    }
    
    func switchView(){
        
        print("switch")
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Map") as UIViewController, animated: true, completion: nil)
        
        
    }
    
}