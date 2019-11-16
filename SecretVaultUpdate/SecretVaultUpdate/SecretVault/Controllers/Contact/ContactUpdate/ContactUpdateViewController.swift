//
//  ContactUpdateViewController.swift
//  SecretVault
//
//  Created by Đặng Ngọc Đại on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView


class ContactUpdateViewController: BaseViewController {
    
    //MARK: ---PROPERTIES---
    
    //@IBOutlet weak var imghinh: UIImageView!
    @IBOutlet weak var Firstname: UITextField!
    @IBOutlet weak var Lastname : UITextField!
    @IBOutlet weak var Company  : UITextField!
    @IBOutlet weak var Mobie    : UITextField!
    @IBOutlet weak var Home     : UITextField!
    @IBOutlet weak var Work     : UITextField!
    @IBOutlet weak var Email    : UITextField!
    @IBOutlet weak var URL      : UITextField!
    @IBOutlet weak var Note     : UITextView!
    @IBOutlet weak var imghinh  : UIButton!
    @IBOutlet weak var mView    : UIView!
    var arrImage = Array<ContactImageModels1>()
    var titleNavAlbum: String?

    var testttt: UIImage!

    
     var hinh : UIImage?
    var isLoading = false
    // Default in extra mode
    var isEditmode : Bool = false
    // Add variables containing references to the current object if in mode
    var currentDanhba:Danhba2!
    // Initialize an array to hold images
    var PhotoArray = [UIImage]()
   
    
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
        self.navigationItem.title               = StringConstants.titleNavNewContact
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        AddData()
        CondariusImage()
       

       // registerNotification()
        self.HideKeyBoard1()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("will appear")
        
        if isLoading == true {
            imghinh.setImage(hinh, for: .normal)
            let db = Danhba2()
            db.mnhinh = hinh?.toString()
            isLoading = false
        }
    }
    
    
    
    func CondariusImage() {
        imghinh.layer.cornerRadius = imghinh.frame.size.width/2
        self.view.frame.origin.y  += 150
        mView.backgroundColor      = Color.denableButtonColor
    }
    @IBAction func AddImage(_ sender: Any) {
        let sb = ContactPhotoLibaryViewController()
        let index = navigationController?.viewControllers.firstIndex(of: self)
        sb.indexViewController = index
        self.navigationController?.pushViewController(sb, animated: true)
         showLoadinga()
    }
    @objc func didBackButtonChecked() {
        if isEditmode == false {
            if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                IntersititialController.sharedInstance.showIntersititial()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func showLoadinga() {
        let activityData = ActivityData(type: .ballClipRotate)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    @objc func didEditButtonChecked() {
        let imgHinh   = imghinh.imageView?.image
        let firstname = Firstname.text
        let lastname  = Lastname.text
        let company   = Company.text
        let mobie     = Mobie.text
        let home      = Home.text
        let work      = Work.text
        let email     = Email.text
        let url       = URL.text
        let note      = Note.text
        if  firstname!.isEmpty || ((firstname?.trimmingCharacters(in: .whitespaces)) == nil) || lastname!.isEmpty || mobie!.isEmpty {
            let myAlert : UIAlertController = UIAlertController(title: "Notification!!", message: "You have not entered yet Firstname, Lastname and Mobile", preferredStyle: UIAlertController.Style.alert)
            let btnOK : UIAlertAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(btnOK)
            present(myAlert, animated: true, completion: nil)
        }
        else
        {
            let danhba = Danhba2()
          
            danhba.mHinh    = imgHinh?.toString()
            danhba.mName    = firstname! + " " + lastname!
            danhba.mFirst   = firstname
            danhba.mLast    = lastname
            danhba.mCompany = company!
            danhba.mMobile  = mobie!
            danhba.mHome    = home!
            danhba.mWork    = work!
            danhba.mEmail   = email!
            danhba.mURL     = url!
            danhba.mNote    = note!
            danhba.mnhinh   = imgHinh?.toString()
            
            if isEditmode == true
            {
                danhba.ID = currentDanhba.ID
               // debugPrint(currentDanhba.ID)
                DBBDanhba.Instance.updateToDB(object: danhba)
                //send notification
                NotificationCenter.default.post(name: NSNotification.Name.Contact, object: "Hello I'm B", userInfo: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
            else { // thêm
                if UserDefaults.standard.value(forKey: "nextSecond") == nil {
                    debugPrint("not yet")
                    UserDefaults.standard.set(true, forKey: "nextSecond")
                } else {
                    debugPrint("yet")
                    if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                        IntersititialController.sharedInstance.showIntersititial()
                    }
                    UserDefaults.standard.removeObject(forKey: "nextSecond")
                }
                DBBDanhba.Instance.insertOneSanPham(object: danhba)
                //send notification
                NotificationCenter.default.post(name: NSNotification.Name.Contact, object: "Hello I'm B", userInfo: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        imghinh.layer.cornerRadius = (imghinh.frame.size.width) / 2
        imghinh.clipsToBounds = true
        
        Note.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        if Note.text.isEmpty {
            Note.text = "Note"
            Note.textColor = .black
        }
    }
    func AddData()
    {
        if (isEditmode == true)
        {
            if let img = currentDanhba.mHinh
            {
                imghinh.setImage(img.toImage(), for: .normal)
            }
            Firstname.text = currentDanhba.mFirst
            Lastname.text  = currentDanhba.mLast
            Company.text   = currentDanhba.mCompany
            Mobie.text     = currentDanhba.mMobile
            Home.text      = currentDanhba.mHome
            Work.text      = currentDanhba.mWork
            Email.text     = currentDanhba.mEmail
            URL.text       = currentDanhba.mURL
            Note.text      = currentDanhba.mNote
        }
    }
}
// Function to hide keyboard
extension UIViewController {
    func HideKeyBoard1() {
        let tAp : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DissmissKeyBoard))
        view.addGestureRecognizer(tAp)
        self.view.frame.origin.y -= 150
    }
    @objc func DissmissKeyBoard1(){
        view.endEditing(true)
    }
}
extension ContactUpdateViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textField
            {
                if (string == "\n")
                {
                    textField.text = textField.text! + "\n"
                    //textView.resignFirstResponder()

                 }

             }
        return true
    }
}
