//
//  DraggableViewBackground.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import UIKit
import Locksmith

class DraggableViewBackground: UIView, DraggableViewDelegate {
    var exampleCardLabels: [String]!
    var cardsData = []
    var allCards: [DraggableView]!

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    var labelTop: UILabel!
    var titleTop: UILabel!
    var backLabel: UIButton!
    var titlePageTop: UILabel!
    var goBtn: UIButton!
    var imageCard: UIImage!
    var dataURLImg = NSData()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        
        //----o Take data from API
        if let dictionaryUser = Locksmith.loadDataForUserAccount("currentUser") {
            if let checkpointsData = dictionaryUser["checkpoints"] as? NSArray {
                cardsData = checkpointsData
            }
        }
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
        
    }

    func setupView() -> Void {
        
        self.backgroundColor = UIColor.whiteColor()
        
        //---o Add Banner top
        labelTop = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, 65))
        labelTop.backgroundColor = greenColor
        
        //---o Add title
        titleTop = UILabel(frame: CGRectMake(0, 30, self.frame.size.width, 35))
        titleTop.text = "Wandr"
        titleTop.textColor = UIColor.whiteColor()
        titleTop.textAlignment = NSTextAlignment.Center
        titleTop.font = UIFont(name: "Enso", size: 22)
        
        //---o Add Back btn
        backLabel = UIButton(frame: CGRectMake(0, 20, 100, 35))
        backLabel.setTitle("Retour", forState: UIControlState.Normal)
        backLabel.titleLabel!.textColor = UIColor.whiteColor()
        backLabel.titleLabel!.font = UIFont(name: "Avenir-Light", size: 15)
        
        //-----o Btn Tinder
        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 35, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)

        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //---o Add title Page
        titlePageTop = UILabel(frame: CGRectMake(0, 85, self.frame.size.width, 35))
        titlePageTop.text = "Choisissez vos checkpoints"
        titlePageTop.textColor = greenColor
        titlePageTop.textAlignment = NSTextAlignment.Center
        titlePageTop.font = UIFont(name: "Avenir-Black", size: 22)
        
        //---o Add Back btn
        goBtn = UIButton(frame: CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height - 60, 200, 50))
        goBtn.setTitle("J'ai assez de point !", forState: UIControlState.Normal)
        goBtn.titleLabel!.textColor = UIColor.whiteColor()
        goBtn.titleLabel!.textAlignment = NSTextAlignment.Center
        goBtn.layer.cornerRadius = 25
        goBtn.backgroundColor = greenColor
        goBtn.titleLabel!.font = UIFont(name: "Avenir-Medium", size: 17)

        
        //------o Add to subView
        self.addSubview(labelTop)
        self.addSubview(backLabel)
        self.addSubview(titleTop)
        self.addSubview(titlePageTop)
        self.addSubview(xButton)
        self.addSubview(checkButton)
        self.addSubview(goBtn)
    }
    
    func pressed(sender: UIButton!) {
        
        
        print("back")
        
        
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT))
    
        if let cardData = cardsData[index] as? NSObject {
            if let img = cardData.valueForKey("photo_original") as? NSString {
               
                load_image(img as String){
                    (isFinished) -> Void in
                    
                    if(isFinished){
                        draggableView.image = UIImage(data : self.dataURLImg)
                        draggableView.imageCover = UIImageView(image: draggableView.image)
                        draggableView.imageCover!.frame = CGRectMake(0,0,draggableView.frame.size.width,draggableView.frame.size.height)
                        draggableView.imageCover.contentMode = UIViewContentMode.ScaleAspectFill
                        
                        
                        //-----o addGrad
                        draggableView.imageGrad = UIImage(named: "grad")
                        draggableView.imageGradView = UIImageView(image: draggableView.imageGrad!)
                        draggableView.imageGradView!.frame = CGRectMake(0,150,draggableView.frame.size.width,250)
                        
                        
                        //-----o add Grad+ Img
                        draggableView.addSubview(draggableView.imageCover)
                        draggableView.addSubview(draggableView.imageGradView)
                        
                    }

                }
                
            }
            
            
            if let rating = cardData.valueForKey("rating") as? Int{
                
                print(rating)
                
                //-----o addCheckImage
                draggableView.imageCheck = UIImage(named: "1stars")
                draggableView.imgCheckView = UIImageView(image: draggableView.imageCheck!)
                draggableView.imgCheckView!.frame = CGRectMake(20,draggableView.frame.size.height - 60,91.5,14)
                
                draggableView.addSubview(draggableView.imgCheckView)

            }
        }
        
        
        draggableView.overlayView = OverlayView(frame: CGRectMake(draggableView.frame.size.width/2-100, 0, 100, 100))
        draggableView.overlayView.alpha = 0
    
        draggableView.xFromCenter = 0
        draggableView.yFromCenter = 0
        
        //-----o Add to subView
        let myTitleCard = cardsData[index].title
        draggableView.title.text = myTitleCard!!.uppercaseString
        
        draggableView.delegate = self
        
        
        draggableView.addSubview(draggableView.title)
        draggableView.addSubview(draggableView.overlayView)
        
        return draggableView
    }
    
    func load_image(urlString:String, completion: (isFinished: Bool) -> Void) -> Void{
        
        let url = NSURL(string: urlString)
        dataURLImg = NSData(contentsOfURL: url!)!
        
         completion(isFinished: true)
        
    }

    func loadCards() -> Void {
        
    
        if cardsData.count > 0 {
            let numLoadedCardsCap = cardsData.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : cardsData.count
            for var i = 0; i < cardsData.count; i++ {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }

            for var i = 0; i < loadedCards.count; i++ {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        currentIndex = currentIndex + 1
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        pushToKeepStep()
        currentIndex = currentIndex + 1
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func pushToKeepStep(){
        
        keepStep.addObject(cardsData[currentIndex])
        print(keepStep)
        
    }
    
    
    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}