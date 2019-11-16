import Foundation
import UIKit

/// All fonts define here.
public struct Font {
    
    public static func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size * Constants.Scale.font, weight: weight)
    }
    
    public static func font(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size * Constants.Scale.font) {
            return font
        }
        print("Missing Font: \(name)")
        return UIFont.systemFont(ofSize: size * Constants.Scale.font)
    }
    
    public struct SFProDisplay {
        public static let blackItalic: String   = "SFProDisplay-BlackItalic"
        public static let black: String         = "SFProDisplay-Black"
        public static let boldItalic: String    = "SFProDisplay-BoldItalic"
        public static let bold: String          = "SFProDisplay-Bold"
        public static let lightItalic: String   = "SFProDisplay-LightItalic"
        public static let light: String         = "SFProDisplay-Light"
        public static let mediumItalic: String  = "SFProDisplay-MediumItalic"
        public static let medium: String        = "SFProDisplay-Medium"
        public static let regularItalic: String = "SFProDisplay-RegularItalic"
        public static let regular: String       = "SFProDisplay-Regular"
        public static let thinItalic: String    = "SFProDisplay-ThinItalic"
        public static let thin: String          = "SFProDisplay-Thin"
    }
    
    public struct SFProText {
        public static let blackItalic: String   = "SFProText-BlackItalic"
        public static let black: String         = "SFProText-Black"
        public static let boldItalic: String    = "SFProText-BoldItalic"
        public static let bold: String          = "SFProText-Bold"
        public static let lightItalic: String   = "SFProText-LightItalic"
        public static let light: String         = "SFProText-Light"
        public static let mediumItalic: String  = "SFProText-MediumItalic"
        public static let medium: String        = "SFProText-Medium"
        public static let regularItalic: String = "SFProText-RegularItalic"
        public static let regular: String       = "SFProText-Regular"
        public static let thinItalic: String    = "SFProText-ThinItalic"
        public static let thin: String          = "SFProText-Thin"
    }
    
}
