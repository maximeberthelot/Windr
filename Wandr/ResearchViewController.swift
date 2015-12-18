//
//  ResearchViewController.swift
//  Wandr
//
//  Created by Maxime Berthelot on 15/12/15.
//  Copyright © 2015 Maxime Berthelot. All rights reserved.

import Foundation
import MapKit
import CoreLocation
import Locksmith

class ResearchViewController : UIViewController,UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var timeTextField: UITextField!
    
    var isKeyboardIsOpen = false
    var timeMinute = 45
    var isBike = true
    var isSpeed = false
    var isFinished = true
    var ll = ""
    
    @IBOutlet var mapViewUI: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet var btnBike: UIButton!
    @IBOutlet var btnFoot: UIButton!
    @IBOutlet var btnDiscover: UIButton!
    @IBOutlet var btnSpeed: UIButton!
    
    //-----o Events
    @IBAction func footIsPress(sender: UIButton) {
        self.switchBtnColorFoot()
    }
    
    @IBAction func bikeIsPress(sender: UIButton) {
        self.switchBtnColorFoot()
    }
    
    @IBAction func speedIsPress(sender: UIButton) {
         self.switchBtnColorSpeed()
    }
    
    @IBAction func discoverIsPress(sender: UIButton) {
        self.switchBtnColorSpeed()
    }
    
    @IBAction func btnGoIsPress(sender: AnyObject) {
        self.getItinary()
    }
    
    override func viewDidLoad() {
        
        //----o empty array
        keepStep = []
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //------o Init Map & set to current locale
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapViewUI.showsUserLocation = true
        
        
        //----o Set default textField & UIPickerView
        self.timeTextField.delegate = self
        timeTextField.text = pickerDataSource[2]
        
        self.setStylePickerView()
        
        //----o Keyboard ? Openning or Hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //---o Hide Keyboard on swipe down
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismessKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        
        
        //----o Init with default el
        self.switchBtnColorFoot()
        self.switchBtnColorSpeed()
        
        //----o purge itinary
        if((Locksmith.loadDataForUserAccount("itinary")) != nil && (Locksmith.loadDataForUserAccount("choose")) != nil){
            
            try! Locksmith.deleteDataForUserAccount("itinary")
            try! Locksmith.deleteDataForUserAccount("choose")
            
        }
        
    }
    
    
    //-----o switch Button
    func switchBtnColorFoot(){
        
        if(isBike){
            
            isBike = false
            
            btnFoot.backgroundColor = greenColor
            btnFoot.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            btnBike.backgroundColor = UIColor.whiteColor()
            btnBike.setTitleColor(greenColor, forState: UIControlState.Normal)
            
            
        }
        else{
            isBike = true
            
            btnFoot.backgroundColor = UIColor.whiteColor()
            btnFoot.setTitleColor(greenColor, forState: UIControlState.Normal)
            
            btnBike.backgroundColor = greenColor
            btnBike.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        }
    
    }
    
    //-----o switch Button
    func switchBtnColorSpeed(){
        
        if(isSpeed){
            
            isSpeed = false
            
            btnDiscover.backgroundColor = greenColor
            btnDiscover.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            btnSpeed.backgroundColor = UIColor.whiteColor()
            btnSpeed.setTitleColor(greenColor, forState: UIControlState.Normal)
            
            
        }
        else{
            isSpeed = true
            
            btnDiscover.backgroundColor = UIColor.whiteColor()
            btnDiscover.setTitleColor(greenColor, forState: UIControlState.Normal)
            
            btnSpeed.backgroundColor = greenColor
            btnSpeed.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        }
        
    }
    
    
    //-----o set pickerView
    func setStylePickerView(){
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = greenColor
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Terminer", style: UIBarButtonItemStyle.Bordered, target: self, action: "dismessKeyboard")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        
        timeTextField.inputAccessoryView = toolBar
        timeTextField.inputView = pickerView

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timeMinute = timeConvert[row]
        timeTextField.text = pickerDataSource[row]
    
    }
    
    //-----o Update mark
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapViewUI.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        ll = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Erros:" + error.localizedDescription)
        
    }
    
    
    //-----o set Keyboard & screen
    func keyboardWillShow(sender: NSNotification) {
        
        if(!isKeyboardIsOpen){
            self.view.frame.origin.y -= 180
            isKeyboardIsOpen = true
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if(isKeyboardIsOpen){
            self.view.frame.origin.y += 180
            isKeyboardIsOpen = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //----o set TextField
    func dismessKeyboard(){
        
        timeTextField.resignFirstResponder()
        
    }
    
    //-------o go to tinder
    func goToTinderView(){
        
        presentViewController( UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TinderVIew") as UIViewController, animated: true, completion: nil)
    }
    
    //-----o get Itinary
    func getItinary(){
        
        if let dataUser = Locksmith.loadDataForUserAccount("currentUser") {
            
            if let token = dataUser["token"] as? String {
                
                let mode = isBike ? "bike" : "foot"
                let type = isSpeed ? "sport" : "classic"
        
                ItinaryModel.getCheckpoints(timeMinute, ll: ll, mode:mode, type:type, token: token){
            
                    (isFinished) -> Void in
            
                    if(isFinished){
                        self.goToTinderView()
                    }
            
                }
            }
        }
            
    }
        
}
    