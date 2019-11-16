import Foundation

/// All notification name constants define here.
extension NSNotification.Name {
    

    // Categories
    static let fetchCategories              = Notification.Name(rawValue: "FETCH_CATEGORIES")
    static let CreateAndReNameFolder        = Notification.Name(rawValue: "CREATE_RENAME_FOLDER")
    static let isCanPushControolerDropBox   = Notification.Name(rawValue: "IsCanPushController")
    static let isDissmissAlertEditFile      = Notification.Name(rawValue: "isDissmissAlertEditFile")
    static let isRenameDone                 = Notification.Name(rawValue: "IsRenameDone")
    static let refreshFile                  = Notification.Name(rawValue: "refreshFile")

   // Browser - huy trắng
    static let backBrowser  = Notification.Name(rawValue: "BACK_BROWSER")
    static let nextBrowser  = Notification.Name(rawValue: "NEXT_BROWSER")
    static let hideBrowser  = Notification.Name(rawValue: "HIDE_BROWSER")
    static let doneBrowser  = Notification.Name(rawValue: "DONE_BROWSER")
    static let zoomBrowser  = Notification.Name(rawValue: "ZOOM_BROWSER")
    static let testBrowser  = Notification.Name(rawValue: "TEST_BROWSER")

    // Others
    //PhotoVault
    static let CreateAndRenameAlbum = Notification.Name(rawValue: "CREATE_ALBUM")
    // update new
       static let isRenamePhotoDone                 = Notification.Name(rawValue: "isRenamePhotoDone")
       static let isDissmissAlertEditAlbum          = Notification.Name(rawValue: "isDissmissAlertEditAlbum")
       static let isAddNumberPhoto                  = Notification.Name(rawValue: "isAddNumberPhoto")
       static let isTapPhoto                        = Notification.Name(rawValue: "isTapPhoto")

    
    // Password keeper
    static let Password = Notification.Name(rawValue: "FETCH_PASSWORD")

    // Contact
    static let Contact = Notification.Name(rawValue: "FETCH_CONTACT")
}
