import Foundation
import DeviceKit

extension UIDevice {
    
    class func isRetinaDisplay() -> Bool {
        return (UIScreen.main.scale >= 2.0)
    }
    
    class func isPadDevice() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad)
    }
    
    class func isPhoneDevice() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone)
    }
    
    class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func screenMaxLength() -> CGFloat {
        return max(screenWidth(), screenHeight())
    }
    
    class func screenMinLength() -> CGFloat {
        return min(screenWidth(), screenHeight())
    }
    
    static var isRealDevice: Bool {
        return TARGET_OS_IPHONE != 0
    }
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static var isPhone: Bool {
        return Device.current.isPhone
    }
    
    static var isPod: Bool {
        return Device.current.isPod
    }
    
    static var isPad: Bool {
        return Device.current.isPad
    }
    
    static var isXSeriesDevices: Bool {
        return Device.current.isOneOf(Device.allXSeriesDevices) || Device.current.isOneOf(Device.allSimulatorXSeriesDevices)
    }
    
    static var isPlusSizedDevices: Bool {
        return Device.current.isOneOf(Device.allPlusSizedDevices) || Device.current.isOneOf(Device.allSimulatorPlusSizedDevices)
    }
    
    static var isProDevices: Bool {
        return Device.current.isOneOf(Device.allProDevices) || Device.current.isOneOf(Device.allSimulatorProDevices)
    }
    
    static var isMiniDevices: Bool {
        return Device.current.isOneOf(Device.allMiniDevices) || Device.current.isOneOf(Device.allSimulatorMiniDevices)
    }
    
    static var isTouchIDCapable: Bool {
        return Device.current.isTouchIDCapable
    }
    
    static var isFaceIDCapable: Bool {
        return Device.current.isFaceIDCapable
    }
    
    static var hasBiometricSensor: Bool {
        return Device.current.hasBiometricSensor
    }
    
    static var hasRoundedDisplayCorners: Bool {
        return Device.current.hasRoundedDisplayCorners
    }
    
    static var isScreenRatio23: Bool {
        let screenRatio = Device.current.screenRatio
        return Int(screenRatio.width) == 2 && Int(screenRatio.height) == 3
    }
    
    static var isScreenRatio34: Bool {
        let screenRatio = Device.current.screenRatio
        return Int(screenRatio.width) == 3 && Int(screenRatio.height) == 4
    }
    
    static var inches: Double {
        return Device.current.diagonal
    }
    
    class func isIPhone3_5Inch() -> Bool {
        // 320 x 480 (640 x 960) - 1x, 2x - 3.5" - 326, 163 PPI - 3:4
        return (screenMaxLength() == 480.0)
    }
    
    class func isIPhone4Inch() -> Bool {
        // 320 x 568 (640 x 1136) - 2x - 4" - 326 PPI - 9:16
        return (screenMaxLength() == 568.0)
    }
    
    class func isOrLessThanIPhone4Inch() -> Bool {
        // 320 x 568 (640 x 1136) - 2x - 4" - 326 PPI - 9:16
        return (screenMaxLength() <= 568.0)
    }
    
    class func isIPhone4_7Inch() -> Bool {
        // 375 x 667 (750 x 1334) - 2x - 4.7" - 326 PPI - 9:16
        return (screenMaxLength() == 667.0)
    }
    
    class func isIPhone5_5Inch() -> Bool {
        // 414 x 736 (1242 x 2208) - 3x - 5.5" - 401 PPI - 9:16
        return (screenMaxLength() == 736.0)
    }
    
    /// Has Notch (e.g iPhone X)
    class func hasNotchDisplay() -> Bool {
        return isXSeriesDevices
    }
    
    /// Has Safe Area supported.
    class func hasSafeArea() -> Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return true
        }
        return false
    }
    
    class func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
    
    // Get height of default status bar.
    class func statusBarHeight() -> CGFloat {
        let application = UIApplication.shared
        if application.isStatusBarHidden {
            return 0
        }
        
        return application.statusBarFrame.height
    }
    
}
