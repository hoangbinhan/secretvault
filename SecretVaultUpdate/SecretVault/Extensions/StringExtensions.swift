import Foundation
import UIKit

extension String {

    /// Converts String to Int
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// Converts String to UInt
    func toUInt() -> UInt? {
        if let num = NumberFormatter().number(from: self) {
            return num.uintValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Double
    func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Float
    func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
}

// MARK: - Get extension filename
extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
}

// MARK: - Encode, Decode
extension String {
    
    var encodedURL: String? {
        if self == decodedURL {
            // The URL was not encoded yet
            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        
        // The URL was already encoded
        return self
    }
    
    var decodedURL: String? {
        return self.removingPercentEncoding
    }
    
}

// MARK: - Wrapped
extension Optional where Wrapped == String {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var value: String { return self ?? "" }
}
