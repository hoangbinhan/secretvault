import Foundation
import UIKit
import AVKit
import NVActivityIndicatorView

// MARK: - Initializers
extension UIViewController {
    class func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            let bundle = Bundle(for: T.self)
            return T.init(nibName: String(describing: T.self), bundle: bundle)
        }
        
        return instantiateFromNib()
    }
    
    func showAlertConfirm(title: String?, message: String, titleAction: String, completion: (() -> Void)?, cancel: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleAction, style: .default) { _ in
            completion!()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            cancel?()
        })
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        let activityData = ActivityData(type: .ballClipRotate)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func showProgress() {
        let activityData = ActivityData(type: .lineSpinFadeLoader)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Saving video...")
    }
    
    func dismissProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
