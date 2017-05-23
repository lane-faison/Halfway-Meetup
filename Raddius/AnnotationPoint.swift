//
//  AnnotationPoint.swift
//  Raddius
//
//  Created by Lane Faison on 5/22/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import Foundation
import MapKit

class AnnotationPoint: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
