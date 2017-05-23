//
//  ResultsVC.swift
//  Raddius
//
//  Created by Lane Faison on 5/21/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import MapKit

class ResultsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var positions: Positions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let midLatitude = (positions.thisUsersLocation.latitude+positions.otherUsersLocation.latitude)/2
        let midLongitude = (positions.thisUsersLocation.longitude+positions.otherUsersLocation.longitude)/2
        let midpoint = CLLocationCoordinate2D(latitude: midLatitude, longitude: midLongitude)
        
        let userAnnotation = AnnotationPoint(coordinate: positions.thisUsersLocation)
        let otherAnnotation = AnnotationPoint(coordinate: positions.otherUsersLocation)
        
        let locationUser = CLLocation(latitude: positions.thisUsersLocation.latitude, longitude: positions.thisUsersLocation.longitude)
        let locationOther = CLLocation(latitude: positions.otherUsersLocation.latitude, longitude: positions.otherUsersLocation.longitude)
        let distance: CLLocationDistance = locationUser.distance(from: locationOther)
        
        let distanceSpan: CLLocationDegrees = 2000 + distance
        
        let circle = MKCircle(center: midpoint, radius: distance/6)
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = "food"
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(midpoint, distanceSpan, distanceSpan), animated: true)
        mapView.addAnnotation(userAnnotation)
        mapView.addAnnotation(otherAnnotation)
        mapView.addOverlays([circle])
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(result,error) in
            for placemark in (result?.mapItems)! {
                if(error == nil) {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                    annotation.title = placemark.placemark.name
                    annotation.subtitle = placemark.placemark.title
                    self.mapView.addAnnotation(annotation)
                    
                }
                else
                {
                    print(error ?? 0)
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
