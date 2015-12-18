//
//  CheckPointTableView.swift
//  Wandr
//
//  Created by Maxime Berthelot on 17/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class CheckPointCellTableView: UITableViewCell {
    
    
    var imgUser = UIImageView()
    var labUerName = UILabel()
    var labMessage = UILabel()
    var labTime = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.backgroundColor = UIColor.blueColor()
        
        //---o Add title Cell
        labMessage = UILabel(frame: CGRectMake(15, 0, self.frame.size.width, 55))
        labMessage.textColor = UIColor.blackColor()
        labMessage.font = UIFont(name: "Avenir-Medium", size: 16)
        
        self.layer.borderWidth = 1
        
        if((labMessage.text?.isEmpty) != nil){
            self.layer.borderWidth = 0
        }
        
        self.layer.borderColor = greyColor.CGColor
        
        self.addSubview(imgUser)
        self.addSubview(labUerName)
        self.addSubview(labMessage)
        self.addSubview(labTime)
        
    }
    


}
