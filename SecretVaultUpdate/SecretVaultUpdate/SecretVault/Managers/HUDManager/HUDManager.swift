import Foundation
import PKHUD
import NVActivityIndicatorView

/// HUD Manager.
class HUDManager {
    
    public enum HUDType {
        case none
        case progress
        case system
    }
    
    /// Get top window.
    ///
    /// - Returns: Top window.
    public class func topWindow(overKeyboard: Bool = true) -> UIWindow? {
        var window: UIWindow?
        if overKeyboard {
            window = UIApplication.shared.windows.last
        } else {
            window = UIApplication.shared.keyWindow
        }
        
        if #available(iOS 11.0, *) {
            if overKeyboard {
                // In iOS 11, WindowLevel of keyboard window is 10000001.
                // https://forums.developer.apple.com/thread/86072
                let filteredArray = UIApplication.shared.windows.filter({Int($0.windowLevel.rawValue) == 10000001})
                if filteredArray.count > 0 {
                    window = filteredArray.first
                } else {
                    window = UIApplication.shared.keyWindow
                }
            }
        }
        
        return window
    }
    
    /// Check HUD is visible.
    ///
    /// - Returns: True if HUD visible.
    public class func isHUDVisible() -> Bool {
        return HUD.isVisible
    }
    
    /// Show Progress HUD.
    public class func showProgressHUD(dimsBackground: Bool = false, text: String? = "Please wait", overKeyboard: Bool = true) {
        HUD.dimsBackground = dimsBackground
        HUD.allowsInteraction = false
        
        Thread.mainSync {
            if text != nil {
                HUD.show(.labeledProgress(title: nil, subtitle: text!), onView: self.topWindow(overKeyboard: overKeyboard))
            } else {
                HUD.show(.progress, onView: self.topWindow(overKeyboard: overKeyboard))
            }
        }
    }
    
    public class func showSystemHUD() {
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
        Thread.mainSync {
            // let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
            // indicatorView.startAnimating()
            
            let frame = CGRect(x: 5, y: 5, width: 30, height: 30)
            let progressView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin)
            progressView.color = .white
            
            let customView = UIView(frame: CGRect(x: 0, y: 0, w: 40, h: 40))
            customView.addSubview(progressView)
            progressView.startAnimating()
            
            HUD.show(.customView(view: customView))
        }
    }
    
    public class func showHUD(type: HUDType, dimsBackground: Bool = false, overKeyboard: Bool = true) {
        if type == .progress {
            self.showProgressHUD(dimsBackground: dimsBackground, overKeyboard: overKeyboard)
        }
        else if type == .system {
            self.showSystemHUD()
        }
        else {
            // do nothing
        }
    }
    
    
    /// Show Text HUD.
    public class func showTextHUD(dimsBackground: Bool = false, text: String, overKeyboard: Bool = true) {
        HUD.dimsBackground = dimsBackground
        HUD.allowsInteraction = false
        
        Thread.mainSync {
            HUD.show(.label(text), onView: self.topWindow(overKeyboard: overKeyboard))
        }
    }
    
    /// Hide HUD.
    public class func hideHUD(showComplete: Bool = false) {
        
        if HUD.isVisible {
            Thread.mainSync {
                if showComplete {
                    HUD.flash(.success, delay: 1.0)
                } else {
                    HUD.hide()
                }
            }
        }
        
    }
    
}
