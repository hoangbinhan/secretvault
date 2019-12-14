//
//  FileScreenViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FileScreenViewController: BaseViewController, GADBannerViewDelegate {

    // MARK:--PROPERTIES--
    @IBOutlet weak var viewTop:         UIView!
    @IBOutlet weak var viewMid:         UIView!
    @IBOutlet weak var viewBot:         UIView!
    @IBOutlet weak var stackView:       UIStackView!
    @IBOutlet weak var collectionView:  UICollectionView!
    @IBOutlet weak var btnPhotoVault:   UIButton!
    @IBOutlet weak var btnFileImport:   UIButton!
    @IBOutlet weak var btnImport:       UIButton!
    @IBOutlet weak var btnRename:       UIButton!
    @IBOutlet weak var btnDelete:       UIButton!
    @IBOutlet var arrConstraint:        [NSLayoutConstraint]!
    
    //banner ads
    var bannerView: GADBannerView!
    
    //mang luu gia tri indexpath khi chon folder de xoa
    var arrSelectedFolder = Array<IndexPath>()
    
    // mang luu gia tri ten cua folder khi chon dung de xoa
    var arrSelectedNameFolder = Array<String>()
    
    //mang luu gia tri indexpath cua collection view hien tai
    var arrCurrentIndexPath = Array<IndexPath>()
    
    var mSizeCell : CGSize = .zero
    
    let spacingCell : CGFloat = 15
    
    //mang chua ten folder
    var arrFolder = Array<String>()
    
    // bien kiem tra co click edit hay ko
    var isSelecting :Bool = false
    
    // Mang chu nhung folder khong can thiet
    let arrFolderWantToRemove = [".DS_Store", "default.realm", "default.realm.lock", "default.realm.management", "default.realm.note"]
    
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
                collectionView.allowsMultipleSelection = false
            case .edit:
                editBarButton.title = "Done"
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    
    // MARK:--VIEWS LIFE CYCLE--
    override func viewDidLoad() {
        super.viewDidLoad()
        showListfolder()
        setupUICollectionView()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.CreateAndReNameFolder, object: nil)
        //--
        NotificationCenter.default.addObserver(self, selector: #selector(self.renameDone), name: NSNotification.Name.isRenameDone, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    func displayBanner() {
                bannerView.adUnitID = StringConstants().Banner_ID
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
    }
    
    
    // MARK:--METHODS--
    @objc func renameDone(){
        showListfolder()
        self.collectionView.reloadData()
        arrSelectedNameFolder.removeAll()
        arrSelectedFolder.removeAll()
        didEditButtonChecked()
        
    }
    
    @objc func refresh() {
        showListfolder()
        self.collectionView.reloadData()
        arrSelectedNameFolder.removeAll()
        arrSelectedFolder.removeAll()
    }
    
    @objc func didBackButtonChecked() {
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    
    @objc func didEditButtonChecked() {
        btnImport.isHidden = !btnImport.isHidden
        mMode = mMode == .view ? .edit : .view
        if mMode == .view {
            btnDelete.isHidden = true
            btnRename.isHidden = true
            isSelecting = false
            arrSelectedFolder.removeAll()
            arrSelectedNameFolder.removeAll()
            //
            if let indexPaths = collectionView?.indexPathsForVisibleItems{
                for indexpath in indexPaths
                {
                    if let Cell = collectionView.cellForItem(at: indexpath) as? FileCollectionViewCell{
                        Cell.setImgCheckHidden()
                    }
                }
            }
        }
        else {
            //done
            btnDelete.isHidden = false
            btnDelete.isEnabled = false
            btnRename.isHidden = false
            btnRename.isEnabled = false
            isSelecting = true
            //
            if let indexPaths = collectionView?.indexPathsForVisibleItems{
                for indexpath in indexPaths
                {
                    if let Cell = collectionView.cellForItem(at: indexpath) as? FileCollectionViewCell{
                        Cell.setImgCheck()
                    }
                }
            }
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        configNavigationBar()
        setupUIComponent()
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.arrConstraint.forEach{ $0.constant *= Constants.Scale.display }
        
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
    //lay ten folder
    func showListfolder() {
        let fm = FileManager.default
        let documents = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/", NSHomeDirectory())
        let items = try! fm.contentsOfDirectory(atPath: documents)
        arrFolder = items
        if arrFolder.count > 0 {
            for i in 0 ..< arrFolderWantToRemove.count {
                arrFolder = arrFolder.filter(){$0 != arrFolderWantToRemove[i]}
            }
        }
        arrFolder = arrFolder.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        let indexPaths = self.collectionView?.indexPathsForVisibleItems
        arrCurrentIndexPath = indexPaths!
        arrCurrentIndexPath.sort()
    }
    
    func configNavigationBar() {
        self.navigationItem.title               = StringConstants.titleNavFile
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    
    func setupUIComponent() {
        viewBot.layer.cornerRadius      = viewBot.frame.size.width / 2
        viewBot.backgroundColor         = .clear
        btnImport.backgroundColor       = .clear
        btnImport.layer.cornerRadius    = btnImport.frame.size.width / 2
        btnPhotoVault.backgroundColor   = Color.denableButtonColor
        btnPhotoVault.tintColor         = Color.grayTextColor
        btnFileImport.backgroundColor   = Color.enableButtonColor
        btnFileImport.tintColor         = Color.yellowTextColor
        btnRename.layer.cornerRadius    = Constants.Radius.defaultButtonRadius
        btnDelete.layer.cornerRadius    = Constants.Radius.defaultButtonRadius
        btnRename.backgroundColor       = Color.denableButtonColor
        btnDelete.backgroundColor       = Color.denableButtonColor
        btnRename.tintColor             = Color.grayTextColor
        btnDelete.tintColor             = Color.grayTextColor
        viewMid.backgroundColor         = .black
        viewBot.backgroundColor         = .black
        collectionView.backgroundColor  = .black
        btnRename.isHidden              = true
        btnDelete.isHidden              = true
    }
    
    func setupUICollectionView() {
        collectionView.dataSource       = self
        collectionView.delegate         = self
        let xib = UINib(nibName: "FileCollectionViewCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: "FileCollectionViewCell")
        
        let remain = UIScreen.main.bounds.size.width - CGFloat(spacingCell*3) - 50
        let wid                         = remain / 3
        let height                      = wid + 15
        mSizeCell = CGSize.init(width: wid, height: height)
    }

    @IBAction func PhotoVaultButtonPressed(_ sender: Any) {
        let categoriesVC = PhotoVaultViewController.loadFromNib()
        let window = AppDelegate.shared.window
        //        window?.rootViewController = categoriesVC
        //        window?.makeKeyAndVisible()
        //        //
        let navController = UINavigationController(rootViewController: categoriesVC)
        //
        navController.navigationBar.isTranslucent       = false
        navController.navigationBar.barTintColor        = Color.navBgColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
        //        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    @IBAction func FileImportButtonPressed(_ sender: Any) {
    }
    
    @IBAction func ImportButtonPressed(_ sender: Any) {
        let alertCreateFolder = AlertFileViewController()
        alertCreateFolder.modalTransitionStyle = .crossDissolve
        alertCreateFolder.modalPresentationStyle = .overCurrentContext
        alertCreateFolder.TextLable = "CREATE NEW FOLDER"
        alertCreateFolder.isAdd = 1
        self.present(alertCreateFolder, animated: true, completion: nil)
    }
    
    @IBAction func RenameButtonPressed(_ sender: Any) {
        let alertRename = AlertFileViewController()
        let temp = arrSelectedNameFolder[0]
        alertRename.modalTransitionStyle = .crossDissolve //hien thi o ngya vi tri ban dau
        alertRename.modalPresentationStyle = .overCurrentContext //background la man hinh 1
        alertRename.TextLable = "Rename"
        alertRename.isAdd = 2
        alertRename.currentName = temp
        //vc.txtInput.text = vc.currentName
        print(temp)
        self.present(alertRename, animated: true, completion: nil)
    }
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {
        
        let btnCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let btnOK = UIAlertAction.init(title: "OK", style: .default) { (btnOK) in
            do{
                for path in self.arrSelectedNameFolder {
                    let pathFolder = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)/", NSHomeDirectory()) + path
                    try FileManager.default.removeItem(atPath: pathFolder)
                }
                //self.collectionView.deleteItems(at: self.arrSelectedFolder)
                print(self.arrSelectedFolder)
                for i in self.arrSelectedFolder.sorted(by: { $0.item > $1.item }) {
                    self.arrFolder.remove(at: i.item)
                }
                
                self.collectionView.deleteItems(at: self.arrSelectedFolder)
                //self.showListfolder()
                self.arrSelectedFolder.removeAll()
                self.arrSelectedNameFolder.removeAll()
                //self.collectionView.reloadData()
                self.didEditButtonChecked()
            }catch {}
        }
        showAlert(title: "Delete", message: "Do you want to delete this folder", alertActions: [btnOK,btnCancel])
    }
}

extension FileScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionViewCell", for: indexPath) as! FileCollectionViewCell
        if mMode == .view {
            Cell.setImgCheckHidden()
        }
        else {
            Cell.setImgCheck()
        }
        Cell.lblNameFolder.text = arrFolder[indexPath.row]
        
        return Cell
    }
}

extension FileScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return mSizeCell
    }
    // spacing 4 edge
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.init(top: 25, left: 25, bottom: 25, right: 25)
        //return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return spacingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return spacingCell
    }
}

