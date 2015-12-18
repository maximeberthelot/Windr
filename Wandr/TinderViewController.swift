//
//  TinderView.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import ReactiveUI
import Locksmith

class TinderViewController: UIViewController {
    
    var shouldSwipe = true
    
    override func viewDidLoad() {
        //------o set to default
        
        radiusMap = []
        cardCounter = 0
        keepStep = []
        currentIndex = 0
        
        
        super.viewDidLoad()
        
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        draggableBackground.backLabel.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        draggableBackground.goBtn.addTarget(self, action: "switchToItinary:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(draggableBackground)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    //------o Back to choose view
    func pressed(sender: UIButton!) {
        
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Default") as UIViewController, animated: true, completion: nil)
        

    }
    
    //-----o go To Itanary
    func switchToItinary(sender: UIButton!) {
        
        if(keepStep.count == 0){
            errorView()
            return
        }
    
        let stepToString = (keepStep as! [String]).joinWithSeparator(",")
        
        ItinaryModel.getItinirary(stepToString){
            
            (isFinished) -> Void in
            
            if(isFinished){
                self.goToIT()
            }
            else{
                self.errorView()
            }
            
        }
    
    }
    
    func goToIT(){
    
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Itinary") as UIViewController, animated: true, completion: nil)
    
    }
    
    
    func errorView(){
        
        let alert = UIAlertController(title: "Ops..!", message: "Choisissez au moins un point de passage :)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
