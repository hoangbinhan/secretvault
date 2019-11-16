//
//  OneDriveViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/7/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import OneDriveSDK
import Alamofire

protocol OneDriveViewControllerDelegate: class {
    func didLoginSuccess(email: String)
}

class OneDriveViewController: UIViewController {

    //MARK: --PROPERTIES
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAccountName: UILabel!
    var oldClient: ODClient!
    var files: [OneDriveFile] = []
    weak var delegate: OneDriveViewControllerDelegate?
    var folderName : String? = nil

    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton     = true
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.title               = "One Drive"
        setup()
        getAllFiles()
        
        if let email = UserDefaults.standard.value(forKey: UserDefaultKey.oneDriveAccount) as? String {
            lblAccountName.text = email
        }

    }
    
    //MARK: --METHODS
    
    @objc func didBackButtonChecked() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil)
    }
    
    func setup(){
        tableView.dataSource = self
        tableView.delegate = self
        let xib = UINib.init(nibName: "OneDriveTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "OneDriveTableViewCell")
    }
    
    func getAllFiles() {
        guard let client = self.oldClient else { return }
        self.showLoading()
        client.drive().items("root").children().request().getWithCompletion { [weak self](collection, request, error) in
            guard let data = collection?.additionalData, let values = data["value"] as? [[String: Any]] else { return }
            for item in values {
                if let id = item["id"] as? String, let name = item["name"] as? String {
                    if FileHelpers.checkExtensionFileName(fileName: name)
                    {
                        let file = OneDriveFile(id: id, name: name)
                        self?.files.append(file)
                    }
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.dismissProgress()
            }
        }
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        self.showAlertConfirm(title: "Sign Out", message: "Are you sure you want Sign Out of this OneDrive Account?", titleAction: "OK", completion: {
            ODClient.loadCurrent()?.signOut(completion: { (error) in
                DispatchQueue.main.async {
                    self.dismissProgress()
                    if error == nil {
                        UserDefaults.standard.removeObject(forKey: UserDefaultKey.oneDriveAccount)
                        UserDefaults.standard.synchronize()
                    }
                }
            })
            self.navigationController?.popViewController(animated: true)
        }, cancel: nil)
        
     
    }
}

extension OneDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneDriveTableViewCell", for: indexPath) as! OneDriveTableViewCell
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = Color.color(hexString: "f4f4f5")
        cell.textLabel?.text = self.files[indexPath.row].name
        return cell
    }
}

extension OneDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let id = self.files[indexPath.row].id else { return }
        if  self.files[indexPath.row].name.split(separator: ".").count == 1 {
//            let childViewController = ChildViewController()//.instantiate(storyboard: .main)
//            childViewController.path = self.files[indexPath.row].name
//            childViewController.id = self.files[indexPath.row].id
//            childViewController.typeCloud = .oneDrive
//            self.navigationController?.pushViewController(childViewController, animated: true)
        } else {
            if let pathFolder = folderName {
                self.showAlertConfirm(title: nil, message: "Do you want save file this?", titleAction: "OK", completion: {
                    self.showLoading()
                    self.oldClient.drive().items().item("\(id)").contentRequest().download { (url, response, error) in
                        if let urlDownload = response?.url  {
                            DownloadManager.shared.downloadFile(folderName: pathFolder ,url: urlDownload, completion: { [weak self] (_) in
                                DispatchQueue.main.async {
                                    self?.dismissProgress()
                                }
                            })
                        }
                        
                    }
                }, cancel: nil)
            }
          
        }
    }
}
