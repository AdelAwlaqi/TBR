//
//  Extensions.swift
//  BookStore
//
//  Created by fatma on 24/09/1442 AH.
//

import UIKit


extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
