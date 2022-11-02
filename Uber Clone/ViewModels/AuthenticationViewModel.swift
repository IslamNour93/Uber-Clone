//
//  AuthenticationViewModel.swift
//  Uber
//
//  Created by Islam NourEldin on 11/09/2022.
//

import Firebase
import CoreLocation


class AuthenticationViewModel{
    
    var credential:Credentials?
    
    func signup(withCredential credential:Credentials,userType:UserType,driverLocation:CLLocation,completion:@escaping(Error?)->()){
        AuthenticationService.createNewUser(withCredential: credential,userType: userType,driverLocation: driverLocation) { data , error in
            if let error = error {
                print("DEBUG: Error Can't sign up user\(error.localizedDescription)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    func signUserIn(withEmail email:String,password:String,completion:@escaping(AuthDataResult?,Error?)->()){
        AuthenticationService.signUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(nil,error)
            }
            if let result = result {
                completion(result,nil)
            }
            
        }
    }
    
    func checkIfUserIsLogged(completion:@escaping()->()){
        AuthenticationService.checkIfUserIsLogged {
            DispatchQueue.main.async {
                    completion()
            }
        }
    }
    
    func signOut(completion:@escaping()->()){
        AuthenticationService.signOut {
            completion()
        }
    }
}
