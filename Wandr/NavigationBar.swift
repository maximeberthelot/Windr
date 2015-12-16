//
//  LoginClassViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

class NavigationBar: UINavigationBar {
    
    override func viewDidAppear(){
        
        var navBarTitleView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.width, 44.0))
        navBarTitleView.backgroundColor = UIColor.brownColor()
        self.navigationItem.titleView = navBarTitleView
        
    }
}