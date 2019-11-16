import Foundation
import UIKit

extension CGRect {
    /// Easier initialization of CGRect
    init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
    
    /// X value of CGRect's origin
    var x: CGFloat {
        get {
            return self.origin.x
        } set(value) {
            self.origin.x = value
        }
    }
    
    /// Y value of CGRect's origin
    var y: CGFloat {
        get {
            return self.origin.y
        } set(value) {
            self.origin.y = value
        }
    }
    
    /// Width of CGRect's size
    var w: CGFloat {
        get {
            return self.size.width
        } set(value) {
            self.size.width = value
        }
    }
    
    /// Height of CGRect's size
    var h: CGFloat {
        get {
            return self.size.height
        } set(value) {
            self.size.height = value
        }
    }
    
    /// Surface Area represented by a CGRectangle
    var area: CGFloat {
        return self.h * self.w
    }
}
