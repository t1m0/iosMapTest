//
//  FirstViewController.swift
//  MapsTest
//
//  Created by Timo Schoepflin on 08.09.17.
//  Copyright © 2017 Timo Schoepflin. All rights reserved.
//

import UIKit
import MapKit
class MapKitViewController: BaseMapViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    let geocoder = CLGeocoder()
    let locationManager =  CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        // get users current location to place initial view
        locationManager.requestLocation()
    }
    
    override func updateMapBasedOnSearch(searchText:String){
        // perform lookup based on user entry
        geocoder.geocodeAddressString(searchText, completionHandler: reactOnFoundAddress)
    }

    // handle successfull user location lookup
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            centerMap(coordinate: location.coordinate);
        }
    }
    
    // handle failed user location lookup
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: Failed to find user's location: \(error.localizedDescription)")
    }
    
    // Callback for forward geocoding
    func reactOnFoundAddress(placeMarks:[CLPlacemark]?, error:Error?) -> Void{
        let placeMark = MKPlacemark(placemark:placeMarks!.first!)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(placeMark)
        centerMap(coordinate: placeMark.coordinate);
        mapView.selectAnnotation(placeMark, animated: true)
    }
    
    // center the map on a given coordinate
    func centerMap(coordinate:CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.5,longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

