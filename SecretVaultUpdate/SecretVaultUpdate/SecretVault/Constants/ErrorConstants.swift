import Foundation
import UIKit

public typealias ErrorResult = (code: Int, title: String, message: String)
public struct ErrorConstants {
    
    /// Error code.
    public enum ErrorCode: Int {
        case general = 0
        
        case apiTokenExpired = -2
        
        case objectNotFound = 1001
        
        /// No internet connection
        case noInternetConnection = -9000
        
        /// Unknown error code.
        case unknownErrorCode = -10000
        
        ///Request api limit
        case rateLimite = 429

    }
    
    /// Error Message.
    public struct ErrorMessage {
        
        public static let defaultTitle          = "Error"
        public static let generalTitle          = "Oops!"
        
        public static let defaultMessage        = "We hit a snag. Please try again in a bit."
        public static let generalMessage        = "Something went wrong. Please try again in a bit."
        public static let networkMessage        = "Your internet connection appears to be offline or too weak. Please try again later."
        public static let rateLimitMessage      = "Rate limit quota violation. Quota limit  exceeded."
        
        public static func error(_ error: Error?) -> ErrorResult {
            
            var code = ErrorCode.unknownErrorCode.rawValue
            var title = generalTitle
            var message = generalMessage
            
            if let err = error as NSError? {
                code = err.code
                
                switch err.code {
                    
                case ErrorCode.noInternetConnection.rawValue:
                    title = generalTitle
                    message = networkMessage
                    
                case ErrorCode.unknownErrorCode.rawValue:
                    // No error code response from API, display general error
                    title = generalTitle
                case ErrorCode.rateLimite.rawValue:
                    title = generalTitle
                    message = rateLimitMessage
                default:
                    
                    // Only show error message response from APIs
                    if err.domain == HttpResponseErrorDomain {
                        message = err.localizedDescription
                        
                        if message.isEmpty {
                            message = generalMessage
                        }
                        
                        if let errorTitle = err.userInfo[ApiDataKey.errorTitle] as? String, errorTitle.isEmpty == false {
                            title = errorTitle
                        }
                    }
                    else {
                        // System error
                        title = generalTitle
                        message = generalMessage
                        
                        // err.domain != HttpResponseErrorDomain
                        /*
                         kCFURLErrorCannotFindHost = -1003,
                         kCFURLErrorCannotConnectToHost = -1004,
                         kCFURLErrorNetworkConnectionLost = -1005,
                         kCFURLErrorDNSLookupFailed = -1006
                         kCFURLErrorNotConnectedToInternet = -1009
                         */
                        if code == -1003 || code == -1004 || code == -1005 || code == -1006 || code == -1009 {
                            message = networkMessage
                        }
                    }
                }
            }
            
            return (code, title, message)
        }
    }
    
    
}
