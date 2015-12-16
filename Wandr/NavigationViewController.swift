//
//  NavigationViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import Foundation


class NavigationViewController : UINavigationController{


    override func viewDidAppear(animated: Bool) {
        
        let titleButton: UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height: 32))
        
        titleButton.setTitle("Wandr",forState: UIControlState.Normal)
        titleButton.titleLabel!.font = UIFont(name:"", size: 20.0)
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.navigationItem.titleView = titleButton

    }

}