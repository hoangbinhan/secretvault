import Foundation

extension Bool {
    
    init?(string: String) {
        
        let lowerString = string.lowercased()
        switch lowerString {
        case "true", "yes", "1":
            self = true
        case "false", "no", "0":
            self = false
        default:
            return nil
        }
    }
    
    init(number: Int) {
        self.init(truncating: number as NSNumber)
    }
    
    /// Converts Bool to String.
    func toString() -> String {
        return self == true ? "true" : "false"
    }
    
    /// Converts Bool to Int.
    func toInt() -> Int {
        return self ? 1 : 0
    }
    
    /// Toggle boolean value.
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
    /// Return inverted value of bool.
    var toggled: Bool {
        return !self
    }
}
