//
//  UserService.swift
//  Uber
//
//  Created by Islam NourEldin on 04/10/2022.
//

import Firebase

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
            
            let user = User(dictionary: data)
            completion(user)
        }
    }
}
