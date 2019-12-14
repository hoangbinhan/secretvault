import Foundation

extension NSNumber {
    
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
    
    class func isNumeric(string: String) -> Bool {
        let scanner = Scanner(string: string)
        
        // A newly-created scanner has no locale by default.
        // We'll set our scanner's locale to the user's locale
        // so that it recognizes the decimal separator that
        // the user expects (for example, in North America,
        // "." is the decimal separator, while in many parts
        // of Europe, "," is used).
        scanner.locale = NSLocale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
}
