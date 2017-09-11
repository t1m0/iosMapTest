//
//  SecondViewController.swift
//  MapsTest
//
//  Created by Timo Schoepflin on 08.09.17.
//  Copyright © 2017 Timo Schoepflin. All rights reserved.
//

import GoogleMaps
import GooglePlaces
class GoogleMapsViewController: BaseMapViewController {
    
    static let googleURL = "https://maps.googleapis.com/maps/api/geocode/json"
    static let googleWebApiKey = "APIKEY" // use your key
    
    @IBOutlet var mapView: GMSMapView!
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        placesClient = GMSPlacesClient.shared()
        // request current user location for starting point
        placesClient.currentPlace(callback: currentPlaceCallback)
    }
    
    override func updateMapBasedOnSearch(searchText:String){
        performForwardGeocoding(string: searchText)
    }

    // Handle successfull user location lookup
    func currentPlaceCallback(placeLikelihoods:GMSPlaceLikelihoodList?,error:Error?){
        if let places = placeLikelihoods {
            let place = places.likelihoods.first?.place
            centerCamera(latitude: (place?.coordinate.latitude)!, longitude: (place?.coordinate.longitude)!)
        }
    }
    
    // as the ios api doesn't support forward geocoding, we have to use the web api
    func performForwardGeocoding(string: String) {
        var components = URLComponents(string: GoogleMapsViewController.googleURL)!
        let key = URLQueryItem(name: "key", value: GoogleMapsViewController.googleWebApiKey)
        let address = URLQueryItem(name: "address", value: string)
        components.queryItems = [key, address]
        
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                    print("ERROR: API call failed")
                    print(String(describing: response))
                    print(String(describing: error))
                return
            }
            
            guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("ERROR: unable to extract json from received data")
                print("\(data)")
                return
            }
            guard let results = json["results"] as? [[String: Any]],
                let status = json["status"] as? String,
                status == "OK" else {
                    print("ERROR: received no results from google")
                    print(String(describing: json))
                    return
            }
            
            guard let geometry = results.first?["geometry"] as? [String: Any]
             else {
                print("ERROR: unable to extract geometry data")
                return
            }
            
            guard let location = geometry["location"] as? [String: Double]
                else {
                    print("ERROR: unable to extract location data")
                    return
            }
            let name = results.first?["formatted_address"]!
            let lng = location["lng"]!
            let lat = location["lat"]!
            
            //clear previous markers
            self.mapView.clear()
            // set new marker
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.title = name as? String
            marker.map = self.mapView
            self.centerCamera(latitude: lat, longitude: lng)
        }
        
        task.resume()
    }

    // Centers the camera on the given location
    func centerCamera(latitude:Double,longitude:Double){
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
        self.mapView.camera = camera
    }
}

