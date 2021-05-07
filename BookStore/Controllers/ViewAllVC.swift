//
//  ViewAllVC.swift
//  BookStore
//
//  Created by adol kazmy on 25/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewAllVC : UIViewController {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.delegate = self ; collectionView.dataSource = self
            collectionView.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }
    
    
     //variables:
    var bookObj : BookObject?
    var books : [BookObject] = []
    var db: Firestore!
    var listner: ListenerRegistration!
    var selectedBook : BookObject?

    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setBooksListner()
      }

    
    func setBooksListner() {
        var ref: Query!
        
        ref = db.collection("books")
            //.order(by: "timeStamp", descending: true)
        
        
        listner = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let book = BookObject(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, book: book)
                case .modified:
                    self.onDocumentModified(change: change, book: book)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? BookVC {
            destinationVC.selectedBook = selectedBook
        }
//        if let destinationVC2 = segue.destination as? SearchRate {
//            destinationVC2.delegate = self
//            print("Im Delegate")
//        }
    }

    
}
extension ViewAllVC :  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersCell
        cell.configureCell(book: books[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBook = books[indexPath.row]
        performSegue(withIdentifier: "toBook", sender: self)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath : IndexPath ) -> CGSize {
  
        
        let width = collectionView.frame.size.width / 2.8
        let height = collectionView.frame.size.width - 50

        return CGSize(width: width , height: height)
    }

    
    func onDocumentAdded(change: DocumentChange, book: BookObject) {
        let newIndex = Int(change.newIndex)
        books.insert(book, at: newIndex)
        collectionView.insertItems(at: [IndexPath(row: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, book: BookObject) {
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            books[index] = book
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            books.remove(at: oldIndex)
            books.insert(book, at: newIndex)
            collectionView.moveItem(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        books.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(row: oldIndex, section: 0)])
    }
    
    
    
  }


