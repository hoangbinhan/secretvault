import Foundation

/**
 Api Configuration.
 */
public struct Api {
    
    /// Production Api.
    private struct Production {
        static let baseApiUrl = "https://api.nytimes.com/svc/books/v3/"
        static let clientId = "some_client_id" // sample: k7nZ7XmFEpIizaUZTTrcDPysKpsMGZzqMXpgwT1Y
        static let apiKey = "BBeAMcaq2y8fUI3l5WAPcdzgXRJBGOK9"
    }

    /// Development Api.
    private struct Development {
        static let baseApiUrl = "https://api.nytimes.com/svc/books/v3/"
        static let clientId = "some_client_id" // sample: k7nZ7XmFEpIizaUZTTrcDPysKpsMGZzqMXpgwT1Y
        static let apiKey = "BBeAMcaq2y8fUI3l5WAPcdzgXRJBGOK9"
    }
    
    /// Base Api url.
    public static var baseApiUrl: String {
        switch App.environment {
        case .production:
            return Production.baseApiUrl
            
        case .development:
            return Development.baseApiUrl
        }
    }
    
    /// Api client id.
    public static var clientId: String {
        switch App.environment {
        case .production:
            return Production.clientId
            
        case .development:
            return Development.clientId
        }
    }
    
    
    /// Api api key
    public static var apiKey: String {
        switch App.environment {
        case .production:
            return Production.apiKey
            
        case .development:
            return Development.apiKey
        }
    }
    
}
