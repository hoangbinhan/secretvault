//
//  AlertEditFileViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/10/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class AlertEditFileViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var backgroundView: [UIView]!
    @IBOutlet var lineView: [UIView]!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var btnEditTitle: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var nameFile: String?
    var foldername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(self.dismisController), name: NSNotification.Name.isDissmissAlertEditFile, object: nil)
    }
    
    @objc func dismisController() {
        self.dismiss(animated: true, completion: nil)
    }

    
    func setupUI() {
        lblFileName.text = nameFile
        contentView.layer.cornerRadius = Constants.Radius.viewAlertRadius
        contentView.clipsToBounds = true
        backgroundView.forEach { (view) in
            view.backgroundColor = Color.navBgColor
        }
        lineView.forEach { (view) in
            view.backgroundColor = #colorLiteral(red: 0.1944565177, green: 0.2379434407, blue: 0.3085699081, alpha: 1)
        }
        btnShare.tintColor = .white
        btnCancel.tintColor = .white
        btnEditTitle.tintColor = .white
        lblFileName.textColor = Color.yellowTextColor
    }
    
    @IBAction func edittitleButtonPressed(_ sender: Any) {
        
        if let nameFile = nameFile {
            let alertRenameFile = AlertFileViewController()
            let temp = nameFile.fileName()
            alertRenameFile.modalTransitionStyle = .crossDissolve //hien thi o ngya vi tri ban dau
            alertRenameFile.modalPresentationStyle = .overCurrentContext //background la man hinh 1
            alertRenameFile.TextLable = "Edit Title"
            alertRenameFile.isAdd = 3
            alertRenameFile.currentName = nameFile
             self.contentView.alpha = 0
            alertRenameFile.folderName = foldername
            if let foldername = foldername {
                present(alertRenameFile,animated: true) {}
            }
            //present(alertRenameFile, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        if let foldername = foldername {
            if let filename = nameFile {
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let  filePath = documentsUrl.appendingPathComponent(Constants.DefaultFolder.titleFileImport
                    ).appendingPathComponent("\(foldername)").appendingPathComponent("\(filename)")
                shareFile(link: filePath.path)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AlertEditFileViewController {
    func shareFile(link: String) {
        guard let controller = UIApplication.topViewController() else{return}
        let objectsToShare = [NSURL(fileURLWithPath: link)] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.print,.postToVimeo,.postToWeibo,.addToReadingList,.copyToPasteboard, .postToFacebook,UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),UIActivity.ActivityType(rawValue: "com.viber.app-share-extension"),UIActivity.ActivityType(rawValue: "com.skype.skype.sharingextension"),UIActivity.ActivityType(rawValue: "com.facebook.Messenger.ShareExtension"),UIActivity.ActivityType(rawValue: "com.burbn.instagram.shareextension"),UIActivity.ActivityType(rawValue: "com.google.Gmail.ShareExtension")]
        
        activityVC.popoverPresentationController?.sourceView = controller.view
        self.present(activityVC,animated: true)
    }
}
