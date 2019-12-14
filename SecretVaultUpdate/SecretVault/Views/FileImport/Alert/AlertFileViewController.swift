//
//  AlertFileViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class AlertFileViewController: BaseViewController {

    // MARK:--PROPERTIES--
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet var arrConstraint: [NSLayoutConstraint]!
    
    var TextLable : String = " "
    var currentName : String = " "
    var isAdd : Int = 1
    var folderName: String?
    
    //MARK:--VIEWS LIFE CYCLE--
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        txtInput.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name:  NSNotification.Name.CreateAndReNameFolder, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    //MARK:--METHODS--
    
    override func setupConstraints() {
        super.setupConstraints()
        self.arrConstraint.forEach{ $0.constant *= Constants.Scale.display }
    }
    
    func setupView(){
        viewPopup.layer.cornerRadius        = Constants.Radius.viewAlertRadius
        txtInput.layer.cornerRadius         = Constants.Radius.ButtonTextAlertRadius
        btnOK.layer.cornerRadius            = Constants.Radius.ButtonTextAlertRadius
        btnCancel.layer.cornerRadius        = Constants.Radius.ButtonTextAlertRadius
        lblName.text                        = TextLable
        viewPopup.backgroundColor           = Color.navBgColor
        lblName.textColor                   = .white
        btnOK.backgroundColor               = Color.doneButtonColor
        btnOK.layer.borderWidth             = 0.5
        btnOK.layer.borderColor             = Color.yellowButtonColor.cgColor
        btnCancel.layer.borderWidth         = 0.5
        btnCancel.layer.borderColor         = Color.grayTextColor.cgColor
        btnOK.tintColor                     = .white
        btnCancel.tintColor                 = .white

        if isAdd == 2 {
            txtInput.text = currentName
        }
        else if isAdd == 3 {
            txtInput.text = currentName.fileName()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if isAdd == 3 {
            dismiss(animated: true) {
                NotificationCenter.default.post(name:  NSNotification.Name.isDissmissAlertEditFile, object: nil)
            }
        }
        else {
            if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                IntersititialController.sharedInstance.showIntersititial()
            }
        dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if isAdd == 1 {
            
            let foldername      = txtInput.text
            if foldername       != ""
            {
                if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
                    IntersititialController.sharedInstance.showIntersititial()
                }
                createFoler(folderName: foldername!)
                dismiss(animated: true, completion: nil)
            }
            else {
                showAlertWithTitle("Please enter the directory name")
            }
        }
        else if isAdd == 2 {
            
            let foldername = txtInput.text
            if foldername != ""
            {
                renameFolder(currentName: currentName, newName: foldername!)
                NotificationCenter.default.post(name:  NSNotification.Name.isRenameDone, object: nil)
                dismiss(animated: true, completion: nil)
            }
            else {
                showAlertWithTitle("Please enter the directory name")
            }
        }
        else if isAdd == 3 {
           
            let extensionFile   = currentName.fileExtension()
            let nameFile        = currentName.fileName()
            let newName         = txtInput.text
            if newName == "" {
                showAlert(title: "Error", message: "Please type file name!")
            }
            else {
                if let folderName = folderName {
                    renameFile(currentName: currentName, newName: newName! + "." + extensionFile, folder: folderName)
                    dismiss(animated: true) {
                        NotificationCenter.default.post(name:  NSNotification.Name.isDissmissAlertEditFile, object: nil)
                        NotificationCenter.default.post(name:  NSNotification.Name.refreshFile, object: nil)
                    }
                    print(NSHomeDirectory())
                }
            }
        }
    }
    
    func createFoler(folderName : String){
        let documents = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/",NSHomeDirectory())
        let pathFolder = documents + folderName
        debugPrint("path:\(pathFolder)")
        do{
            try FileManager.default.createDirectory(atPath: pathFolder, withIntermediateDirectories: false, attributes: nil)
            print("create Folder OKKKKK")
            
        }catch{
            debugPrint("CANNOT CREATE FOLDER")
        }
    }
    
    func renameFolder(currentName: String, newName:String){
        let documents = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/",NSHomeDirectory())
        let current = documents + currentName
        let new = documents + newName
        do {
            try FileManager.default.moveItem(atPath: current, toPath: new)
        } catch {
            print(error)
        }
    }
    
    func renameFile(currentName: String, newName: String, folder: String){
        let documents = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/\(folder)/",NSHomeDirectory())
        let current = documents + currentName
        let new = documents + newName
        do {
            try FileManager.default.moveItem(atPath: current, toPath: new)
        } catch {
            print(error)
        }
    }
    
    
}
