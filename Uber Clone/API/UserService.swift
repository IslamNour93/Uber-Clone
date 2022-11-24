//
//  UserService.swift
//  Uber
//
//  Created by Islam NourEldin on 04/10/2022.
//

import Firebase
import CoreLocation
import GeoFire


class UserService{
    
    static let shared = UserService()
    
    func fetchUser(completion:@escaping(User?)->()){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Constants.usersRef.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String : Any] else {
                return
            }
            let userUid = snapshot.key
            let user = User(uid: userUid, dictionary: data)
            completion(user)
        }
    }
    
    func fetchSpecificUser(uid:String,completion:@escaping(User?)->()){
        Constants.usersRef.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String : Any] else {
                return
            }
            let userUid = snapshot.key
            let user = User(uid: userUid, dictionary: data)
            completion(user)
        }
    }
    
    func fetchDrivers(location:CLLocation,completion:@escaping(User?)->()){
        let geo = GeoFire(firebaseRef: Constants.driversLocationRef)
        
        Constants.driversLocationRef.observe(.value) {snapshot in
            
            geo.query(at: location, withRadius: 100).observe(.keyEntered, with: {[weak self] uid,driverLocation in
                self?.fetchSpecificUser(uid: uid) { user in
                    var driver = user
                    driver?.location = driverLocation
                    completion(driver)
                }
            })
        }
    }
}
