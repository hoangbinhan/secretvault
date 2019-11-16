//
//  DropboxViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/4/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import SwiftyDropbox


protocol DropboxViewControllerDelegate: class {
    func didLoginSuccessWithAccount(account: String)
}

class DropboxViewController: UIViewController {

    // MARK: --PROPERTIES
    @IBOutlet weak var lblNameAccount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var folderName : String! = nil
    var fileArray: [Files.Metadata] = []
    weak var delegate: DropboxViewControllerDelegate?
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Dropbox"
        setup()
        self.tableView.backgroundColor = UIColor.white
        self.checkauthorizedClient()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = UserDefaults.standard.value(forKey: UserDefaultKey.dropBoxAccount) as? String {
            lblNameAccount.text = email
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.isLoginedDropboxAccountOneTime = false
        }
        NotificationCenter.default.post(name:  NSNotification.Name.isCanPushControolerDropBox, object: nil)
    }
    // MARK: --METHODS
    
    func setup(){
        tableView.dataSource = self
        tableView.delegate = self
        let xib = UINib(nibName: "DropboxTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "DropboxTableViewCell")
    }
    
    @objc func didBackButtonChecked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil)
    }
    
    func checkauthorizedClient() {
        if let client = DropboxClientsManager.authorizedClient {
            self.getListFile()
            guard UserDefaults.standard.value(forKey: UserDefaultKey.dropBoxAccount) != nil else {
                client.users.getCurrentAccount().response(completionHandler: { (user, error) in
                    DispatchQueue.main.async {
                        guard let email = user?.name.displayName else { return }
                        UserDefaults.standard.set(email, forKey: UserDefaultKey.dropBoxAccount)
                        self.delegate?.didLoginSuccessWithAccount(account: email)
                        self.lblNameAccount.text = email
                    }
                })
                return
            }
        }
    }

    func getListFile(path: String = "") {
        self.showLoading()
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: "").response{ response, error in
                if let result = response {
                    for i in 0 ..< result.entries.count {
                        if FileHelpers.checkExtensionFileName(fileName: result.entries[i].name) {
                            self.fileArray.append(result.entries[i])
                        }
                    }
                    //self.fileArray = result.entries
                    self.tableView.reloadData()
                    self.dismissProgress()
                } else {
                    print(error!)
                }
            }
        }
    }
    
    func downloadFile(path: String, name: String, folder: String) {
        if let urlPath = FileHelpers.getURLFile(folderName: folder, fileName: name) {
            self.showLoading()
            let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return urlPath
            }
            if let client = DropboxClientsManager.authorizedClient {
                client.files.download(path: path, destination: destination).response { response, error in
                    DispatchQueue.main.async {
                        self.dismissProgress()
                    }
                }
            }
        }
    }


    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.showAlertConfirm(title: "Sign Out", message: "Are you sure you want Sign Out of this Dropbox Account?", titleAction: "OK", completion: {
            DropboxClientsManager.unlinkClients()
            UserDefaults.standard.removeObject(forKey: UserDefaultKey.dropBoxAccount)
            UserDefaults.standard.synchronize()
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.isLoginedDropboxAccount = false
                delegate.isLoginedDropboxAccountOneTime = false
            }
            self.navigationController?.popViewController(animated: true)
        }, cancel: nil)
    }
    
}

extension DropboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "DropboxTableViewCell", for: indexPath) as! DropboxTableViewCell
        Cell.textLabel?.textColor = UIColor.black
        Cell.backgroundColor = UIColor.white
        Cell.textLabel?.text = fileArray[indexPath.row].name
        
        return Cell
    }
}

extension DropboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let file = self.fileArray[indexPath.row]
        if  file.name.split(separator: ".").count > 1 {
            self.showAlertConfirm(title: nil, message: "Do you want download this file", titleAction: "Download", completion: {
                if let folder = self.folderName {
                    print(folder)
                    self.downloadFile(path: file.pathLower!, name: file.name, folder: folder)
                }
            }, cancel: nil)
        } else {
//            let childViewController = ChildViewController()//.instantiate(storyboard: .main)
//            childViewController.path = file.name
//            childViewController.typeCloud = .dropBox
//            self.navigationController?.pushViewController(childViewController, animated: true)
        }
    }
}
