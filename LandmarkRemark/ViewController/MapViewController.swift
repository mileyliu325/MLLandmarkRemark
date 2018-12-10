//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 7/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import KumulosSDK

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var newAnnotation : MKPointAnnotation!
    var newAnnotationView : MKPinAnnotationView!
    var standard = UserDefaults.standard
    
    var serachedLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        self.currentLocationButton.layer.cornerRadius = 3
        
        //init longpress gesture
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        
        self.mapView.addGestureRecognizer(longTap)
        
        if let name = standard.string(forKey: "username"), let _ = standard.string(forKey: "password"){
            
            title = "Hello,\(name)"
            logoutButton.isEnabled = true
            
            listLocations()
            
        }else{
            self.title = "Hello"
            logoutButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let name = standard.string(forKey: "username"),checkIfLogin(){
            
            title = "Hello,\(name)"
            logoutButton.isEnabled = true
            listLocations()
            
        }else{
            self.title = "Hello"
            logoutButton.isEnabled = false
        }
    }
    
    // MARK: - IBActions
    
    //requirment #2 save a short note at my current location
    @IBAction func AddMyCurrentLocation(_ sender: Any) {
        
        //check if login as a user
        if checkIfLogin() {
            showCreateNoteAlert(coordinate: userLocation.coordinate)
            
        }else {
               gotoLoginPage()
        }
    }
    
    func gotoLoginPage() {
        
        var controller: UserViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func searchTaped(_ sender: Any) {
        
        if checkIfLogin(){
           
            var controller: SearchViewController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            //usage for show search location
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
        else {
            gotoLoginPage()
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "LOGOUT", message: "Do you want to logout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Cancel",style:.cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            userdefaultLogout()
            
            self.logoutButton.isEnabled = false
            self.title = "Hello"
            
            //remove all annotations
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    //requriment #2.1 extension provide a long press adding notes
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        if checkIfLogin(){
            
            showCreateNoteAlert(coordinate: coordinate)
            
        }else {
            
            var controller: UserViewController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    func setupMap(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
        
    }
    // MARK: - SAVE NOTE
    func showCreateNoteAlert(coordinate: CLLocationCoordinate2D) {
        
        let alert = UIAlertController(title: "Note", message: "Create your own notes", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            // : todo change height
            textField.placeholder = "Enter your note here"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let title = self.standard.string(forKey: "username")!
            let note = alert?.textFields![0].text
            
            if let note = note {
                self.addNewAnnotation(title: title, note: note, location: coordinate)
                self.createNote(name: title, note: note, location: coordinate)
            }
        }))
        alert.addAction(UIAlertAction(title:"Cancel",style:.cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createNote(name:String,note:String,location:CLLocationCoordinate2D){
        
        let param = ["latitude":location.latitude,"longitude":location.longitude
            ,"user_name":name,"note":note] as [String : AnyObject]
        
        RequestManager.init(APIName: CREAT_NOTE_API, parameter: param).requestOne { (response, error) in
            guard error == nil else {
                let alert =  getErrorAlert(error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alert = getSimpleAlert(title: "Sucess", message: "Create Note sucessfully ")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
     // MARK: - SHOW  NOTE
    //requiremnt #3 & #4  show my & others notes
    func listLocations(){
        
        RequestManager.init(APIName: LIST_ALL_API, parameter: [:]).requestMany { (array, error) in
            
            guard error == nil else{
                
                let alert =  getErrorAlert(error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard array != nil else {
                 let alert =  getSimpleAlert(title: "Error", message: "Can't fetch notes, please check your internet")
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            
            for location in array! {
                
                let locationData = Location.init(with: location as! [String : Any])
                let coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(locationData.latitude), longitude: CLLocationDegrees(locationData.longitude))
                
                // add annotation into map
                self.addNewAnnotation(title: locationData.user_name, note: locationData.note, location: coordinate)
            }
        }
    }
    
    func addNewAnnotation(title:String,note:String,location:CLLocationCoordinate2D){
        
        newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = location
        newAnnotation.title = title
        newAnnotation.subtitle = note
        
        newAnnotationView = MKPinAnnotationView(annotation: newAnnotation, reuseIdentifier: "pin")
        newAnnotationView.tintColor = UIColor.yellow
        mapView.addAnnotation(newAnnotationView.annotation!)
    }
    
}

extension MapViewController:CLLocationManagerDelegate,SearchControllerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //requirement #1 : get my current Location
        let location = locations.last! as CLLocation
        self.userLocation = location
        self.mapView.showsUserLocation = true
        let centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 500, 500)
        let adjustRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
    }
    
    //function from searchviewcontroller ,find the location requested
    func findLocation(coordinate:CLLocationCoordinate2D){
        //set camera
        let centerCoordinate = coordinate
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 500, 500)
        let adjustRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
    }
}
