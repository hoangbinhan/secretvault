import Foundation

// MARK: - App Environment

/**
 App Environment.
 - development
 - production
 */
public enum AppEnvironment {
    
    /// Development environment.
    case development
    
    /// Production environment.
    case production
}


// MARK: - App Configuration

/**
 App Configuration.
 */
public struct App {
    
    public static let environment = AppEnvironment.development
//    public static let environment = AppEnvironment.production
    
    
}
