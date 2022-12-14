//
//  Constants.swift
//  Uber
//
//  Created by Islam NourEldin on 04/10/2022.
//

import Firebase

class Constants{
    
    private static let docRef = Database.database().reference()
    
    static let usersRef = docRef.child("users")
    static let driversLocationRef = docRef.child("drivers-Locations")
    static let tripsRef = docRef.child("trips")
}
