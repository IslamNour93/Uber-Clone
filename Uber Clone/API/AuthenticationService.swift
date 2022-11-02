//
//  AuthenticationService.swift
//  Uber
//
//  Created by Islam NourEldin on 26/09/2022.
//

import Firebase
import GeoFire
import CoreLocation

class AuthenticationService{
    
    static let ref = Database.database().reference()
    
    static func createNewUser(withCredential credential:Credentials,userType:UserType,driverLocation:CLLocation,completion:@escaping(Dictionary<String,Any>?,Error?)->()){
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { authData, error in
            if let error = error{
                completion(nil,error)
                print("DEBUG: error in sign up a new user\(error.localizedDescription)")
            }
            guard let uid = authData?.user.uid else {return}
            
            let values = ["email":credential.email,
                          "fullname":credential.fullname,
                          "userType":credential.userType] as [String : Any]
            
            switch userType {
            case .passenger:
                updateUserData(values: values, uid: uid)
                completion(values,nil)
            case .driver:
                print("Debug: Driver has been created....")
                let geo = GeoFire(firebaseRef: Constants.driversLocation)
                geo.setLocation(driverLocation, forKey: uid) { error in
                    updateUserData(values: values, uid: uid)
                    completion(values,nil)
                }
            }
        }
    }
    
    static func updateUserData(values:[String:Any],uid:String){
        ref.child("users").child(uid).updateChildValues(values) { error, ref in
            print("DEBUG: Success in creating a new child")
        }
    }
    
    static func signUserIn(withEmail email:String, password:String,completion:@escaping(AuthDataResult?,Error?)->()){
        
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error = error{
                print("DEBUG: Error can't sign User in..\(error.localizedDescription)")
                completion(nil,error)
            }
            completion(authData,nil)
        }
    }
    static func checkIfUserIsLogged(completion:@escaping()->()){
        if Auth.auth().currentUser == nil{
            print("DEBUG: No User is logged in")
            completion()
        }
    }
    
    static func signOut(completion:@escaping()->()){
        do{
            try Auth.auth().signOut()
            completion()
        }catch{
            print("DEBUG: Error can't sign user out")
        }
    }
}
