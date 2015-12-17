//
//  TinderView.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import ReactiveUI

class TinderViewController: UIViewController {
    
    var shouldSwipe = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        draggableBackground.backLabel.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(draggableBackground)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    //------o Back to choose view
    func pressed(sender: UIButton!) {
        
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Default") as UIViewController, animated: true, completion: nil)
        

    }
    
}
