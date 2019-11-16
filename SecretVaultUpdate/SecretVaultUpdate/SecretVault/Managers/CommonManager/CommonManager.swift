import Foundation
import UIKit
import BRYXBanner

// MARK: - DLog

/// Console log with more information.
public func DLog<T>(_ object: @autoclosure () -> T, file: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
    
    let queue = Thread.isMainThread ? "FG" : "BG"
    let filePath = file as NSString
    
    let instance = object()
    let description: String
    
    description = "\(instance)"
    
    print("\(dateFormatter.string(from: Date())) [\(queue)] [\(filePath.lastPathComponent):\(line)] > \(description)\n")
    #endif
}

// MARK: - Application Info
class CommonManager {

    /// Application name.
    ///
    /// - Returns: Application icon.
    class func applicationName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleName"] as? String
    }
    
    /// Application display name.
    ///
    /// - Returns: Application display name.
    class func applicationDisplayName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
    }
    
    /// Application version.
    ///
    /// - Returns: Application version.
    class func applicationVersion() -> String? {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    /// Application build number.
    ///
    /// - Returns: Application build number.
    class func bundleVersion() -> String? {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    }
    
    /// Application build number.
    ///
    /// - Returns: Application build number.
    class func bundleVersionNumber() -> Int {
        if let build = self.bundleVersion(), let buildNumber = Int(build) {
            return buildNumber
        }
        return 0
    }
    
    /// Application identifier (bundle identifier).
    ///
    /// - Returns: Application identifier.
    class func bundleIdentifier() -> String? {
        return Bundle.main.bundleIdentifier
    }
    
    /// Set root view controller with animation.
    class func setRootViewController(_ viewController: UIViewController, window: UIWindow?, withTransition transition: UIView.AnimationOptions?, completion: ((_ finished: Bool) -> Void)?) {
        
        let oldViewController: UIViewController? = window?.rootViewController
        
        if let oldViewController = oldViewController, let transition = transition {
            viewController.view.frame = oldViewController.view.frame
            viewController.view.layoutIfNeeded()
            
            UIView.transition(from: oldViewController.view,
                              to: viewController.view,
                              duration: 0.5,
                              options: [transition, .allowAnimatedContent, .layoutSubviews],
                              completion: {(_ finished: Bool) -> Void in
                                
                                window?.rootViewController = viewController
                                window?.makeKeyAndVisible()
                                completion?(finished)
            })
        }
        else {
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
            completion?(true)
        }
    }
}

// MARK: - Banner alert
extension CommonManager {
    /// Show banner alert.
    class func dropDownAlert(title: String?,
                             message: String,
                             backgroundColor: UIColor) {
        
        self.dropDownAlert(title: title,
                           message: message,
                           image: nil,
                           backgroundColor: backgroundColor,
                           didTapBlock: nil)
    }
    
    /// Show banner alert.
    class func dropDownAlert(title: String?,
                             message: String,
                             image: UIImage?,
                             backgroundColor: UIColor,
                             didTapBlock: (() -> Void)? = nil) {
        
        Thread.mainSync {
            let banner = Banner(title: title,
                                subtitle: message,
                                image: image,
                                backgroundColor: backgroundColor,
                                didTapBlock: didTapBlock)
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
}
