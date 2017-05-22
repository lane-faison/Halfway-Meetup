//
//  Positions.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import Foundation
import CoreLocation

class Positions {
    private var _thisUsersLocation: CLLocationCoordinate2D
    private var _otherUsersLocation: CLLocationCoordinate2D
    
    var thisUsersLocation: CLLocationCoordinate2D {
        return _thisUsersLocation
    }
    
    var otherUsersLocation: CLLocationCoordinate2D {
        return _otherUsersLocation
    }
    
    init(thisUsersLocation: CLLocationCoordinate2D, otherUsersLocation: CLLocationCoordinate2D) {
        _thisUsersLocation = thisUsersLocation
        _otherUsersLocation = otherUsersLocation
    }
}
