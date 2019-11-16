import Foundation
import SwiftyJSON



/// A closure executed when request complete.
/// 1 is state of response true or false
/// 2 user info if needed
/// 3 JSON response
/// 4 Error of response if needed
typealias ApiCompletionHandler =  (Bool,[String:Any]?,JSON?,ErrorResult?)->Void





/**
 HTTP Header Content Type.
 - json
 - form
 */
public enum aHTTPContentType {
    case json
    case form
}


/// HTTP Header Field
public struct aHTTPHeaderField {
    public static let contentType = "Content-Type"
    public static let accept = "Accept"
    public static let appVersion = "APP-VERSION"
    public static let deviceId = "DEVICE-ID"
    public static let timeZone = "TIMEZONE"
}


/// HTTP Header Value
public struct aHTTPHeaderValue {
    public static let json = "application/json"
    public static let formUrlEncoded = "application/x-www-form-urlencoded"
}


/// Api data key.
public struct ApiDataKey {
    public static let success = "success"
    public static let message = "message"
    public static let results = "results"
    public static let errorCode = "error_code"
    public static let errorTitle = "error_title"
    public static let errorMessage = "error_message"
}

// Http code
public let HttpUnknownErrorCode = -10000
public let HttpCancelledErrorCode = -999
public let HttpSuccessCode = 200

/// Default HttpResponseErrorDomain
public let HttpResponseErrorDomain = "HttpResponseErrorDomain"


// MARK: - ApiConfiguration
public class ApiConfiguration {
    
    // MARK: - Constants
    
    
    
    // MARK: - Properties
    public static let shared = ApiConfiguration()
    
    /// The timeout interval to use when waiting for additional data. The default value is 60.
    public var timeoutInterval: TimeInterval = 60
    
    
    // MARK: - Initializers
    
    // Made now private initializer
    private init() {
        
    }
}
