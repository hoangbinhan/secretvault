//
//  ChangePasswordKeeperViewController.swift
//  SecretVault
//
//  Created by 5K on 9/9/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ChangePasswordKeeperViewController: BaseViewController {
    
    @IBOutlet weak var mTopView: UIView!
    @IBOutlet weak var mMidView: UIView!
    @IBOutlet weak var mBotView: UIView!
    @IBOutlet weak var mName    : UITextField!
    @IBOutlet weak var mUserName: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var mWeb     : UITextField!
    @IBOutlet weak var mNote: UITextView!
    
    
    // Mặc định ở chế độ thêm
    var isEditmode : Bool = false
    // Thêm biến chứa tham chiếu tới đối tượng hiện tại nếu ở chế độ
    var currentPassword: PasswordKeeper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        self.HideKeyBoard()
        // Do any additional setup after loading the view.
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        mUserName.translatesAutoresizingMaskIntoConstraints = false
        mUserName.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 163/375).isActive = true
    }
    
    override func setupViews() {
        super.setupViews()
        
        mTopView.backgroundColor = Color.navBgColor
        mMidView.backgroundColor = Color.navBgColor
        mBotView.backgroundColor = Color.navBgColor
        
        mNote.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        if mNote.text.isEmpty {
            mNote.text = "Note"
            mNote.textColor = .black
        }
    }
    
    override func setupData() {
        super.setupData()
        
        if (isEditmode == true)
        {
            mName.text      = currentPassword.mName
            mUserName.text  = currentPassword.mUserName
            mPassword.text  = currentPassword.mPassword
            mWeb.text       = currentPassword.mWebsite
            mNote.text      = currentPassword.mNote
        }
    }
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    func configNavigationBar() {
        if isEditmode == false{
            self.navigationItem.title = StringConstants.titleNavNewLogin
        } else {
            self.navigationItem.title = StringConstants.titleNavEditLogin
        }
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    
    @objc func didBackButtonChecked() {
        if isEditmode == false {
            if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                IntersititialController.sharedInstance.showIntersititial()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didEditButtonChecked() {
        
        let name     = mName.text
        let username = mUserName.text
        let password = mPassword.text
        let web      = mWeb.text
        let note     = mNote.text
        if  name!.isEmpty || username!.isEmpty || password!.isEmpty  {
            let myAlert : UIAlertController = UIAlertController(title: "Notification!!", message: "You have not entered yet Title, Username and Password", preferredStyle: UIAlertController.Style.alert)
            let btnOK : UIAlertAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(btnOK)
            present(myAlert, animated: true, completion: nil)
        }
        else
        {
            let pass = PasswordKeeper()
            
            pass.mName     = name!
            pass.mUserName = username!
            pass.mPassword = password!
            pass.mWebsite  = web
            pass.mNote     = note!
            
            if isEditmode == true
            {
                pass.ID = currentPassword.ID
                DBPassword.Instance.updateToDB(object: pass)
                
                let updateScreen = PasswordKeeperViewController()
//                //send notification
                NotificationCenter.default.post(name: NSNotification.Name.Password, object: "Hello I'm B", userInfo: nil)
                self.navigationController?.pushViewController(updateScreen, animated: true)
            }
            else{ // thêm
                if UserDefaults.standard.value(forKey: "nextSecondP") == nil {
                    debugPrint("not yet")
                    UserDefaults.standard.set(true, forKey: "nextSecondP")
                } else {
                    debugPrint("yet")
                    if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                        IntersititialController.sharedInstance.showIntersititial()
                    }
                    UserDefaults.standard.removeObject(forKey: "nextSecondP")
                }
                
                DBPassword.Instance.insertOnePassword(object: pass)
                //send notification
                NotificationCenter.default.post(name: NSNotification.Name.Password, object: "Hello I'm B", userInfo: nil)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//// Hàm ẩn keyboard
//extension UIViewController {
//    func HideKeyBoard(){
//        let tAp : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DissmissKeyBoard))
//        view.addGestureRecognizer(tAp)
//        self.view.frame.origin.y -= 150
//    }
//    @objc func DissmissKeyBoard(){
//        view.endEditing(true)
//        //self.view.frame.origin.y += 150
//
//    }
//}
