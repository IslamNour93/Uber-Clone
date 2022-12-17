//
//  PassengerService.swift
//  Uber Clone
//
//  Created by Islam on 12/12/2022.
//

import Firebase
import MapKit
class PassengerService{
    
   static let shared = PassengerService()
    
    
    func uploadTrip(pickupLocation:CLLocationCoordinate2D,destination:CLLocationCoordinate2D,completion: @escaping(Error?,DatabaseReference)->()){
        
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        
        let values = ["pickupLocation":[pickupLocation.latitude,pickupLocation.longitude],
                      "destination":[destination.latitude,destination.longitude],
                      "passengerUid":uid] as [String:Any]
        
        Constants.tripsRef.child(uid).updateChildValues(values,withCompletionBlock: completion)
    }
}
