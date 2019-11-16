import Foundation
import UIKit

public struct Constants {
    
    /// Dropbox Key
    struct DropboxKey {
        static let fullDropboxAppKey = "8i5mkss441dpb0o";
        static let fullDropboxAppSecret = "kzi57ugnm57lhk7";
    }
    
    struct GoogleKey {
        static let clientID = "560088247298-glcs8gog1n6flks7i8gou4a4ve07ua2p.apps.googleusercontent.com"
        static let reveresdClientID = "com.googleusercontent.apps.1067934178087-bevmcndno12ka8iov2j1vtepd6girms5"
    }
    
    struct OneDriveKey {
        static let clienId =  "022a573a-851c-46d9-9d8d-7da6a628bd70"
    }
    
    /// Default Folder
    struct DefaultFolder {
        static let titleFileImport = "fileimport"
        static let titlePlaylist = "MyPlaylist"
        static let basePath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents") as String
    }
    
    /// Scale
    public struct Scale {
        public static let display: CGFloat     = (UIScreen.main.bounds.width < 375.0) ? (UIScreen.main.bounds.width / 375.0) : 1.0
        public static let font: CGFloat        = (UIScreen.main.bounds.width < 375.0) ? (UIScreen.main.bounds.width / 375.0) : 1.0
    }
    
    /// Radius
    public struct Radius {
       
        public static let defaultTextFieldRadius:   CGFloat   = 8.0
        public static let defaultButtonRadius:      CGFloat   = 6.0
        
        //Home
        public static let defaultButtonHomeRadius:  CGFloat   = 8.0
        
        // Alert Custom
        public static let viewAlertRadius:          CGFloat   = 19.0
        public static let ButtonTextAlertRadius:    CGFloat   = 6.0
        
        
    }
    
    /// Image
    public struct ImageFileImport {
        public static let defautBackNavigationImage: UIImage    =   UIImage(named: "ic_back")!
        public static let imageFolder: UIImage                  =   UIImage(named: "ic_folder")!
        public static let imageCheck: UIImage                   =   UIImage(named: "ic_check")!
        public static let imageChecked: UIImage                 =   UIImage(named: "ic_checked")!
    }
    // Image
    public struct ImagePhotoVault{
        public static let defaultBackNavigationImage: UIImage = UIImage(named: "Icon")!
        public static let imageAlbum: UIImage = UIImage(named: "imagealbum")!
        public static let imageCamera : UIImage = UIImage(named: "Camera")!
        public static let imageCheck: UIImage = UIImage(named: "ic_check")!
        public static let imageChecked: UIImage = UIImage(named: "Check")!
    }
    
    //
    public struct Image {
        public static let defautBackNavigationImage: UIImage =  UIImage(named: "ic_back")!
    }
}
