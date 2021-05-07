//
//  AddEditMovie.swift
//  MovieApp
//
//  Created by adol kazmy on 19/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage


class AddEditVC : UIViewController {
    
//    //Outlets:
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var authorTxt: UITextField!
    @IBOutlet weak var bookIDTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var quantityTxt: UITextField!
    @IBOutlet weak var bookImgLinkTxt: UITextField!
    @IBOutlet weak var uploadEditButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var bookLinkTxt: UITextField!
    
    
    //variables:
//    let realm = try! Realm()
    var newBook : BookObject?
    var selectedBook : BookObject?
    var addedOr : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isEnabled = false
//        editingMode()
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        
//        newBook?.title = titleTxt.text!
//        newBook?.author = authorTxt.text!
//        newBook?.bookImg = bookImgLinkTxt.text!
        //to check if these text fields do not have any letters:
        let letters = CharacterSet.letters
        if bookIDTxt.text!.rangeOfCharacter(from: letters) == nil ||
            priceTxt.text!.rangeOfCharacter(from: letters) == nil ||
            quantityTxt.text!.rangeOfCharacter(from: letters) == nil   {
//            newBook?.bookID = bookIDTxt.text!
//            newBook?.price = Double(Int(priceTxt.text!)!)
//            newBook?.quantity = Int(quantityTxt.text!) ?? 1
//            newBook?.timeStamp = Timestamp()
            uploadDocument()
    }
        
        simpleAlert(title: "يا سلااام", message: "تم اضافة الكتاب بنجاح وبامكان جميع المستخدمين تصفحه الان")
        navigationController?.popToRootViewController(animated: true)

    }
    
    func uploadDocument() {
        var docRef: DocumentReference!
        let price = Double(priceTxt.text!)!
        var book = BookObject.init(title: titleTxt.text!, bookID: UUID().uuidString, bookLink: bookLinkTxt.text!, author: authorTxt.text!, price: Double(Int(priceTxt.text!)!), quantity:  Int(quantityTxt.text!)!, bookImg: bookImgLinkTxt.text!, timeStamp: Timestamp(), added: addedOr)
        
        
            docRef = Firestore.firestore().collection("books").document()
            book.bookID = docRef.documentID
        
        
        let data = BookObject.modelToData(book: book)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to add product")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, message msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "حدث خطأ", message: msg)
    }

    
//    func editingMode() {
//        if selectedBook != nil {
//            deleteButton.isEnabled = true
//            titleTxt.text = selectedBook?.title
//            authorTxt.text = selectedBook?.author
//            priceTxt.text = selectedBook?.price.description
//            bookIDTxt.text = selectedBook?.bookID.description
//            quantityTxt.text = selectedBook?.quantity.description
//            bookImgLinkTxt.text = selectedBook?.bookImg
////            selectedBook?.date = Date()
//            uploadEditButton.setTitle("تعديل", for: .normal)
//            uploadEditButton.backgroundColor = #colorLiteral(red: 0, green: 0.5452948213, blue: 0.5925067663, alpha: 1)
//              }
       // }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: "حذف الكتاب؟", message: "هل أنت متأكد من حذف الكتاب؟", preferredStyle: .alert)
        let action = UIAlertAction(title: "نعم", style: .destructive) { (action) in
//            self.delete(book: self.selectedBook!)
            self.simpleAlert(title: "شكرا لك", message: "سيتم اضافة هذه الميزه قريباً")
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: nil, userInfo: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
