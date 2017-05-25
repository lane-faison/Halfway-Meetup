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
    var rSwitch: Bool!
    var cSwitch: Bool!
    var bSwitch: Bool!
    
    var BARURL: String!
    var CAFEURL: String!
    var RESTAURANTURL: String!
    var mapView: GMSMapView!
    var circle: GMSCircle!
    var circleRadius: CLLocationDegrees!
    var midpoint: CLLocationCoordinate2D!
    
    var cafeArray = [Cafe]()
    var barArray = [Bar]()
    var restaurantArray = [Restaurant]()
    
    var newCircleRadius: CLLocationDegrees!
    var markerArray = [GMSMarker]()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var redSquare: UIView!
    @IBOutlet weak var greenSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSquare.layer.cornerRadius = 10
        greenSquare.layer.cornerRadius = 10
        blueSquare.layer.cornerRadius = 10

        
        let midLatitude = (positions.thisUsersLocation.latitude+positions.otherUsersLocation.latitude)/2
        let midLongitude = (positions.thisUsersLocation.longitude+positions.otherUsersLocation.longitude)/2
        midpoint = CLLocationCoordinate2D(latitude: midLatitude, longitude: midLongitude)
        
        let locationUser = CLLocation(latitude: positions.thisUsersLocation.latitude, longitude: positions.thisUsersLocation.longitude)
        let locationOther = CLLocation(latitude: positions.otherUsersLocation.latitude, longitude: positions.otherUsersLocation.longitude)
        let distance: CLLocationDistance = locationUser.distance(from: locationOther)
        //        let distanceSpan: CLLocationDegrees = 2000 + distance
        
        circleRadius = distance/5
        newCircleRadius = circleRadius
        let getCallRadius: CLLocationDegrees = distance/2
        
        RESTAURANTURL = "\(BASE_URL)\(midLatitude),\(midLongitude)&radius=\(getCallRadius)\(RESTAURANT_URL)\(GP_API)"
        CAFEURL = "\(BASE_URL)\(midLatitude),\(midLongitude)&radius=\(getCallRadius)\(CAFE_URL)\(GP_API)"
        BARURL = "\(BASE_URL)\(midLatitude),\(midLongitude)&radius=\(getCallRadius)\(BAR_URL)\(GP_API)"
        
        print("DISTANCE: \(distance)")
        let camera = GMSCameraPosition.camera(withLatitude: midLatitude, longitude: midLongitude, zoom:11)
        mapView = GMSMapView.map(withFrame: CGRect(x:0,y:65,width:400,height:450), camera: camera)
        //        mapView.center = self.view.center
        self.view.addSubview(mapView)
        //        view = mapView
        
        // Creates a marker for user's location on the map.
        let userMarker = GMSMarker()
        userMarker.position = positions.thisUsersLocation
        userMarker.title = "Your Location"
        userMarker.icon = GMSMarker.markerImage(with: .black)
        userMarker.map = mapView
        // Creates a marker for other person's location on the map.
        let otherMarker = GMSMarker()
        otherMarker.position = positions.otherUsersLocation
        otherMarker.title = "Their Location"
        otherMarker.icon = GMSMarker.markerImage(with: .black)
        otherMarker.map = mapView
        
        //TODO: Make radius larger for smaller distances
        circle = GMSCircle(position: midpoint, radius:circleRadius)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 2
        circle.map = mapView
        
        downloadDetails {
            if self.rSwitch {
                self.buildRestaurantMarkers()
            }
            if self.cSwitch {
                self.buildCafeMarkers()
            }
            if self.bSwitch {
                self.buildBarMarkers()
            }
        }
        
    }
    
    func downloadDetails(completed: @escaping DownloadComplete) {
        
        // RESTAURANT REQUEST
        if rSwitch {
            Alamofire.request(RESTAURANTURL).responseJSON { (response) in
                if let dict = response.result.value as? Dictionary<String,Any> {
                    if let example = dict["results"] as? [Dictionary<String,Any>] {
                        print("######### \(example.count) #########")
                        for index in 0..<example.count {
                            var restaurantName: String!
                            var restaurantLatitude: Double!
                            var restaurantLongitude: Double!
                            var restaurantRating: Int!
                            let place = example[index]
                            let geometry = place["geometry"] as? Dictionary<String,Any>
                            if let position = geometry?["location"] as? Dictionary<String,Double> {
                                print("%%%%%%%%%%%%%%%")
                                print(position["lat"]!)
                                restaurantLatitude = position["lat"]
                                print(position["lng"]!)
                                restaurantLongitude = position["lng"]
                            }
                            if let name = place["name"] as? String {
                                restaurantName = name
                                print(restaurantName)
                            }
                            if let rating = place["rating"] as? Int {
                                restaurantRating = rating
                                print(restaurantRating)
                                print("%%%%%%%%%%%%%%%")
                            } else {
                                restaurantRating = 0
                            }
                            let newRestaurant = Restaurant(latitude: restaurantLatitude, longitude: restaurantLongitude, name: restaurantName, rating: restaurantRating)
                            self.restaurantArray.append(newRestaurant)
                        }
                    }
                }
                completed()
            }
        }
        
        // CAFE REQUEST
        if cSwitch {
            Alamofire.request(CAFEURL).responseJSON { (response) in
                if let dict = response.result.value as? Dictionary<String,Any> {
                    if let example = dict["results"] as? [Dictionary<String,Any>] {
                        print("######### \(example.count) #########")
                        for index in 0..<example.count {
                            var cafeName: String!
                            var cafeLatitude: Double!
                            var cafeLongitude: Double!
                            var cafeRating: Int!
                            let place = example[index]
                            let geometry = place["geometry"] as? Dictionary<String,Any>
                            if let position = geometry?["location"] as? Dictionary<String,Double> {
                                print("%%%%%%%%%%%%%%%")
                                print(position["lat"]!)
                                cafeLatitude = position["lat"]
                                print(position["lng"]!)
                                cafeLongitude = position["lng"]
                            }
                            if let name = place["name"] as? String {
                                cafeName = name
                                print(cafeName)
                            }
                            if let rating = place["rating"] as? Int {
                                cafeRating = rating
                                print(cafeRating)
                                print("%%%%%%%%%%%%%%%")
                            } else {
                                cafeRating = 0
                            }
                            let newCafe = Cafe(latitude: cafeLatitude, longitude: cafeLongitude, name: cafeName, rating: cafeRating)
                            self.cafeArray.append(newCafe)
                        }
                    }
                }
                completed()
            }
        }
        
        // BAR REQUEST
        if bSwitch {
            Alamofire.request(BARURL).responseJSON { (response) in
                if let dict = response.result.value as? Dictionary<String,Any> {
                    if let example = dict["results"] as? [Dictionary<String,Any>] {
                        print("######### \(example.count) #########")
                        for index in 0..<example.count {
                            var barName: String!
                            var barLatitude: Double!
                            var barLongitude: Double!
                            var barRating: Int!
                            let place = example[index]
                            let geometry = place["geometry"] as? Dictionary<String,Any>
                            if let position = geometry?["location"] as? Dictionary<String,Double> {
                                print("%%%%%%%%%%%%%%%")
                                print(position["lat"]!)
                                barLatitude = position["lat"]
                                print(position["lng"]!)
                                barLongitude = position["lng"]
                            }
                            if let name = place["name"] as? String {
                                barName = name
                                print(barName)
                            }
                            if let rating = place["rating"] as? Int {
                                barRating = rating
                                print(barRating)
                                print("%%%%%%%%%%%%%%%")
                            } else {
                                barRating = 0
                            }
                            let newBar = Bar(latitude: barLatitude, longitude: barLongitude, name: barName, rating: barRating)
                            self.barArray.append(newBar)
                        }
                    }
                }
                completed()
            }
        }
    }
    
    // RESTAURANT MARKER FUNCTION
    func buildRestaurantMarkers() {
        markerArray.removeAll()
        for restaurant in restaurantArray {
            let restaurantMarker = GMSMarker()
            restaurantMarker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            restaurantMarker.title = restaurant.name
            restaurantMarker.snippet = "Rating: \(restaurant.rating)/5"
            markerArray.append(restaurantMarker)
        }
        for marker in markerArray {
            let markerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
            let centerOfCircle = CLLocation(latitude: midpoint.latitude, longitude: midpoint.longitude)
            let distanceToCenter: CLLocationDistance = markerLocation.distance(from: centerOfCircle)
            if distanceToCenter < newCircleRadius {
                marker.map = mapView
                marker.icon = GMSMarker.markerImage(with: .red)
            }
        }
    }
    
    // CAFE MARKER FUNCTION
    func buildCafeMarkers() {
        markerArray.removeAll()
        for cafe in cafeArray {
            let cafeMarker = GMSMarker()
            cafeMarker.position = CLLocationCoordinate2D(latitude: cafe.latitude, longitude: cafe.longitude)
            cafeMarker.title = cafe.name
            cafeMarker.snippet = "Rating: \(cafe.rating)/5"
            markerArray.append(cafeMarker)
        }
        for marker in markerArray {
            let markerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
            let centerOfCircle = CLLocation(latitude: midpoint.latitude, longitude: midpoint.longitude)
            let distanceToCenter: CLLocationDistance = markerLocation.distance(from: centerOfCircle)
            if distanceToCenter < newCircleRadius {
                marker.map = mapView
                marker.icon = GMSMarker.markerImage(with: .green)
            }
        }
    }
    
    // BAR MARKER FUNCTION
    func buildBarMarkers() {
        markerArray.removeAll()
        for bar in barArray {
            let barMarker = GMSMarker()
            barMarker.position = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
            barMarker.title = bar.name
            barMarker.snippet = "Rating: \(bar.rating)/5"
            markerArray.append(barMarker)
        }
        for marker in markerArray {
            let markerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
            let centerOfCircle = CLLocation(latitude: midpoint.latitude, longitude: midpoint.longitude)
            let distanceToCenter: CLLocationDistance = markerLocation.distance(from: centerOfCircle)
            if distanceToCenter < newCircleRadius {
                marker.map = mapView
                marker.icon = GMSMarker.markerImage(with: .blue)
            }
        }
    }
    
    @IBAction func changeCircleRadius(_ sender: UISlider) {
        circle.map = nil
        newCircleRadius = circleRadius*(Double(sender.value))
        circle = GMSCircle(position: midpoint, radius: newCircleRadius)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 2
        circle.map = mapView
        self.buildCafeMarkers()
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
