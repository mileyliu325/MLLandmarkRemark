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

class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    var newAnnotation : MKPointAnnotation!
    var newAnnotationView : MKPinAnnotationView!
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        
        self.mapView.addGestureRecognizer(longTap)
    }
    
    
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        
         let point = sender.location(in: mapView)
         let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
         showAlert(coordinate: coordinate)
    
    }
    func setupMap(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
       
    }

    func showAlert(coordinate: CLLocationCoordinate2D) {
    
        let alert = UIAlertController(title: "Note", message: "Create your own notes", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            // : todo change height
            textField.placeholder = "Enter your note here"
           
        }
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let title = "Mileyliu"
            let note = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            //todo vailidate
            
            self.addNewAnnotation(title: title, note: note?.text ?? "", location: coordinate)
            //todo fetch server
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel",style:.cancel))
        self.present(alert, animated: true, completion: nil)
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

extension MapViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.userLocation = location
        
        self.mapView.showsUserLocation = true
//        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 500, 500)
        let adjustRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
}
