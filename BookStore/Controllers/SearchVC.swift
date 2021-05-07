//
//  SearchVC.swift
//  BookStore
//
//  Created by adol kazmy on 18/02/2021.
//

import UIKit
import Firebase


class SearchVC : UIViewController  {
    
    
    // outlets:
    @IBOutlet weak var searchName: UISearchBar! {
        didSet {
            searchName.delegate = self
        }
    }
    @IBOutlet weak var searchID: UISearchBar!{
        didSet {
            //searchID.delegate = self
        }
    }
    @IBOutlet weak var searchAuthor: UISearchBar!{
        didSet {
            //searchAuthor.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.delegate = self ; collectionView.dataSource = self
            collectionView.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }
    
    
     //variables:
    var bookObj : BookObject?
    var books : [BookObject] = []
    var selectedBook : BookObject?
    var db: Firestore!
    var listner: ListenerRegistration!

    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBooksListner()
        collectionView.reloadData()

             }


    func setBooksListner() {
       
        let path = Firestore.firestore().collection("books").whereField("title", isEqualTo: searchName.text!)
        
        
        listner = path.addSnapshotListener({ (snap, error) in
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
    }

    
}
extension SearchVC : UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchName.text != nil {
            books.removeAll()
            setBooksListner()
            collectionView.reloadData() }
        
        
//        if searchID.text != nil {
//
//        books = books?.filter("bookID CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
//            collectionView.reloadData()
//        }
//        if searchAuthor.text != nil {
//        books = books?.filter("author CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
//            collectionView.reloadData()
//        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchName.text?.count == 0 && searchID.text?.count == 0 && searchAuthor.text?.count == 0 {
            books.removeAll()
            setBooksListner()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }

       }
        else if searchName.text!.count > 0 {
            setBooksListner()
            collectionView.reloadData()
        }
//        else if searchID.text!.count > 0 {
//
//            books = books?.filter("bookID == %d", Int(searchID.text!))
//                collectionView.reloadData()
//        }
//        else if searchAuthor.text!.count > 0 {
//            books = books?.filter("author CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
//
//            collectionView.reloadData()
//        }
        
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath : IndexPath ) -> CGSize {
  
        
        let width = collectionView.frame.size.width / 2.2
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

