//
//  TinderView.swift
//  Wandr
//
//  Created by Maxime Berthelot on 16/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import ReactiveUI

class TinderViewController: ZLSwipeableViewController {
    
    var shouldSwipe = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultHandler = swipeableView.shouldSwipeView
        swipeableView.shouldSwipeView = {(view: UIView, movement: Movement, swipeableView: ZLSwipeableView) in
            self.shouldSwipe && defaultHandler(view: view, movement: movement, swipeableView: swipeableView)
        }
    }
    
}
