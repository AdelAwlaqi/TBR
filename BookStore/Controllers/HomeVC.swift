//
//  HomeVC.swift
//  BookStore
//
//  Created by adol kazmy on 24/02/2021.
//

import UIKit
import Firebase


class HomeVC : UIViewController {
    
    //variables:
    var books = [BookObject]()
    var db: Firestore!
    var listner: ListenerRegistration!
    var selectedBook : BookObject?
    

    
    @IBOutlet weak var collectionView1: UICollectionView! {
        didSet {
            
            collectionView1.delegate = self ;collectionView1.dataSource = self
            collectionView1.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var collectionView2: UICollectionView! {
        didSet {
            
            collectionView2.delegate = self ;collectionView2.dataSource = self
            collectionView2.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
//        loadBooks()
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("reloadData"), object: nil)
       print(books.count)
        print("///////////////////////////////////")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProductsListner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listner.remove()
        books.removeAll()
        collectionView1.reloadData()
        collectionView2.reloadData()
    }
    
    func setProductsListner() {
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
    
//    @objc func reloadData() {
//        books.removeAll()
//        newBooks.removeAll()
//        collectionView1.reloadData()
//        collectionView2.reloadData()
//        loadBooks()
//
//    }
    
//    func loadBooks() {
//        books  = realm.objects(BookObject.self).sorted(byKeyPath: "title", ascending: true)
//        newBooks  = realm.objects(BookObject.self).sorted(byKeyPath: "date", ascending: false)
//        collectionView1.reloadData()
//        collectionView2.reloadData()
//
//    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAll", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? BookVC {
            destinationVC.selectedBook = selectedBook
        }
    }
    
}
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return books.count }
        if collectionView.tag == 2 {
            return books.count }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersCell
            cell.configureCell(book: books[indexPath.row])
            return cell
        }
        if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersCell
            cell.configureCell(book: books[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath : IndexPath ) -> CGSize {
        
        
        if collectionView.tag == 1 || collectionView.tag == 2 || collectionView.tag == 3 {
            
            let width = collectionView.frame.size.height / 1.7
            let height = collectionView.frame.size.height
            
            return CGSize(width: width , height: height)
            
        }
        return CGSize(width: 50 , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            selectedBook = books[indexPath.row] }
        if collectionView.tag == 2 {
            selectedBook = books[indexPath.row] }
        performSegue(withIdentifier: "toBook", sender: self)
    }
    
    func onDocumentAdded(change: DocumentChange, book: BookObject) {
        let newIndex = Int(change.newIndex)
        books.insert(book, at: newIndex)
        collectionView1.insertItems(at: [IndexPath(row: newIndex, section: 0)])
        collectionView2.insertItems(at: [IndexPath(row: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, book: BookObject) {
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            books[index] = book
            collectionView1.reloadItems(at: [IndexPath(row: index, section: 0)])
            collectionView2.reloadItems(at: [IndexPath(row: index, section: 0)])
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            books.remove(at: oldIndex)
            books.insert(book, at: newIndex)
            collectionView1.moveItem(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
            collectionView2.moveItem(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        books.remove(at: oldIndex)
        collectionView1.deleteItems(at: [IndexPath(row: oldIndex, section: 0)])
    }
    
    
}
