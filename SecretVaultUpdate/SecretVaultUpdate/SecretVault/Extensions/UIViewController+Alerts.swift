import Foundation
import UIKit
/**
 Extension of UIViewController to conveniently show an alert or action sheet with a single line of code. Please note that these methods must be called from a UIViewController instance.
 */
extension UIViewController {
    
    // MARK: - Alert Style
    /**
     Present a title-only alert controller and an OK button to dissmiss the alert.
     - parameter title: The title of the alert.
     */
    func showAlertWithTitle(_ title: String?) {
        showAlert(title, message: nil, cancelButtonTitle: "OK")
    }
    
    /**
     Present a message-only alert controller and an OK button to dissmiss the alert.
     - parameter message: The message content of the alert.
     */
    func showAlertWithMessage(_ message: String?) {
        showAlert("", message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an alert controller with a title, a message and an OK button. Tap the OK button will dissmiss the alert.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     */
    func showAlert(title: String?, message: String?) {
        showAlert(title, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an alert controller with a title, a message and a cancel/dismiss button with a title of your choice.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     - parameter cancelButtonTitle: Title of the cancel button of the alert.
     */
    func showAlert(_ title: String?, message: String?, cancelButtonTitle: String) {
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        showAlert(title: title, message: message, alertActions: [cancelAction])
    }
    
    /**
     Present an alert controller with a title, a message and an array of handler actions.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     - parameter alertActions: An array of alert action in UIAlertAction class.
     */
    func showAlert(title: String?, message: String?, alertActions: [UIAlertAction]) {
        showAlert(title, message: message, preferredStyle: .alert, alertActions: alertActions)
    }
    
    // MARK: - Action Sheet Style
    /**
     Present a title-only action sheet and an OK button to dissmiss the alert.
     - parameter title: The title of the action sheet.
     */
    func showActionSheetWithTitle(_ title: String?) {
        showActionSheet(title, message: nil, cancelButtonTitle: "OK")
    }
    
    /**
     Present a message-only action sheet and an OK button to dissmiss the alert.
     - parameter message: The message content of the action sheet.
     */
    func showActionSheetWithMessage(_ message: String?) {
        showActionSheet(nil, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an action sheet with a title, a message and an OK button. Tap the OK button will dissmiss the alert.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     */
    func showActionSheet(_ title: String?, message: String?) {
        showActionSheet(title, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an action sheet with a title, a message and a cancel/dismiss button with a title of your choice.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     - parameter cancelButtonTitle: The title of the cancel button of the action sheet.
     */
    func showActionSheet(_ title: String?, message: String?, cancelButtonTitle: String) {
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [cancelAction])
    }
    
    /**
     Present an action sheet with a title, a message and an array of handler actions.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     - parameter alertActions: An array of alert actions in UIAlertAction class.
     */
    func showActionSheet(title: String?, message: String?, alertActions: [UIAlertAction]) {
        showAlert(title, message: message, preferredStyle: .actionSheet, alertActions: alertActions)
    }
    
    // MARK: - Common Methods
    /**
     Present an alert or action sheet with a title, a message and an array of handler actions.
     - parameter title: The title of the alert/action sheet.
     - parameter message: The message content of the alert/action sheet.
     - parameter alertActions: An array of alert action in UIAlertAction class.
     */
    func showAlert(_ title: String?, message: String?, preferredStyle: UIAlertController.Style, alertActions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AlertKit + UIViewController
// MARK: -

extension UIViewController {
    
    /// Show system alert with title, message, cancel button title.
    func showAlert(title: String?,
                   message: String?,
                   cancelButtonTitle: String,
                   cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction])
    }
    
    /// Show system alert with title, message, cancel button title, other button title.
    func showAlert(title: String?,
                   message: String?,
                   cancelButtonTitle: String,
                   cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                   otherButtonTitle: String,
                   otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction, otherAction])
    }
    
    /// Show system alert with title, message, cancel button title, destructive button title.
    func showAlert(title: String?,
                   message: String?,
                   cancelButtonTitle: String,
                   cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                   destructiveButtonTitle: String,
                   destructiveHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: destructiveHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction, destructiveAction])
    }
    
    /// Show system action sheet with title, message, button title, other button title.
    func showActionSheet(title: String?,
                         message: String?,
                         buttonTitle: String,
                         buttonHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         otherButtonTitle: String,
                         otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let buttonAction  = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        let otherAction  = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [buttonAction, otherAction, cancelAction])
    }
    
    /// Show system action sheet with title, message, delete button title, other button title.
    func showActionSheet(title: String?,
                         message: String?,
                         deleteButtonTitle: String,
                         deleteHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         otherButtonTitle: String,
                         otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive, handler: deleteHandler)
        let otherAction  = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [otherAction, deleteAction, cancelAction])
    }
    
    /// Show system action sheet with title, message, delete button title.
    func showActionSheet(title: String?,
                         message: String?,
                         deleteButtonTitle: String,
                         deleteHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [deleteAction, cancelAction])
    }
}

