//
//  MovieObject.swift
//  MovieApp
//
//  Created by adol kazmy on 18/02/2021.
//

import Foundation
import FirebaseFirestore

struct BookObject {
    var title: String
    var bookID: String
    var author: String
    var price: Double
    var quantity: Int
    var bookImg: String
    var timeStamp: Timestamp
    var numCopy: Int
    var added: Bool
    
    init(title: String, bookID: String, author: String, price: Double, quantity: Int, bookImg: String, timeStamp: Timestamp, numCopy: Int = 0, added: Bool) {
        self.title = title
        self.bookID = bookID
        self.author = author
        self.price = price
        self.quantity = quantity
        self.bookImg = bookImg
        self.numCopy = numCopy
        self.added = added
        self.timeStamp = timeStamp
    }
    
    init(data: [String: Any]) {
        self.title = data["title"] as? String ?? ""
        self.bookID = data["bookID"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.quantity = data["quantity"] as? Int ?? 0
        self.bookImg = data["bookImg"] as? String ?? ""
        self.numCopy = data["numCopy"] as? Int ?? 0
        self.timeStamp = data["timestamps"] as? Timestamp ?? Timestamp()
        self.added = data["added"] as? Bool ?? false
    }
    
    static func modelToData(book: BookObject) -> [String: Any]{
        let data : [String: Any] = [
            "title" : book.title,
            "bookID" : book.bookID,
            "author" : book.author,
            "price" : book.price,
            "quantity" : book.quantity,
            "bookImg" : book.bookImg,
            "numCopy": book.numCopy,
            "timeStamp": book.timeStamp,
            "added": book.added
        ]
        
        return data
    }
}

extension BookObject: Equatable {
    static func ==(lhs: BookObject, rhs: BookObject) -> Bool {
        return lhs.bookID == rhs.bookID
    }
}

