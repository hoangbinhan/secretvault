import Foundation

//Combines the first dictionary with the second and returns single dictionary
func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary {
    
    /// Unserialize JSON string into Dictionary
    static func jsonFrom(jsonString: String) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
            return data as? Dictionary
        } else {
            return nil
        }
    }
    
    /// Unserialize JSON data into Dictionary
    static func jsonFrom(jsonData: Data) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
            return data as? Dictionary
        } else {
            return nil
        }
    }
    
    /// Serialize NSDictionary into JSON string
    func formatJSON(prettyPrinted: Bool = false) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: prettyPrinted ? .prettyPrinted : JSONSerialization.WritingOptions()) {
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    /// Serialize NSDictionary into JSON data
    func jsonData() -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions())
        return jsonData
    }
    
    /// Checks if a key exists in the dictionary
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    private static func addingPercentEncodingForURLQueryValue(string: String) -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    /// Serialize NSDictionary into query string
    func queryString() -> String {
        let parameterArray = self.map { (key, value) -> String in
            if let keyString = key as? String,
                let percentEscapedKey = Dictionary.addingPercentEncodingForURLQueryValue(string: keyString),
                let percentEscapedValue = Dictionary.addingPercentEncodingForURLQueryValue(string: "\(value)") {
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            return ""
        }
        return parameterArray.joined(separator: "&")
    }
    
}
