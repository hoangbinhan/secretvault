//
//  GoogleDriveViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMOAuth2

protocol GoogeDriveViewControllerDelegate: class {
    func didLoginSuccessfully(email: String)
}

class GoogleDriveViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: --PROPERTIES
    private let scopes = [kGTLRAuthScopeDriveReadonly]
    fileprivate var googleDriveFiles: [GTLRDrive_File] = []
    private let service = GTLRDriveService()
    weak var delegate: GoogeDriveViewControllerDelegate?
    var folderName : String! = nil

    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let basePathGoogleDrive = "https://www.googleapis.com/drive/v3/files/"
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = backBarButton

        setupView()
        setupTableView()
        if let user = GIDSignIn.sharedInstance().currentUser {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            self.listFiles()
        }
        else {
        }
        
        if let email = UserDefaults.standard.value(forKey: UserDefaultKey.googleDriveAccount) as? String {
            lblAccountName.text = email
        }

    }
  
    
    //MARK: --METHODS
    
    @objc func didBackButtonChecked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription + "Please try again")
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            self.listFiles()
            guard UserDefaults.standard.value(forKey: UserDefaultKey.googleDriveAccount) != nil else {
                self.delegate?.didLoginSuccessfully(email: user.profile.familyName)
                UserDefaults.standard.set(user.profile.familyName, forKey: UserDefaultKey.googleDriveAccount)
                return
            }
        }
    }
    
    func setupView(){
        self.title = "Google Drive"
        self.navigationController?.navigationBar.isTranslucent = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let xib = UINib.init(nibName: "GoogleDriveTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "GoogleDriveTableViewCell")
    }
    
    func downloadFile(gtlDriveFile: GTLRDrive_File) {
        if let fileId = gtlDriveFile.identifier {
            self.showLoading()
            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileId)
            service.executeQuery(query) { (ticket, file, error) in
                DispatchQueue.main.async {
                    self.dismissProgress()
                }
                if error == nil {
                    if let fileData = file as? GTLRDataObject, let name = gtlDriveFile.name {
                        let data = fileData.data
                        FileHelpers.writeFile(folderName: self.folderName, fileName: name, with: data)
                        if let path = FileHelpers.getURLFile(folderName: self.folderName, fileName: name)?.absoluteString, let pathExtension = FileHelpers.getURLFile(folderName: self.folderName, fileName: name)?.pathExtension  {
                            let file = FilesModel(path: path, type: pathExtension,  isPlaylist: false, isSelected: false, isFolder: false)
                            DataService.shared.addFile(fileModel: file)
                        }
                    }
                }
            }
        }
    }
    
    func listFiles() {
        self.showLoading()
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1000
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRDrive_FileList,
                                       error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let files = result.files, !files.isEmpty {
            for i in 0 ..< files.count {
                if FileHelpers.checkExtensionFileName(fileName: files[i].name!) {
                 googleDriveFiles.append(files[i])
                }
            }
        }
        self.tableView.reloadData()
        self.dismissProgress()
        
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.showAlertConfirm(title: "Sign Out", message: "Are you sure you want Sign Out of this Google Account?", titleAction: "OK", completion: {
            GIDSignIn.sharedInstance().signOut()
            UserDefaults.standard.removeObject(forKey: UserDefaultKey.googleDriveAccount)
            UserDefaults.standard.synchronize()
            self.navigationController?.popViewController(animated: true)
        }, cancel: nil)

    }
    

}

extension GoogleDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.googleDriveFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "GoogleDriveTableViewCell") as! GoogleDriveTableViewCell
        Cell.textLabel?.textColor = UIColor.black
        Cell.backgroundColor = UIColor.white
        Cell.textLabel?.text = googleDriveFiles[indexPath.row].name
        
        return Cell
    }
}

extension GoogleDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let file = self.googleDriveFiles[indexPath.row]
        if  file.name!.split(separator: ".").count > 1 {
        self.showAlertConfirm(title: nil, message: "Do you want download this file", titleAction: "Download", completion: {
            let file = self.googleDriveFiles[indexPath.row]
            self.downloadFile(gtlDriveFile: file)
            }, cancel: nil)
        }
    }
}
