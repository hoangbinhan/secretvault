import Foundation

public struct ThirdParty {
    
    /// Service key.
    public struct Service {
        private static let apiKeyProd = ""
        private static let apiKeyStage = ""
        private static let apiKeyDev = ""
        
        // Auto detect base on AppEnvironment.
        public static var apiKey: String {
            switch App.environment {
            case .production:
                return apiKeyProd
                
            case .development:
                return apiKeyDev
            }
        }
    }
    
}
