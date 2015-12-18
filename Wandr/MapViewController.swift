//
//  MapViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Locksmith

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    @IBOutlet var mapViewUI: MKMapView!
    
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var stepsLabel: UILabel!
    @IBOutlet var kmLabel: UILabel!
    let locationManager = CLLocationManager()
    var haveItinary = false
    var backLabel: UIButton!
    var arrayCheckpoints = []
    var metasObject = NSObject()
    var goBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        mapViewUI.delegate = self
        
        // Connect all the mappoints using Poly line.
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        
        mapViewUI.addOverlay(polyline)
        self.mapViewUI.showsUserLocation = true
        
        
        //---o Data On View
        initView()
        addAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initView(){
        
        if let dictionaryItinary = Locksmith.loadDataForUserAccount("itinary") {
            haveItinary = true
            let itinaryObject = dictionaryItinary["itinary"]!
            
            if  ((itinaryObject["checkpoints"] as? NSArray) != nil) {
                arrayCheckpoints = itinaryObject["checkpoints"] as! NSArray
                
                print(arrayCheckpoints)
                
            }
            
            if  ((itinaryObject["checkpoints"] as? NSArray) != nil) {
                
                arrayCheckpoints = itinaryObject["checkpoints"] as! NSArray
                stepsLabel.text = "\(arrayCheckpoints.count)"
                
            }
            
            if let metasObject = itinaryObject["metas"] as? NSObject {
                
                hourLabel.text = metasObject.valueForKey("time_string") as? String
                
            }
            
            if let metasObject = itinaryObject["metas"] as? NSObject {
                
                let text = metasObject.valueForKey("total_distance_string")!
                kmLabel.text = "\(text)"
                
            }
            
            initTableView()
            addSubView()
        }
    
    }
    
    
    //------o SubView
    func addSubView(){
    
        //---o Add Back btn
        backLabel = UIButton(frame: CGRectMake(0, 20, 100, 35))
        backLabel.setTitle("Arreter", forState: UIControlState.Normal)
        backLabel.titleLabel!.textColor = UIColor.whiteColor()
        backLabel.titleLabel!.font = UIFont(name: "Avenir-Light", size: 15)
        backLabel.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //---o Add Back btn
        goBtn = UIButton(frame: CGRectMake(self.view.frame.size.width - 76, self.view.frame.size.height - 91, 60, 60))
        goBtn.setTitle("GO !", forState: UIControlState.Normal)
        goBtn.titleLabel!.textColor = UIColor.whiteColor()
        goBtn.titleLabel!.textAlignment = NSTextAlignment.Center
        goBtn.layer.cornerRadius = 30
        goBtn.backgroundColor = greenColor
        goBtn.titleLabel!.font = UIFont(name: "Avenir-Medium", size: 17)
        goBtn.addTarget(self, action: "switchToPath:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(goBtn)
        self.view.addSubview(backLabel)
        
    }
    
    
    
    //------o TableView config
    func initTableView(){
        
        
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView!.delegate = self
        myTableView!.dataSource = self
        myTableView.allowsSelection = false
        myTableView.tableHeaderView = nil
        myTableView.tableFooterView = nil
        myTableView.rowHeight = 55
        
        self.view.addSubview(myTableView)
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        
        return arrayCheckpoints.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CheckPointCellTableView

        let checkPointArray = arrayCheckpoints[indexPath.row]
        let convertToCheckPointObject = checkPointArray as! NSObject
        
        
        cell.labMessage.text = "\(convertToCheckPointObject.valueForKey("name")!.capitalizedString)"
        
        return cell
    }

    
    //------o Back to choose view
    func pressed(sender: UIButton!) {
        
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Default") as UIViewController, animated: true, completion: nil)
        
        
    }
    
    //-----o switch
    func switchToPath(){
        
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Default") as UIViewController, animated: true, completion: nil)

    }
    
    //----o Update mark
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapViewUI.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func addAnnotations(){
        
         if let _ = Locksmith.loadDataForUserAccount("itinary") {
        
            for item in arrayCheckpoints {
                var latToD = 34.3
                var lngToD = 23.2
                var text = "default"
                
                if let textItem = item.valueForKey("name") as? String {
                    text = textItem                }
                
                if let lat = item.valueForKey("lat") as? String {
                    latToD = Double(lat) as Double!
                }
                
                if let lng = item.valueForKey("lng")! as? String {
                    lngToD = Double(lng) as Double!
                
                }
            
                let Pin = CLLocationCoordinate2DMake(latToD, lngToD)
            
                // Drop a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = Pin
                dropPin.title = text
                mapViewUI.addAnnotation(dropPin)
            
            }
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Erros:" + error.localizedDescription)
        
    }

}
