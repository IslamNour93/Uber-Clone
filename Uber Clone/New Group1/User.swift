//
//  User.swift
//  Uber
//
//  Created by Islam NourEldin on 04/10/2022.
//

import Foundation
import CoreLocation

struct User{
    let fullname:String
    let email:String
    let type:UserType
    var location:CLLocation?
    var uid:String
    
    init(uid:String,dictionary:[String:Any]){
        self.uid = uid
        fullname = dictionary["fullname"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        type = UserType(rawValue: dictionary["userType"] as? Int ?? 0) ?? .passenger
    }
}

enum UserType:Int{
    case passenger
    case driver
}
