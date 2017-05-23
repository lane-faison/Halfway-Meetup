//
//  ResultsVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ResultsVC: UIViewController {
    
    var positions: Positions!
    var CAFEURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midLatitude = (positions.thisUsersLocation.latitude+positions.otherUsersLocation.latitude)/2
        let midLongitude = (positions.thisUsersLocation.longitude+positions.otherUsersLocation.longitude)/2
        let midpoint = CLLocationCoordinate2D(latitude: midLatitude, longitude: midLongitude)
        

        let locationUser = CLLocation(latitude: positions.thisUsersLocation.latitude, longitude: positions.thisUsersLocation.longitude)
        let locationOther = CLLocation(latitude: positions.otherUsersLocation.latitude, longitude: positions.otherUsersLocation.longitude)
        let distance: CLLocationDistance = locationUser.distance(from: locationOther)
//        let distanceSpan: CLLocationDegrees = 2000 + distance
        let circleRadius = distance/5
        
        
        CAFEURL = "\(BASE_URL)\(midLatitude),\(midLongitude)&radius=\(circleRadius)\(CAFE_URL)\(GP_API)"

        
        print("DISTANCE: \(distance)")
        let camera = GMSCameraPosition.camera(withLatitude: midLatitude, longitude: midLongitude, zoom:13)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker for user's location on the map.
        let userMarker = GMSMarker()
        userMarker.position = positions.thisUsersLocation
        userMarker.title = "Your Location"
        userMarker.icon = GMSMarker.markerImage(with: .green)
        userMarker.map = mapView
        // Creates a marker for other person's location on the map.
        let otherMarker = GMSMarker()
        otherMarker.position = positions.otherUsersLocation
        otherMarker.title = "Their Location"
        otherMarker.icon = GMSMarker.markerImage(with: .red)
        otherMarker.map = mapView
        
        //TODO: Make radius larger for smaller distances
        let circle = GMSCircle(position: midpoint, radius: circleRadius)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 2
        circle.map = mapView
        
        downloadCafeDetails {
            print("$$$$$$$$$$")
        }
        
    }
    
    func downloadCafeDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(CAFEURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String,Any> {
                print("###1")
                if let example = dict["results"] as? [Dictionary<String,Any>] {
                    print("###2")
                    print(example.count)
                    for index in 0..<example.count {
                        print("%%%%%%%%%%%%%%%")
                        print(example[index])
                        print("%%%%%%%%%%%%%%%")
                    }
                }
            
            
            }
            
            completed()
        }
    }

    
}
