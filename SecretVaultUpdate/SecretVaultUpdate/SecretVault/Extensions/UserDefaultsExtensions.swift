import Foundation

extension UserDefaults {
    
    // MARK: - UserDefaults
    class func obj(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        
        let obj = defaults.object(forKey: key)
        return obj
    }
    
    class func setObj(_ obj: Any?, forKey key: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(obj, forKey: key)
        defaults.synchronize()
    }
    
    class func removeObj(forKey key: String) {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    class func obj(forKey key: String, unarchive: Bool) -> Any? {
        var obj = self.obj(forKey: key)
        //Check for archiving/unarchiving
        if unarchive && (obj is Data) {
            obj = NSKeyedUnarchiver.unarchiveObject(with: obj as! Data)
        }
        return obj
    }
    
    class func setObj(_ obj: Any?, forKey key: String, archive: Bool) {
        
        //Error protection
        if let obj = obj {
            if archive && (obj as AnyObject).responds!(to: #selector(NSData.encode(with:))) {
                let objData = NSKeyedArchiver.archivedData(withRootObject: obj)
                self.setObj(objData, forKey: key)
            } else {
                self.setObj(obj, forKey: key)
            }
        }
    }
    
    class func clearDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
}
