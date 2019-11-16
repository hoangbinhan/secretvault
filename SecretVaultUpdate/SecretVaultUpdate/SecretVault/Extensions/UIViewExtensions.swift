import Foundation
import UIKit

extension UIView {
    class func loadFromNib() -> Self {
        func instantiateFromNib<T: UIView>() -> T {
            let bundle = Bundle(for: T.self)
            let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
            
            guard let view = nib.instantiate(withOwner: T.self, options: nil).first as? T else {
                fatalError("Could not load view from nib file.")
            }
            return view
        }
        
        return instantiateFromNib()
    }
    
    class func nibName() -> String {
        let nibName = String(describing: self)
        return nibName
    }
    
    class func identifier() -> String {
        let identifier = String(describing: self)
        return identifier
    }
    
    class func nib() -> UINib {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib
    }
}

