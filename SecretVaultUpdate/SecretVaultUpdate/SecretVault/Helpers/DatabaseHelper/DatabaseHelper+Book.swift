import Foundation
import RealmSwift

extension DatabaseHelper {
    
//    /// Retrieves books by category from the default Realm
//    class func getBooks(categoryId: String) -> [BookModel] {
//        let realm = try! Realm()
//        let predicate = NSPredicate(format: "categoryId = %@", categoryId)
//        let results = realm.objects(RlmBookModel.self).filter(predicate)
//
//        let books = results.map({ $0.convert2Model() })
//        return Array(books)
//    }
//
//    /// Save books
//    class func saveBooks(_ books: [BookModel], categoryId: String) {
//        let realm = try! Realm()
//
//        // Remove old data of the category.
//        let predicate = NSPredicate(format: "categoryId = %@", categoryId)
//        let results = realm.objects(RlmBookModel.self).filter(predicate)
//        try! realm.write {
//            realm.delete(results)
//        }
//
//        var rlmBooks = [RlmBookModel]()
//        for book in books {
//            let rlmBook = RlmBookModel(bookModel: book)
//            rlmBook.identifier = book.identifier + "-" + categoryId
//            rlmBook.categoryId = categoryId
//            rlmBooks.append(rlmBook)
//        }
//
//        // Save new data
//        try! realm.write {
//            realm.add(rlmBooks)
//        }
//    }
//
//    /// Update favorite/un-favorite a book
//    class func saveFavorite(book: BookModel, categoryId: String) {
//        let realm = try! Realm()
//        let primaryKey = book.identifier + "-" + categoryId
//        let item = realm.object(ofType: RlmBookModel.self, forPrimaryKey: primaryKey)
//        if let item = item {
//            try! realm.write {
//                item.isFavorite = book.isFavorite
//            }
//        }
//    }
//
//    /// Update a book
//    class func saveBook(book: BookModel) {
//        let realm = try! Realm()
//        let rlmBook = RlmBookModel(bookModel: book)
//        try! realm.write {
//            realm.add(rlmBook, update: .modified)
//        }
//    }
//
//    /// Delete a book
//    class func deleteBook(identifier: String) {
//        let realm = try! Realm()
//        let item = realm.object(ofType: RlmBookModel.self, forPrimaryKey: identifier)
//        if let item = item {
//            try! realm.write {
//                realm.delete(item)
//            }
//        }
//        else {
//            DLog("Object not found")
//        }
//    }
}
