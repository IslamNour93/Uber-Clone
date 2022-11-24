//
//  DriverAnnotation.swift
//  Uber Clone
//
//  Created by Islam on 24/11/2022.
//

import Foundation
import MapKit

class DriverAnnotation:NSObject, MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String?
    static let identifier = "DriverAnnotation"
    
    init(uid:String,coordinate:CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updateDriverAnnotation(coordinate:CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
