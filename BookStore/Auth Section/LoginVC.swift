//
//  LoginVC.swift
//  BookStore
//
//  Created by fatma on 25/09/1442 AH.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty,
            let password = passwordTxt.text, !password.isEmpty else {
                simpleAlert(title: "Error", message: "أكمل تعبئة بقية الخانات")
                return}
        
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                debugPrint(error)
                self.spinner.stopAnimating()
                return
            }
            
            self.spinner.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
