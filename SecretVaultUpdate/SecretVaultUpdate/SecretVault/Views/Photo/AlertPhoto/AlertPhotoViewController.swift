//
//  AlertPhotoViewController.swift
//  SecretVault
//
//  Created by User01 on 9/3/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class AlertPhotoViewController: BaseViewController {

    // MARK: PROPERTIES
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    
    var TextLabel: String = " "
    var currentName: String = " "
    var isAdd: Bool = true
    
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name.CreateAndRenameAlbum, object: nil)
    }
    
    // update new
   
    // setupConstraints
    

    // MARK: METHODS
    func setupView()
    {
        viewPopup.layer.cornerRadius    = Constants.Radius.viewAlertRadius
        txtInput.layer.cornerRadius     = Constants.Radius.ButtonTextAlertRadius
        txtInput.becomeFirstResponder()
      //  Type a messag
        btnDone.layer.cornerRadius      = Constants.Radius.ButtonTextAlertRadius
        btnCancel.layer.cornerRadius    = Constants.Radius.ButtonTextAlertRadius
        lblName.text                    = TextLabel
        viewPopup.backgroundColor       = Color.alertbgColor
        lblName.textColor               = .white
        btnDone.backgroundColor         = Color.doneButtonColor
        btnDone.layer.borderWidth       = 0.5
        btnDone.layer.borderColor       = Color.yellowButtonColor.cgColor
        btnCancel.layer.borderWidth     = 0.5
        btnCancel.layer.borderColor     = Color.grayTextColor.cgColor
        btnDone.tintColor               = .white
        btnCancel.tintColor             = .white
        
        if !isAdd
        {
            txtInput.text = currentName
        }
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        if count != 1 {
            if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                IntersititialController.sharedInstance.showIntersititial()
            }
        }
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name:  NSNotification.Name.isDissmissAlertEditAlbum, object: nil)

    }
    @IBAction func btnDone(_ sender: Any) {
        if isAdd {
            
            let albumname    = txtInput.text
            if albumname  != ""
            {
                if count != 1 {
                    if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                        IntersititialController.sharedInstance.showIntersititial()
                    }
                }
                createAlbum(folderName: albumname!)
                
                dismiss(animated: true, completion: nil)
                //update new
                NotificationCenter.default.post(name:  NSNotification.Name.isAddNumberPhoto, object: nil)
            }
            else {
                showAlertWithTitle("Please enter the directory name")
            }
        }
        else {
            let foldername = txtInput.text
            if foldername != ""
            {
                if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                    IntersititialController.sharedInstance.showIntersititial()
                }
                renameAlbum(curentName: currentName, newName: foldername!)
                dismiss(animated: true, completion: nil)
                //update new
                NotificationCenter.default.post(name:  NSNotification.Name.isRenamePhotoDone, object: nil)
            }
            else {
                showAlertWithTitle("Please enter the directory name")
            }
        }
        
    }
    
    
    // Create Album
    func createAlbum(folderName:String)
    {
        let documents = String.init(format: "%@/Documents/", NSHomeDirectory())
        let pathFolder = documents + folderName
        
        do{
            try FileManager.default.createDirectory(atPath: pathFolder, withIntermediateDirectories: true, attributes: nil)
            print("create album ok")
        }catch{
            debugPrint("Cannot create folder")
        }
    }
    
    // RenameAlbum
    func renameAlbum(curentName:String, newName:String)
    {
        let documents = String.init(format: "%@/Documents/", NSHomeDirectory())
        let current = documents + curentName
        let new = documents + newName
        do{
            try FileManager.default.moveItem(atPath: current, toPath: new)
        }catch{
            print(error)
        }
    }

    

}
