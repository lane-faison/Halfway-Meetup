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
    @IBOutlet weak var orSpacer: UIImageView!
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
    
    var rSwitch: Bool!
    var cSwitch: Bool!
    var bSwitch: Bool!
    
    var getUserLoc = false
    var getOtherLoc = false
    
    var yourLocationStored: Bool!
    var otherLocationStored: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocationBtn.layer.cornerRadius = 15
        yourLocationBtn.layer.cornerRadius = 15
        otherLocationBtn.layer.cornerRadius = 15
        searchBtn.layer.cornerRadius = 50
        
        currentLocationCheck.isHidden = true
        orSpacer.isHidden = true
        yourLocationCheck.isHidden = true
        otherLocationCheck.isHidden = true
        
        yourLocationStored = false
        otherLocationStored = false
        
        rSwitch = true
        cSwitch = false
        bSwitch = false
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
        searchBtn.isEnabled = false
        searchBtn.alpha = 0.5
    }
    // SWITCHES
    
    @IBAction func restaurantSwitch(_ sender: UISwitch) {
        if sender.isOn {
            rSwitch = true
        } else {
            rSwitch = false
        }
    }
    @IBAction func cafeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            cSwitch = true
        } else {
            cSwitch = false
        }
    }
    
    @IBAction func barSwitch(_ sender: UISwitch) {
        if sender.isOn {
            bSwitch = true
        } else {
            bSwitch = false
        }
    }
    // SWITCHES (END)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentPosition = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func checkStatus() {
        if yourLocationStored && otherLocationStored {
            searchBtn.alpha = 1
            searchBtn.isEnabled = true
        }
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        currentLocationCheck.isHidden = false
        orSpacer.isHidden = false
        yourLocationCheck.isHidden = true
        userPosition = currentPosition
        yourLocationStored = true
        checkStatus()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        positions = Positions(thisUsersLocation: userPosition, otherUsersLocation: otherPostion)
        let destinationVC = segue.destination as? ResultsVC
        destinationVC?.positions = positions
        destinationVC?.rSwitch = rSwitch
        destinationVC?.cSwitch = cSwitch
        destinationVC?.bSwitch = bSwitch

    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ResultsVC", sender: positions)
    }
}

extension MainVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        let coordinates = place.coordinate
        
        if getUserLoc == true {
            userPosition = coordinates
            yourLocationCheck.isHidden = false
            orSpacer.isHidden = false
            currentLocationCheck.isHidden = true
            yourLocationStored = true
            checkStatus()
            dismiss(animated: true, completion: nil)
        }
        if getOtherLoc == true {
            otherPostion = coordinates
            otherLocationCheck.isHidden = false
            otherLocationStored = true
            checkStatus()
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
