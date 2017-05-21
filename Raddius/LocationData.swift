//
//  LocationData.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import Foundation
import CoreLocation

class LocationData {
    private var _userLocation: CLLocationCoordinate2D!
    private var _otherLocation: CLLocationCoordinate2D!

    init(userLocation: CLLocationCoordinate2D, otherLocation: CLLocationCoordinate2D) {
        self._userLocation = userLocation
        self._otherLocation = otherLocation
    }
}
