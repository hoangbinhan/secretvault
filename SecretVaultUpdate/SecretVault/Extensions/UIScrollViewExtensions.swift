import Foundation
import UIKit

extension UIScrollView {
    
    func scrollToTop(animated: Bool) {
        let inset = CGPoint(x: 0, y: -self.contentInset.top)
        self.setContentOffset(inset, animated: animated)
    }
    
}
