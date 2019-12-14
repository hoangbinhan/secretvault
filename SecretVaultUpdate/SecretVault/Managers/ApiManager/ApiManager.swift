import Foundation
import Alamofire
import SwiftyJSON


class ApiManager{
    
    static let defaultHeader : HTTPHeaders = ["Content-Type": "application/json",
                                              "Accept": "application/json"]
    
    class func makeRequest(baseUrl:String,
                           endPoint:String,
                           method:HTTPMethod,
                           param:Parameters?,
                           headers:HTTPHeaders = defaultHeader,
                           authorToken : String?,
                           encode: ParameterEncoding = URLEncoding.default,
                           isBearer: Bool = true,
                           completion:@escaping ApiCompletionHandler){
        
        var iheader = headers
        if let token = authorToken{
            if isBearer == true{
                iheader["Authorization"] = String.init(format: "Bearer %@", token)
            }
            else{
                iheader["Authorization"] = String.init(format: "Token %@", token)
            }
        }
    
        let url = baseUrl + endPoint
        debugPrint("url: \(url)")
        
        
        Alamofire.request(url, method: method, parameters: param , encoding: encode , headers: iheader).responseJSON { (data) in
            switch data.result{
            case .success(let ivalue):
                let ijson = JSON(ivalue)
                completion(true,nil,ijson,nil)
                break
            case .failure(let ierr):
                let err = ErrorConstants.ErrorMessage.error(ierr)
                completion(false,nil,nil,err)
                break
            }
        }
    }

    
    class func makeGETRequest(baseUrl:String,
                              endPoint:String,
                              param:Parameters?,
                              headers:HTTPHeaders = defaultHeader,
                              authorToken : String?,
                              encode: ParameterEncoding = URLEncoding.default,
                              isBearer: Bool = true,
                              completion:@escaping ApiCompletionHandler){
        makeRequest(baseUrl: baseUrl,
                    endPoint: endPoint,
                    method: .get,
                    param: param,
                    headers: headers,
                    authorToken: authorToken,
                    encode: encode,
                    isBearer: isBearer,
                    completion: completion)
    }

    
    class func makePOSTRequest(baseUrl:String,
                              endPoint:String,
                              param:Parameters?,
                              headers:HTTPHeaders = defaultHeader,
                              authorToken : String?,
                              encode: ParameterEncoding = JSONEncoding.default,
                              isBearer: Bool = true,
                              completion:@escaping ApiCompletionHandler){
        makeRequest(baseUrl: baseUrl,
                    endPoint: endPoint,
                    method: .post,
                    param: param,
                    headers: headers,
                    authorToken: authorToken,
                    encode: encode,
                    isBearer: isBearer,
                    completion: completion)
    }
    
    class func makePATCHRequest(baseUrl:String,
                                endPoint:String,
                                param:Parameters?,
                                headers:HTTPHeaders = defaultHeader,
                                authorToken : String?,
                                encode: ParameterEncoding = JSONEncoding.default,
                                isBearer: Bool = true,
                                completion:@escaping ApiCompletionHandler) {
        makeRequest(baseUrl: baseUrl,
                    endPoint: endPoint,
                    method: .patch,
                    param: param,
                    headers: headers,
                    authorToken: authorToken,
                    encode: encode,
                    isBearer: isBearer,
                    completion: completion)
    }
    
    class func makeDELETERequest(baseUrl:String,
                                endPoint:String,
                                param:Parameters?,
                                headers:HTTPHeaders = defaultHeader,
                                authorToken : String?,
                                encode: ParameterEncoding = JSONEncoding.default,
                                isBearer: Bool = true,
                                completion:@escaping ApiCompletionHandler) {
        makeRequest(baseUrl: baseUrl,
                    endPoint: endPoint,
                    method: .delete,
                    param: param,
                    headers: headers,
                    authorToken: authorToken,
                    encode: encode,
                    isBearer: isBearer,
                    completion: completion)
    }
    
    class func makePUTRequest(baseUrl:String,
                              endPoint:String,
                              param:Parameters?,
                              headers:HTTPHeaders = defaultHeader,
                              authorToken : String?,
                              encode: ParameterEncoding = JSONEncoding.default,
                              isBearer: Bool = true,
                              completion:@escaping ApiCompletionHandler){
        makeRequest(baseUrl: baseUrl,
                    endPoint: endPoint,
                    method: .put,
                    param: param,
                    headers: headers,
                    authorToken: authorToken,
                    encode: encode,
                    isBearer: isBearer,
                    completion: completion)
    }
    
}


extension ApiManager{
    
    public class func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private class func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    private class func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
}
