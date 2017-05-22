//
//  ResultsVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import MapKit

class ResultsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var positions: Positions!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("######")
        print(positions.thisUsersLocation)
        print(positions.otherUsersLocation)
        print("######")
        
        let distanceSpan: CLLocationDegrees = 10000
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(positions.thisUsersLocation, distanceSpan, distanceSpan), animated: true)

    }

}
