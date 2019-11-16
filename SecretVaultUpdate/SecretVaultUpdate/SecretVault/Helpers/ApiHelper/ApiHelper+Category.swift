import Foundation
import Alamofire
extension ApiHelper {
    
    
    
    /// Get all categories.
    ///
    /// - parameter hudType: hud type.
    /// - parameter completion: A closure to be executed once the request has finished.
    /// - parameter categories: The response received from the server.
    /// - parameter error: The error received from the server.
//    class func getAllCategories( completion: @escaping (_ categories: [CategoryModel], _ error: ErrorResult?) -> Void) {
//        let param : Parameters = [
//            "api-key" : Api.apiKey
//        ]
//        //đặc thù cái sample này là những param nằm trên đường link:
//        //vd: https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=BBeAMcaq2y8fUI3l5WAPcdzgXRJBGOK9
//        //link trên base url là: https://api.nytimes.com/svc/books/v3/
//        //end point là: lists/names.json
//        //param là: ?api-key=BBeAMcaq2y8fUI3l5WAPcdzgXRJBGOK9
//        //nên cần 1 bước đưa những param lên đường link
//        let lastEndPoint = Endpoint.categories + "?" + ApiManager.query(param)
//
//        ApiManager.makeGETRequest(baseUrl: Api.baseApiUrl, endPoint: lastEndPoint, param: nil, headers: [:], authorToken: nil, encode: URLEncoding.default , isBearer: false) { (success, userInfo, json, error) in
//            if success == true,
//                let iJson = json,
//                let results = iJson["results"].array{
//                //                // Save to Realm if needed
//                //                if let categories = results.results, categories.isEmpty == false {
//                //                    DatabaseHelper.saveCategories(categories)
//                //                }
//                completion(CategoryModel.creCategories(array: results),nil)
//            }
//            else{
//                completion([],error)
//            }
//        }
//    }
//
//
//    class func smaplePOSTRequest( completion: @escaping (_ categories: [CategoryModel], _ error: ErrorResult?) -> Void) {
//        let param : Parameters = [
//            "name" : "some name",
//            "age" : "some age"
//        ]
//
//        ApiManager.makePOSTRequest(baseUrl: Api.baseApiUrl, endPoint: Endpoint.someEndpoint, param: param, authorToken: nil) { (success, userInfo, json, error) in
//            //logic samely with getAllCategories
//            //you can do something here for callback to Screen and show to User
//        }
//
//    }

    
}
