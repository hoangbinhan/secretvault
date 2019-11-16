import Foundation
import UIKit

extension UISwitch {
    
    /// Toggles Switch
    func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}
