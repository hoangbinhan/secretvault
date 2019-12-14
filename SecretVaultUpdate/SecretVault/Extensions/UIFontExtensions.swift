import Foundation
import UIKit

extension UIFont {
    
    final class func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size * Constants.Scale.font, weight: weight)
    }
    
    /*
    var bold: UIFont {
        return with(traits: .traitBold)
    }*/
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    }
    
    /*
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    }*/
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }
    
    func without(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }
}
