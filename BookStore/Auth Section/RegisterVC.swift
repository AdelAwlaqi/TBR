//
//  RegisterVC.swift
//  BookStore
//
//  Created by fatma on 25/09/1442 AH.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var passwordImg: UIImageView!
    @IBOutlet weak var confirmPasswordImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passwordText = passwordTxt.text else { return}
        
        if textField == confirmPasswordTxt {
            passwordImg.isHidden = false
            confirmPasswordImg.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordImg.isHidden = true
                confirmPasswordImg.isHidden = true
                confirmPasswordTxt.text = ""
            }
        }
        
        if passwordTxt.text == confirmPasswordTxt.text {
            passwordImg.image = UIImage(named: "green_check")
            confirmPasswordImg.image = UIImage(named: "green_check")
        } else {
            passwordImg.image = UIImage(named: "red_check")
            confirmPasswordImg.image = UIImage(named: "red_check")
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty,
            let username = usernameTxt.text, !username.isEmpty,
            let password = passwordTxt.text, !password.isEmpty else {
                simpleAlert(title: "Error", message: "الرجاء تعبئة بقية الخانات")
                return
        }
        
        guard let confirmPassword = confirmPasswordTxt.text, confirmPassword == password else {
            simpleAlert(title: "Error", message: "كلمات السر غير متطابقة")
            return
        }

        spinner.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.simpleAlert(title: "Error", message: "حدث خطأ أثناء التسجيل")
                self.spinner.stopAnimating()
                return
            }
            
            guard let firUser = result?.user else { return}
            let theUser = User(id: firUser.uid, email: email, username: username)
            
            self.createFireUser(user: theUser)
        }
        
    }
    
    func createFireUser(user: User) {
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        let data = User.modelToData(user: user)
        newUserRef.setData(data) { (error) in
            if let error = error {
                self.simpleAlert(title: "Error", message: "حدث خطأ أثناء التسجيل")
                debugPrint(error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
            return
        }
    }
}
