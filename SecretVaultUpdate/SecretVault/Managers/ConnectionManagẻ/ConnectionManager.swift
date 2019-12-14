import Foundation
import Reachability
import AlamofireNetworkActivityIndicator

let kDateOfLastNoConnectionAlert = "kDateOfLastNoConnectionAlert"
let kTimeIntervalBetweenNoConnectionAlerts = 5
let kBannerColorWarning = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 51.0/255.0, alpha: 1.000)

// MARK: - ConnectionManager

/// Connection Manager.
class ConnectionManager: NSObject {
    
    // MARK: - Constants
    
    public static let networkChangedNotificationName = Notification.Name.reachabilityChanged
    
    // MARK: - Properties
    
    public static let shared = ConnectionManager.init()
    private var reachability: Reachability?
    private var reachable = true
    
    // MARK: - Dealloc
    
    deinit {
        self.stopNotifier()
    }
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        self.setupReachability()
        self.startNotifier()
    }
    
    // MARK: - Reachability
    
    /// Setup Reachability.
    private func setupReachability() {
        
        DLog("ConnectionManager: set up")
        
        let reachability = Reachability()
        self.reachability = reachability
        
        if let reachability = reachability {
            self.reachable = reachability.connection != .none
        }
        
        reachability?.whenReachable = { reachability in
            ConnectionManager.shared.reachable = true
            DLog("ConnectionManager: whenReachable: \(ConnectionManager.shared.reachable)")
            DLog("\(reachability.description) - \(reachability.connection.description)")
        }
        reachability?.whenUnreachable = { reachability in
            ConnectionManager.shared.reachable = false
            DLog("ConnectionManager: whenUnreachable: \(ConnectionManager.shared.reachable)")
            DLog("\(reachability.description) - \(reachability.connection.description)")
        }
    }
    
    /// Start notifier.
    private func startNotifier() {
        DLog("ConnectionManager: start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            DLog("ConnectionManager: unable to start notifier")
            return
        }
    }
    
    /// Stop notifier.
    private func stopNotifier() {
        DLog("ConnectionManager: stop notifier")
        reachability?.stopNotifier()
        reachability = nil
    }
    
    // MARK: - AlamofireNetworkActivityIndicator
    
    /**
     Controls the visibility of the network activity indicator on iOS using Alamofire.
     
     The NetworkActivityIndicatorManager manages the state of the network activity indicator. To begin using it, all that is required is to enable the shared instance in application:didFinishLaunchingWithOptions: in your AppDelegate.
     */
    private func setupNetworkActivityIndicator() {
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        //The default value is 1.0 second
        NetworkActivityIndicatorManager.shared.startDelay = 1.0
        
        //The default value is 0.2 seconds
        NetworkActivityIndicatorManager.shared.completionDelay = 0.2
    }
    
    
    // MARK: - Internet Connection
    
    /// Start Network Monitoring
    public func startNetworkMonitoring() {
        self.setupNetworkActivityIndicator()
    }
    
    /// Stop Network Monitoring
    public func stopNetworkMonitoring() {
        self.stopNotifier()
        NetworkActivityIndicatorManager.shared.isEnabled = false
    }
    
    /// Check connection available.
    ///
    /// - Returns: True if connection to internet is available
    public var connectionAvailable: Bool {
        
        //return self.reachability?.isReachable ?? false
        DLog("ConnectionManager: reachable: \(ConnectionManager.shared.reachable)")
        return ConnectionManager.shared.reachable
    }
    
    /// Check and Fires UI alert if no connection internet is available. (This method cannot check active internet connection).
    ///
    /// - Returns: True if no internet connection available.
    public func noConnection(showAlert: Bool = true) -> Bool {
        
        if self.connectionAvailable == false {
            
            if showAlert {
                let lastAlert = UserDefaults.obj(forKey: kDateOfLastNoConnectionAlert) as? NSDate
                if lastAlert == nil || Int(lastAlert!.timeIntervalSinceNow) < -kTimeIntervalBetweenNoConnectionAlerts {
                    DLog("ConnectionManager: No Internet Connection")
                    UserDefaults.setObj(Date(), forKey: kDateOfLastNoConnectionAlert)
                    
                    CommonManager.dropDownAlert(title: "No Internet Connection", message: "Your internet connection appears to be offline or too weak. Please try again later.", backgroundColor: kBannerColorWarning)
                }
            }
            return true
        }
        
        return false
    }
    
}
