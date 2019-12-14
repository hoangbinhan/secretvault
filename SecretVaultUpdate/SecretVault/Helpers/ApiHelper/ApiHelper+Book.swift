import Foundation
import Alamofire
extension ApiHelper {
    
    /// Get books by category.
    ///
    /// - parameter categoryId: category indentifier.
    /// - parameter hudType: hud type.
    /// - parameter completion: A closure to be executed once the request has finished.
    /// - parameter books: The response received from the server.
    /// - parameter error: The error received from the server.
//    class func getBooks(categoryId: String,
//                        completion: @escaping (_ books: [BookModel], _ error: ErrorResult?) -> Void) {
//        
//        let params : Parameters = [
//            "api-key": Api.apiKey
//        ]
//        //tương tự như ví dụ getAllCategories và một điểm đặc biệt
//        //ở vd này đường link có 1 tham số là api-key
//        //và 1 chổ cần thay đổi chính là id category
//        //đây là 1 link full: https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=your-api-key
//        //hardcover-fiction là id của category được tìm thấy ở api getAllCategories lấy từ field list_name_encoded, thay đổi hardcover-fiction thành 1 id category nào đó khác sẽ được list book tương ứng của loại đó
//        //các bước thực hiện:
//        //s1 trong biến Endpoint.books a có khai báo idcategory, các bạn thay idcategory bằng id category thật
//        let bookEndpoint = Endpoint.books.replacingOccurrences(of: "idcategory", with: categoryId)
//        //s2 gắng giá trị cho tham số api-key
//        let lastEndpoint = bookEndpoint + "?" + ApiManager.query(params)
//        ApiManager.makeGETRequest(baseUrl: Api.baseApiUrl, endPoint: lastEndpoint, param: nil, authorToken: nil) { (success, userInfo, json, error) in
//            if success == true,
//                let iJson = json,
//                let results = iJson["results"]["books"].array{
//                //                // Save to Realm if needed
//                //                if let books = results.results, books.isEmpty == false {
//                //                    let rlmBooks = DatabaseHelper.getBooks(categoryId: categoryId)
//                //                    _ = books.map({ (bookModel) -> BookModel in
//                //                        if let rlmBook = rlmBooks.first(where: { $0.identifier == "\(bookModel.identifier)-\(categoryId)" }) {
//                //                            bookModel.isFavorite = rlmBook.isFavorite
//                //                        }
//                //                        return bookModel
//                //                    })
//                //
//                //                    DatabaseHelper.saveBooks(books, categoryId: categoryId)
//                //                }
//                completion(BookModel.creBooks(array: results),nil)
//            }
//            else{
//                completion([],error)
//            }
//        }
//        
//    }
    
}
