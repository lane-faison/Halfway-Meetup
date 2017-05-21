//
//  MainVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var userLocationTF: UITextField!
    @IBOutlet weak var otherLocationTF: UITextField!
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
    
    @IBAction func searchPressed(_ sender: UIButton) {
        positions.removeAll()
        positions.append(userPosition)
        print("positions: \(positions)")
    }
    
}

