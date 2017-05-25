//
//  Constants.swift
//  Raddius
//
//  Created by Lane Faison on 5/23/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import Foundation


let BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
let CAFE_URL = "&type=cafe&keyword=shop&key="
let RESTAURANT_URL = "&type=restaurant&keyword=food&key="
let BAR_URL = "&type=bar&keyword=beer&key="
let GP_API = "AIzaSyBpOxB0ZAVN8d6DcMwPDPl9Rfxogrte9d4"

typealias DownloadComplete = () -> () // Creating a closure, which will be passed to the downloadPokemonDetails function.
