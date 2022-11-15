//
//  HomeViewModel.swift
//  Uber
//
//  Created by Islam NourEldin on 04/10/2022.
//

import Foundation
import CoreLocation

class HomeViewModel:NSObject{
    
    var user:User?
    
    var email:String{
        return user!.email
    }
    
    var fullname:String{
        return user!.fullname
    }
    
    var type:Int{
        return user!.type.rawValue
    }
    
    
    func fetchUser(completion:@escaping(User?)->()){
        UserService.shared.fetchUser { user in
            guard let user = user else {
                return
            }
            completion(user)
        }
    }
    
    func fetchDrivers(location:CLLocation,completion:@escaping(User?)->()){
        UserService.shared.fetchDrivers(location: location) { user in
            if let user = user {
                completion(user)
            }
        }
    }
}
