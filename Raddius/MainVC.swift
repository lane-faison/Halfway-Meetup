//
//  MainVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces


class MainVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var userLocationTF: UITextField!
    @IBOutlet weak var restaurantSwitch: UISwitch!
    @IBOutlet weak var coffeeSwitch: UISwitch!
    @IBOutlet weak var barSwitch: UISwitch!
    @IBOutlet weak var searchBtn: UIButton!
    
    var manager = CLLocationManager()
    var userPosition = CLLocationCoordinate2D()
    var otherPostion = CLLocationCoordinate2D()
    var positions = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userPosition = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    

    @IBAction func getOtherLocationBtnPressed(_ sender: Any) {
        print("hello")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        positions.removeAll()
        positions.append(userPosition)
        print("positions: \(positions)")
    }
    

}

extension MainVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