extension FileScreenViewController: UICollectionViewDelegate {
    func checkButtonRenameAndDelete(){
        let countFolder = arrSelectedFolder.count
        if countFolder == 0{
            btnDelete.isEnabled = false
            btnRename.isEnabled = false
            btnDelete.tintColor = Color.grayTextColor
            btnRename.tintColor = Color.grayTextColor
        }
        else if countFolder == 1 {
            btnDelete.isEnabled = true
            btnRename.isEnabled = true
            btnDelete.tintColor = Color.yellowTextColor
            btnRename.tintColor = Color.yellowTextColor
        }
        else if countFolder >= 2 {
            btnDelete.isEnabled = true
            btnRename.isEnabled = false
            btnDelete.tintColor = Color.yellowTextColor
            btnRename.tintColor = Color.grayTextColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            let folderScreen = CloudMenuViewController()
            let name = collectionView.cellForItem(at: indexPath) as! FileCollectionViewCell
            folderScreen.titleNavFolder = name.lblNameFolder.text!
            navigationController?.pushViewController(folderScreen, animated: true)
        case .edit:
            if let cell = collectionView.cellForItem(at: indexPath) as? FileCollectionViewCell{
                cell.setImgChecked()
            }
            let name = collectionView.cellForItem(at: indexPath) as! FileCollectionViewCell
            arrSelectedFolder.append(indexPath)
            arrSelectedNameFolder.append(name.lblNameFolder.text!)
            //disable when select multiple item
            checkButtonRenameAndDelete()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .edit {
            if let cell = collectionView.cellForItem(at: indexPath) as? FileCollectionViewCell{
                cell.setImgCheck()
            }
            let name = collectionView.cellForItem(at: indexPath) as! FileCollectionViewCell
            //
            arrSelectedFolder = arrSelectedFolder.filter{$0 != indexPath}
            arrSelectedNameFolder = arrSelectedNameFolder.filter{$0 != name.lblNameFolder.text!}
            //
            checkButtonRenameAndDelete()
        }
    }
}
