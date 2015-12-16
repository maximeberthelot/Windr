//
//  ViewController.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 4/27/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import performSelector_swift
import UIColor_FlatColors
import Cartography
import ReactiveUI

var cardCounter = 0

class ZLSwipeableViewController: UIViewController {

    var swipeableView: ZLSwipeableView!
    
    var colors = ["Turquoise", "Green Sea", "Emerald"]
    var colorIndex = 0
    var loadCardsFromXib = true

    override func viewDidLayoutSubviews() {
        
        if(cardCounter < colors.count){
            print(cardCounter, colors.count)
            cardCounter += cardCounter
            
            super.viewDidLayoutSubviews()
            swipeableView.nextView = {
                return self.nextCardView()
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        //---o override func & rm useless els
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true

        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        
        
        //----o setContraint to our cards
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 150
        }
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }

        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = colorForName(colors[colorIndex])
        colorIndex++

        if loadCardsFromXib {
            let contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! UIView
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = cardView.backgroundColor
            cardView.addSubview(contentView)
            
            constrain(contentView, cardView) { view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
            }
        }
        return cardView
    }

    func colorForName(name: String) -> UIColor {
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
}

