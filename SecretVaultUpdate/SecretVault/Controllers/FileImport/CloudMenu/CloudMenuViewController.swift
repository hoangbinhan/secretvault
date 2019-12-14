//
//  CloudMenuViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/1/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMOAuth2
import OneDriveSDK
import SwiftyDropbox
import AVKit
import AVFoundation
import GoogleMobileAds
import QuickLook
import SSZipArchive
//import UnrarKit

struct arrFileSelected {
    static var indexFile = Array<IndexPath>()
    static var nameFile  = Array<String>()
}

class CloudMenuViewController: BaseViewController, GADBannerViewDelegate {
    
    // MARK:--PROPERTIES--
    @IBOutlet weak var viewMid: UIView!
    @IBOutlet weak var viewBot: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnImport: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet var viewbackCloud: [UIView]!
    @IBOutlet var cloudMenuSelect: [UIView]!
    @IBOutlet var lineViewCloud: [UIView]!
    @IBOutlet var arrConstraint: [NSLayoutConstraint]!
    
    var bannerView: GADBannerView!
    
    fileprivate var isCanPushToViewController   = true
    private let scopes                          = [kGTLRAuthScopeDriveReadonly]
    private let service                         = GTLRDriveService()
    var oldClient: ODClient!
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer : AVPlayer?
    var previewItem = NSURL()

    
    // mang chua ten file
    var arrFileName     = Array<String>()
    
    // mang chua file da chon
    
    // Biến kiểm tra có click vào edit hay không
    var iscarousel : Bool           = true
    var titleNavFolder: String?     = nil
    
