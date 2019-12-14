import Foundation
import RealmSwift

extension DatabaseHelper {
    
    /// Retrieves all Categories from the default Realm
//    class func getAllCategories() -> [CategoryModel] {
//        let realm = try! Realm()
//        let results = realm.objects(RlmCategoryModel.self)
//        
//        let categories = results.map({ $0.convert2Model() })
//        return Array(categories)
//    }
//    
//    /// Save categories
//    class func saveCategories(_ categories: [CategoryModel]) {
//        let realm = try! Realm()
//        
//        // Remove old data.
//        let results = realm.objects(RlmCategoryModel.self)
//        try! realm.write {
//            realm.delete(results)
//        }
//        
//        var rlmCategories = [RlmCategoryModel]()
//        for category in categories {
//            let rlmCategory = RlmCategoryModel(categoryModel: category)
//            rlmCategories.append(rlmCategory)
//        }
//        
//        // Save new data
//        try! realm.write {
//            realm.add(rlmCategories)
//        }
//    }
//    
//    /// Update a category
//    class func saveCategory(category: CategoryModel) {
//        let realm = try! Realm()
//        let rlmCategory = RlmCategoryModel(categoryModel: category)
//        try! realm.write {
//            realm.add(rlmCategory, update: .modified)
//        }
//    }
//    
//    /// Delete a category
//    class func deleteCategory(identifier: String) {
//        let realm = try! Realm()
//        let item = realm.object(ofType: RlmCategoryModel.self, forPrimaryKey: identifier)
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
