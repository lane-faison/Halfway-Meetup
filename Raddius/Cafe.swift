//
//  Cafe.swift
//  Raddius
//
//  Created by Lane Faison on 5/23/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import Foundation

class Cafe {
    private var _latitude: Double!
    private var _longitude: Double!
    private var _name: String!
    private var _rating: Int!
//    private var _open_now: Bool!
//    private var _id: String!
//    private var _vicinity: String!
//    private var _cafeURL: String!
    
    // DATA PROTECTION against nil values
    
    var latitude: Double {
        return _latitude
    }
    
    var longitude: Double {
        return _longitude
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var rating: Int {
        if _rating == nil {
            _rating = 0
        }
        return _rating
    }
    
//    var open_now: Bool {
//        if _open_now == nil {
//            _open_now = true
//        }
//        return _open_now
//    }
//    
//    var id: String {
//        if _id == nil {
//            _id = ""
//        }
//        return _id
//    }
//    
//    var vicinity: String {
//        if _vicinity == nil {
//            _vicinity = ""
//        }
//        return _vicinity
//    }
    
    // Will need to set a radius functionally here using lat and long.
    
    init(latitude: Double, longitude: Double, name: String, rating: Int) {
        self._latitude = latitude
        self._longitude = longitude
        self._name = name
        self._rating = rating
    }
    
}
