import Foundation
import UIKit

extension UIApplication {
    
    /// Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    // MARK: - Interaction Events
    public class func beginIgnoringInteractionEvents() {
        if UIApplication.shared.isIgnoringInteractionEvents == false {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    public class func endIgnoringInteractionEvents() {
        if UIApplication.shared.isIgnoringInteractionEvents == true {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
