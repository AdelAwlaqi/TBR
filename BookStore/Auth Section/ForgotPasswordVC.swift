//
//  ForgotPasswordVC.swift
//  BookStore
//
//  Created by fatma on 25/09/1442 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty else {
            simpleAlert(title: "Error", message: "اكتب بريدك الالكتروني!")
            return}
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
