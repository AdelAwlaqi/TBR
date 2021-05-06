//
//  UserObject.swift
//  BookStore
//
//  Created by fatma on 24/09/1442 AH.
//


import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    
    init(id: String, email: String, username: String, stripeId: String) {
        self.id = id
        self.email = email
        self.username = username
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String: Any]{
        let data : [String: Any] = [
            "id": user.id,
            "email": user.email,
            "username": user.username
        ]
        
        return data
    }
}

