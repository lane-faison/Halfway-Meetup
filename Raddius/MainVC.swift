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
    @IBOutlet weak var yourLocationBtn: UIButton!
    @IBOutlet weak var otherLocationBtn: UIButton!
    
    @IBOutlet weak var currentLocationCheck: UIImageView!
    @IBOutlet weak var yourLocationCheck: UIImageView!
    @IBOutlet weak var otherLocationCheck: UIImageView!
    
    @IBOutlet weak var restaurantSwitch: UISwitch!
    @IBOutlet weak var coffeeSwitch: UISwitch!
    @IBOutlet weak var barSwitch: UISwitch!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    var manager = CLLocationManager()
    var currentPosition = CLLocationCoordinate2D()
    var userPosition = CLLocationCoordinate2D()
    var otherPostion = CLLocationCoordinate2D()
    var positions: Positions?
    
    var getUserLoc = false
    var getOtherLoc = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocationCheck.isHidden = true
        yourLocationCheck.isHidden = true
        otherLocationCheck.isHidden = true
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentPosition = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        positions = Positions(thisUsersLocation: userPosition, otherUsersLocation: otherPostion)
        let destinationVC = segue.destination as? ResultsVC
        destinationVC?.positions = positions
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        currentLocationCheck.isHidden = false
        yourLocationCheck.isHidden = true
        userPosition = currentPosition
    }
    
    @IBAction func getUserLocationBtnPressed(_ sender: Any) {
        getUserLoc = true
        getOtherLoc = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func getOtherLocationBtnPressed(_ sender: Any) {
        getOtherLoc = true
        getUserLoc = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ResultsVC", sender: positions)
    }
    
}

extension MainVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        let coordinates = place.coordinate
        
        if getUserLoc == true {
            userPosition = coordinates
            yourLocationCheck.isHidden = false
            currentLocationCheck.isHidden = true
            dismiss(animated: true, completion: nil)
        }
        if getOtherLoc == true {
            otherPostion = coordinates
            otherLocationCheck.isHidden = false
            dismiss(animated: true, completion: nil)
        }

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
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
