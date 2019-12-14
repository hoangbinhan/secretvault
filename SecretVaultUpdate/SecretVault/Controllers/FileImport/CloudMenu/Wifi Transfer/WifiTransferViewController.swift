//
//  WifiTransferViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GCDWebServer
import NetworkExtension
import FGRoute
import GoogleMobileAds


class WifiTransferViewController: UIViewController, GADBannerViewDelegate {
    
    // MARK: --PROPERTIES
    @IBOutlet weak var lblipAdress: UILabel!
    @IBOutlet weak var btnFinish: UIButton!
    var webServer: GCDWebServer!
    var folderName: String?
    
    //bannerview
    var bannerView: GADBannerView!
    
    // Button back on navigation bar
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    // MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        setupView()
        if let ip = FGRoute.getIPAddress(){
            self.lblipAdress.text = "http://\(ip):8080"
        }
        guard let ipAddress = Utils.getWiFiAddress() else { return }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createWebServer()
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    //
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // MARK: --METHODS
    
    
    @objc func didBackButtonChecked() {
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
        NotificationCenter.default.post(name:  NSNotification.Name.refreshFile, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        self.view.backgroundColor       = .black
        btnFinish.layer.cornerRadius    = Constants.Radius.defaultButtonRadius
        btnFinish.tintColor             = Color.yellowTextColor
        btnFinish.backgroundColor       = Color.denableButtonColor
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    func configNavigationBar() {
        self.navigationItem.title               = "Wifi Transfer"
        self.navigationItem.leftBarButtonItem   = backBarButton
    }
    
    func createWebServer() {
        if let pathFolderName = folderName {
            self.webServer = GCDWebServer()
            //        let bgPath = Bundle.main.path(forResource: "Webs", ofType: nil)
            //        self.webServer.addGETHandler(forBasePath: "/", directoryPath: bgPath!, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
            
            self.webServer.addHandler(forMethod: "GET", path: "/", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
                guard let items = FileHelpers.listFilesFromDocumentsFolder(foldername: self.folderName, name: nil) else {return GCDWebServerDataResponse(html:"")}
                let htmlString = Utils.initHTMLTemplate(fileNames: items)
                return GCDWebServerDataResponse(html: htmlString)
            }
            
            self.webServer.addHandler(forMethod: "POST", path: "/", request: GCDWebServerMultiPartFormRequest.self) { (request) -> GCDWebServerResponse? in
                let get = request as! GCDWebServerMultiPartFormRequest
                do {
                    let files = get.files
                    let fileManager = FileManager.default
                    try files.forEach({ (file) in
                        if let multipartFile = file as? GCDWebServerMultiPartFile, let urlOfFile = FileHelpers.getURLFile(folderName: pathFolderName, fileName: multipartFile.fileName) {
                            try fileManager.moveItem(at: URL(fileURLWithPath: multipartFile.temporaryPath), to: urlOfFile)
                            print("URL of file: \(urlOfFile)")
                        }
                    })
                } catch {
                    print(error.localizedDescription)
                }
                
                guard let items = FileHelpers.listFilesFromDocumentsFolder(foldername: self.folderName, name: nil) else {
                    return GCDWebServerDataResponse(html:"") }
                let htmlString = Utils.initHTMLTemplate(fileNames: items)
                return GCDWebServerDataResponse(html: htmlString)
            }
            
            self.webServer.addHandler(forMethod: "GET", path: "/deleted", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
                if let query = request.query, let fileName = query["file"] as? String {
                    if let urlOfFile = FileHelpers.getURLFile(folderName: pathFolderName, fileName: fileName) {
                        do {
                            try FileManager.default.removeItem(atPath: urlOfFile.path)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
                guard let items = FileHelpers.listFilesFromDocumentsFolder(foldername: pathFolderName, name: nil) else {
                    return GCDWebServerDataResponse(html:"") }
                let htmlString = Utils.initHTMLTemplate(fileNames: items)
                return GCDWebServerDataResponse(html: htmlString)
            }
            self.webServer.start(withPort: 8080, bonjourName: nil)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
        self.webServer.stop()
        NotificationCenter.default.post(name:  NSNotification.Name.refreshFile, object: nil)
        navigationController?.popViewController(animated: true)
    }
    

}
