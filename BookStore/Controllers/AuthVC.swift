//
//  AuthVC.swift
//  BookStore
//
//  Created by fatma on 25/09/1442 AH.
//

import UIKit
import Firebase
import FirebaseAuth


class AuthVC : UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        try? Auth.auth().signOut()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                //User found
                self.performSegue(withIdentifier: "toApp", sender: self )
            } else {
                //There is no user here
                self.performSegue(withIdentifier: "toAuth", sender: self)
            }
        }
    }
}