    // Button back on navigation bar
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    
    }()
    
    // Button edit on navigation bar
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem       = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    // Set title for button edit on navigation
    var mMode: Mode = .view {
        didSet{
            switch mMode {
            case .view:
                editBarButton.title = "Edit"
            case .edit:
                editBarButton.title = "Done"
            }
        }
    }
    
    // MARK:--VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getListFile()
        setupUITableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: Notification.Name("refreshTableView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeIsPushController), name: NSNotification.Name.isCanPushControolerDropBox, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            if self.isCanPushToViewController && delegate.isLoginedDropboxAccount && delegate.isLoginedDropboxAccountOneTime == true {
                self.checkauthorizedClient()
            }
        }
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.refreshFile, object: nil)
    }
    
    // MARK:--METHODS--
    
    @objc func changeIsPushController() {
        self.isCanPushToViewController = true
    }
    
    func getListFile(){
        if let pathFolder = titleNavFolder {
            let fm = FileManager.default
            let documents = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/\(pathFolder)/", NSHomeDirectory())
            let items = try! fm.contentsOfDirectory(atPath: documents)
            //ko hien thi folder DS_Store
            arrFileName = items.filter(){$0 != ".DS_Store"}
        }
    }
    
    /// Check login Dropbox
    func checkauthorizedClient() {
        if  DropboxClientsManager.authorizedClient != nil {
            let dropboxViewController               = DropboxViewController()
            dropboxViewController.folderName        = titleNavFolder
            dropboxViewController.delegate          = self
            self.navigationController?.pushViewController(dropboxViewController, animated: true)
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        }
    }
    
    func loginOneDrvie() {
        if let client = ODClient.loadCurrent() {
            self.oldClient                      = client
            let oneDriveViewController          = OneDriveViewController()
            oneDriveViewController.folderName   = titleNavFolder
            oneDriveViewController.oldClient    = self.oldClient
            self.navigationController?.pushViewController(oneDriveViewController, animated: true)
        } else {
            ODClient.client { (client, error) in
                guard let valueClient = client else { return }
                ODClient.setCurrent(valueClient)
                valueClient.drive().request().getWithCompletion({ (drive, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.oldClient                      = valueClient
                            let oneDriveViewController          = OneDriveViewController()
                            oneDriveViewController.folderName   = self.titleNavFolder
                            oneDriveViewController.oldClient    = self.oldClient
                            self.navigationController?.pushViewController(oneDriveViewController, animated: true)
                            let name                            = drive?.owner.user.displayName
                            guard UserDefaults.standard.value(forKey: UserDefaultKey.oneDriveAccount) != nil else {
                                UserDefaults.standard.set(name, forKey: UserDefaultKey.oneDriveAccount)
                                return
                            }
                            
                        }
                    }
                })
                
            }
        }
    }
    
    func openURL(urlAddress: String) {
        guard let url = URL(string: urlAddress) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func refresh() {
        getListFile()
        tableView.reloadData()
    }
    
    @objc func didBackButtonChecked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didEditButtonChecked() {
        btnImport.isHidden = !btnImport.isHidden
        mMode = mMode == .view ? .edit : .view
        if mMode == .view {
            setEditing(false, animated: true)
            btnDelete.isHidden = true
            UIView.animate(withDuration: 0.5) {
                if let indexPaths = self.tableView?.indexPathsForVisibleRows{
                    for indexpath in indexPaths
                    {
                        if let Cell = self.tableView.cellForRow(at: indexpath) as? CloudMenuTableViewCell{
                            Cell.transformMoveLeft()
                        }
                    }
                }
            }
        }
        else {
            //done
            setEditing(true, animated: true)
            UIView.animate(withDuration: 0.5) {
                if let indexPaths = self.tableView?.indexPathsForVisibleRows{
                    for indexpath in indexPaths
                    {
                        if let Cell = self.tableView.cellForRow(at: indexpath) as? CloudMenuTableViewCell{
                            Cell.transformMoveRight()
                        }
                    }
                }
            }
            btnDelete.isHidden = false
            btnDelete.isEnabled = false
        }
    }
    
    override func setupViews() {
        super .setupViews()
        setupUIComponent()
        configNavigationBar()
        setupUICloudSelect()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.arrConstraint.forEach{ $0.constant *= Constants.Scale.display }
        
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        btnDelete.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        btnDelete.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil {
            btnDelete.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        } else {
            btnDelete.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
    //
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func configNavigationBar() {
        self.navigationItem.title               = titleNavFolder
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    
    func setupUICloudSelect() {
        viewbackCloud.forEach { (bg) in
            bg.backgroundColor = Color.navBgColor
        }
        lineViewCloud.forEach { (bg) in
            bg.backgroundColor = Color.enableButtonColor
        }
    }

    func setupUIComponent() {
        viewBot.layer.cornerRadius      = viewBot.frame.size.width / 2
        viewBot.backgroundColor         = .clear
        btnImport.backgroundColor       = .clear
        btnImport.layer.cornerRadius    = btnImport.frame.size.width / 2
        btnDelete.backgroundColor       = Color.denableButtonColor
        btnDelete.tintColor             = Color.grayTextColor
        viewMid.backgroundColor         = .black
        viewBot.backgroundColor         = .black
        tableView.backgroundColor       = .black
        btnDelete.isHidden              = true
    }

    func setupUITableView() {
        tableView.dataSource        = self
        tableView.delegate          = self
        let xib                     = UINib.init(nibName: "CloudMenuPart2TableViewCell", bundle: nil)
        tableView.separatorColor    = .clear
        tableView.register(xib, forCellReuseIdentifier: "CloudMenuPart2TableViewCell")
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        arrFileSelected.indexFile.removeAll()
        arrFileSelected.nameFile.removeAll()
    }
    
    @IBAction func cloudImport(_ sender: Any) {
        cloudMenuSelect.forEach { (viewCloud) in
            viewCloud.isHidden = !viewCloud.isHidden
        }
    }
    
    @IBAction func wifitransferButtonPressed(_ sender: Any) {
        let wifitransfer = WifiTransferViewController()
        wifitransfer.folderName = titleNavFolder
        cloudImport(sender)
        navigationController?.pushViewController(wifitransfer, animated: true)
    }
    @IBAction func dropboxButtonPressed(_ sender: Any) {
        cloudImport(sender)
        self.checkauthorizedClient()
    }
    @IBAction func googledriveButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.uiDelegate  = self
        GIDSignIn.sharedInstance()?.delegate    = self
        GIDSignIn.sharedInstance().scopes       = scopes
        GIDSignIn.sharedInstance()?.signIn()
        cloudImport(sender)
    }
    @IBAction func onedriveButtonPressed(_ sender: Any) {
        cloudImport(sender)
        self.loginOneDrvie()
    }
    @IBAction func xButtonPressed(_ sender: Any) {
        cloudImport(sender)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        print(NSHomeDirectory())
        let btnCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let btnOK = UIAlertAction.init(title: "OK", style: .default) { (btnOK) in
            do{
                if let folderName = self.titleNavFolder {
                    for path in arrFileSelected.nameFile {
                        let pathFolder = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/\(folderName)/", NSHomeDirectory()) + path
                        print(pathFolder)
                        try FileManager.default.removeItem(atPath: pathFolder)
                    }
                   
                    self.getListFile()
                    //self.tableView.reloadData()
                    
                    self.tableView.deleteRows(at: arrFileSelected.indexFile, with: .automatic)
                    
                    self.didEditButtonChecked()
                }
            }catch {}
        }
        showAlert(title: "Delete", message: "Do you want to delete this folder", alertActions: [btnOK,btnCancel])
    }
}

extension CloudMenuViewController: DropboxViewControllerDelegate {
    func didLoginSuccessWithAccount(account: String) {
        self.isCanPushToViewController = false
    }
}

extension CloudMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFileName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CloudMenuPart2TableViewCell", for: indexPath) as! CloudMenuPart2TableViewCell
        Cell.configCell(title: arrFileName[indexPath.row], indexpath: indexPath)
        Cell.didTapEditButton = { [weak self] in
            var alertEditFile                       = AlertEditFileViewController()
            alertEditFile.nameFile                  = Cell.lblName.text!
            alertEditFile.modalTransitionStyle      = .crossDissolve
            alertEditFile.modalPresentationStyle    = .overCurrentContext
            alertEditFile.foldername                = self!.titleNavFolder
            self!.present(alertEditFile, animated: true, completion: nil)
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension CloudMenuViewController: UITableViewDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
      return  1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return     self.previewItem as QLPreviewItem

    }
    
    func getPreviewItem(name: String) -> NSURL {
        let file = name.components(separatedBy: ".")
        //let path = Bundle.main.path(forResource: "detai", ofType: "docx")
        let path = Bundle.main.path(forResource: "bansao", ofType: "pdf")
        let url  = NSURL(fileURLWithPath: path!)
        return url
    }
    
    func checkButtonDelete(){
        let countFolder = arrFileSelected.nameFile.count
        if countFolder == 0{
            btnDelete.isEnabled = false
            btnDelete.tintColor = Color.grayTextColor
        }
        else if countFolder >= 1 {
            btnDelete.isEnabled = true
            btnDelete.tintColor = Color.yellowTextColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            if let cell = tableView.cellForRow(at: indexPath) as? CloudMenuPart2TableViewCell{
                if let foldername = titleNavFolder {
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let  filePath = documentsUrl.appendingPathComponent(Constants.DefaultFolder.titleFileImport).appendingPathComponent("\(foldername)").appendingPathComponent("\(cell.lblName.text!)")
                        //-------//
                    let folderPath = documentsUrl.appendingPathComponent(Constants.DefaultFolder.titleFileImport).appendingPathComponent("\(foldername)")
                    let checkfile = FileHelpers.checkExtensionFilesInFolder(fileName: cell.lblName.text!)
                    if checkfile == 1 {
                        let viewImage       = ViewImageViewController()
                        viewImage.imageName = filePath.path
                        navigationController?.pushViewController(viewImage, animated: true)
                    }
                    else if checkfile == 2 {
                        let viewMusic       = ViewMusicViewController()
                        viewMusic.musicName = cell.lblName.text!
                        viewMusic.musicPath = filePath
                        navigationController?.pushViewController(viewMusic, animated: true)
                    }
                    else if checkfile == 3 {
                        let movieURL = NSURL(fileURLWithPath: filePath.path)
                        self.avPlayer = AVPlayer(url: movieURL as URL)
                        self.avPlayerViewController.player = self.avPlayer
                        present(self.avPlayerViewController, animated: true) {
                            self.avPlayerViewController.player?.play()
                        }
                    }
                    else if checkfile == 4 {
                        //Word
                        var quickLookController = QLPreviewController()
                        let url  = NSURL(fileURLWithPath: filePath.path)
                        self.previewItem = url
                        quickLookController.dataSource = self
                        self.present(quickLookController, animated: true)
                    }
                    else if checkfile == 5 {
                        //PDF
                        var quickLookController = QLPreviewController()
                        let url  = NSURL(fileURLWithPath: filePath.path)
                        self.previewItem = url
                        quickLookController.dataSource = self
                        self.present(quickLookController, animated: true)
                    }
                    else if checkfile == 6 {
                        //Compress
                        if let fileCompressExtension = cell.lblName.text?.fileExtension(){
                            if fileCompressExtension.lowercased() == "rar" {
//                                let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//                                let actionDecompress = UIAlertAction(title: "OK", style: .default) { (decompress) in
//                                let rarPath = filePath.path
//                                let unrarPath = folderPath.path
//                                do {
//                                   let fileRar = try URKArchive.init(path: rarPath)
//                                   try fileRar.extractFiles(to: unrarPath, overwrite: true)
//                                    NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil)
//                                   }
//                                   catch {}
//                                }
//                               showAlert(title: "notification", message: "Do you want to decompress this file?", alertActions: [actionCancel, actionDecompress])
                            }
                            else if fileCompressExtension.lowercased() == "zip" {
                                let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                                let actionDecompress = UIAlertAction(title: "OK", style: .default) { (decompress) in
                                    let zipPath = filePath.path
                                    let unzipPath = folderPath.path
                                    SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath)
                                    NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil)
                                }
                                showAlert(title: "notification", message: "Do you want to decompress this file?", alertActions: [actionCancel, actionDecompress])
                            }
                        }
                         


                    }
                }
            }
        case .edit:
            if isEditing {
                if let cell = tableView.cellForRow(at: indexPath) as? CloudMenuPart2TableViewCell {
                    arrFileSelected.nameFile.append(cell.lblName.text!)
                    arrFileSelected.indexFile.append(indexPath)
                }
                checkButtonDelete()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if mMode == .edit && isEditing {
            if let cell = tableView.cellForRow(at: indexPath) as? CloudMenuPart2TableViewCell {
                arrFileSelected.nameFile = arrFileSelected.nameFile.filter{$0 != cell.lblName.text}
                arrFileSelected.indexFile = arrFileSelected.indexFile.filter{$0 != indexPath}
            }
            checkButtonDelete()
        }
    }
}

extension CloudMenuViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.showAlert("Authentication Error", message: error.localizedDescription + "Please try again", cancelButtonTitle: "OK")
            self.service.authorizer = nil
        } else {
            let googleDriveViewController        = GoogleDriveViewController()
            googleDriveViewController.folderName = titleNavFolder
            self.navigationController?.pushViewController(googleDriveViewController, animated: true)
            guard UserDefaults.standard.value(forKey: UserDefaultKey.googleDriveAccount) != nil else {
                UserDefaults.standard.set(user.profile.name, forKey: UserDefaultKey.googleDriveAccount)
                return
            }
        }
    }
}
