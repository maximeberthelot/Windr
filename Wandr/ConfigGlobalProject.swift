//
//  ConfigGlobalProject.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//


var APIURL = "http://wandr.tristanfarneau.com/api/"
var modeDEV = true
var pickerDataSource = ["15 min", "30 min", "45 min", "1h", "1h15", "1h30", "1h45", "2h", "2h15", "2h30", "2h45", "3h", "3h15", "3h30"]
var timeConvert = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210]
var greenColor = UIColor(red: 94/255, green: 205/255, blue: 184/255, alpha: 1)
var limitR = 10
var radiusMap = []
var checkpointsData = []
var cardCounter = 0
var keepStep = NSMutableArray()
var currentIndex = 0

    