//
//  PhotoAlbumViewController.swift
//  SecretVault
//
//  Created by User01 on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import Photos
import NVActivityIndicatorView
import GoogleMobileAds

class PhotoAlbumViewController: BaseViewController, GADBannerViewDelegate {

    @IBOutlet weak var mColectionView: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRecover: UIButton!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblRecover: UILabel!
    @IBOutlet weak var lblMove: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var uiViewToolBar: UIView!
    @IBOutlet weak var uiViewBtnRecover: UIView!
    @IBOutlet weak var uiViewBtnMove: UIView!
    @IBOutlet weak var uiViewBtnDelete: UIView!
    
    //bannerview
    var bannerView: GADBannerView!
    
    var titleNavAlbum: String?
    var mSizeCell: CGSize = .zero
    let spacingCell : CGFloat = 1
    var arrImage = Array<String>()
   // var arrImagePHAset = Array<PHAsset>()
    var isSelect:Bool = true // mặc định là khi bấm vào edit
    var isMoved = false
    var arrImageToLibrary = Array<UIImage>()
    var arrSelectNameImageAlbum = Array<Int>()
   // var pathtoancuc:URL?
    var arrNameImageAlbum = Array<UIImage>()
  //  var arrSelectedNameImage = Array<String>()
    var arrIndexPath = Array<URL>() // mảng lưu đường dẫn
    var arrMoveIndex = Array<URL>()
   // var arrCurrentIndexPath = Array<IndexPath>()
    var countIndex:Int = 0
    var mModeAlbumPhoto: ModePhotoAlbum  = .view {
        didSet {
            switch mModeAlbumPhoto {
            case .view:
                
                navigationItem.rightBarButtonItem = editBarButton
                navigationItem.leftBarButtonItem  = backBarButton
                setupUIComponent()
                uiViewToolBar.isHidden = true
                btnAdd.isHidden = false
                
                
                if let indexPaths = mColectionView?.indexPathsForVisibleItems {
                    for indexpath in indexPaths {
                        if let cell = mColectionView.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                            cell.setImgCheckHidden()
                        }
                    }
                }
                mColectionView.allowsMultipleSelection = false
              //  mColectionView.allowsMultipleSelection = false
            case .edit:
                uiViewToolBar.isHidden = false
                mColectionView.allowsMultipleSelection = true
                navigationItem.rightBarButtonItem = selectBarButton
                navigationItem.leftBarButtonItem = cancelBarButton
              //  mColectionView.allowsMultipleSelection = true
            case .selectall:
                navigationItem.rightBarButtonItem = deselectBarButton
               // mColectionView.allowsMultipleSelection = false
            }
        }
    }
    lazy var cancelBarButton:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    lazy var selectBarButton:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select all", style: .plain, target: self, action: #selector(didSelectAllButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    lazy var deselectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Deselect all", style: .plain, target: self, action: #selector(didDeselectAllButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: Constants.ImagePhotoVault.defaultBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
       return barButtonItem
    }()
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupViews() {
        super.setupViews()
        setupUIComponent()
        configNavigationBar()
        setupUICollectionView()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        uiViewToolBar.translatesAutoresizingMaskIntoConstraints = false
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            uiViewToolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
            uiViewToolBar.heightAnchor.constraint(equalToConstant: 78).isActive = true
            uiViewToolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            uiViewToolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        } else {
            uiViewToolBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            uiViewToolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            uiViewToolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            uiViewToolBar.topAnchor.constraint(equalTo: self.btnAdd.bottomAnchor).isActive = true
        }
        
        uiViewBtnRecover.leadingAnchor.constraint(equalTo: self.uiViewToolBar.leadingAnchor, constant: 40).isActive = true
        uiViewBtnRecover.centerYAnchor.constraint(equalTo: self.uiViewToolBar.centerYAnchor).isActive = true
        uiViewBtnMove.centerYAnchor.constraint(equalTo: self.uiViewBtnRecover.centerYAnchor).isActive = true
        uiViewBtnDelete.centerYAnchor.constraint(equalTo: self.uiViewBtnRecover.centerYAnchor).isActive = true
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        arrIndexPath.removeAll()
        ReadFile()
        mColectionView.reloadData()
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }

        uiViewToolBar.isHidden = true
        
    }
    func ReadFile() {
        if let path = titleNavAlbum {
            arrImage.removeAll()
            let fm = FileManager.default
            let documents = String.init(format: "%@/Documents/\(path)", NSHomeDirectory())
            let items = try! fm.contentsOfDirectory(atPath: documents)
            let temp = items.filter(){$0 != ".DS_Store"}
            //items.filter(){$0 != ".DS_Store"}
            for i in 0..<temp.count {
              // if let data =
              arrImage.append(temp[i])
            }
            arrImage = arrImage.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        }
    }
  

    func getDocumentsDicretory() -> URL {
        let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func setupUIComponent() {
        mColectionView.backgroundColor = .black
        self.uiViewToolBar.backgroundColor = .black
        self.btnRecover.isHidden = true
        self.lblRecover.isHidden = true
        self.btnMove.isHidden = true
        self.lblMove.isHidden = true
        self.btnDelete.isHidden = true
        self.lblDelete.isHidden = true
        self.uiViewBtnRecover.backgroundColor = .black
        self.uiViewBtnMove.backgroundColor = .black
        self.uiViewBtnDelete.backgroundColor = .black
//        pathtoancuc = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!)
//        print("path toan cuc \(pathtoancuc!)")
    }
    func configNavigationBar() {
        self.navigationItem.title  = titleNavAlbum
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = editBarButton
    }
    func setupUICollectionView() {
        mColectionView.dataSource = self
        mColectionView.delegate = self
        let xib = UINib(nibName: "PhotoAlbumCollectionViewCell", bundle: nil)
        mColectionView.register(xib, forCellWithReuseIdentifier: "PhotoAlbumCollectionViewCell")
        let remain = UIScreen.main.bounds.size.width - CGFloat(spacingCell*3)
        let wid = remain / 4
        let height = wid
        mSizeCell = CGSize.init(width: wid, height: height)
    }
    func setUpToolBarisHidden() {
        self.uiViewToolBar.backgroundColor = Color.navBgColor
        self.btnRecover.isHidden = false
        self.lblRecover.isHidden = false
        self.btnMove.isHidden = false
        self.lblMove.isHidden = false
        self.btnDelete.isHidden = false
        self.lblDelete.isHidden = false
        self.uiViewBtnRecover.backgroundColor = .clear
        self.uiViewBtnMove.backgroundColor = .clear
        self.uiViewBtnDelete.backgroundColor = .clear
    }
    @objc func didCancelButtonChecked() {
        mModeAlbumPhoto = .view
        uiViewToolBar.isHidden = true
        setupUIComponent()
        //configNavigationBar()
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = editBarButton
        btnAdd.isHidden = false
        if let indexPaths = mColectionView?.indexPathsForVisibleItems {
            for indexpath in indexPaths {
                if let cell = mColectionView.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                    cell.setImgCheckHidden()
                }
            }
        }
    }

    @objc func didBackButtonChecked() {
        if isMoved == false {
        navigationController?.popViewController(animated: true)
        } else{
            
//            let mhphotovaultscreen = PhotoVaultViewController()
            navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
        
    }
    @objc func didEditButtonChecked() {

        
            if mModeAlbumPhoto == .view {
                mModeAlbumPhoto = .edit
                uiViewToolBar.isHidden = false
                
            }
            else if mModeAlbumPhoto == .edit
            {
                mModeAlbumPhoto = .selectall
            }
            else {
                mModeAlbumPhoto = .view
            }
            if mModeAlbumPhoto == .view {
             //   print("concat")
                if let indexPaths = mColectionView?.indexPathsForVisibleItems {
                    for indexpath in indexPaths {
                        if let cell = mColectionView?.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                            cell.setImgCheckHidden()
                        }
                    }
                }
                
            } else if mModeAlbumPhoto == .edit {
              
                btnAdd.isHidden = true
                setUpToolBarisHidden()
                if let indexPaths = mColectionView?.indexPathsForVisibleItems {
                    for indexpath in indexPaths {
                        if let cell = mColectionView.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                            cell.setImgCheck()
                        }
                    }
                }
                
            } else {
                //print("du ma")
            }
        
        
        
    }
    @objc func didSelectAllButtonChecked() {
        if mModeAlbumPhoto == .view {
            mModeAlbumPhoto = .edit
            uiViewToolBar.isHidden = false
        }
        else if mModeAlbumPhoto == .edit
        {
            mModeAlbumPhoto = .selectall
        }
        else {
            mModeAlbumPhoto = .view
        }
        if let indexPaths = mColectionView?.indexPathsForVisibleItems {
            arrImageToLibrary.removeAll()
            for indexpath in indexPaths {
                if let cell = mColectionView.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                    cell.setImgChecked()
                    let imageoop = arrImage[indexpath.row]
                    let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
                    arrImageToLibrary.append(UIImage(contentsOfFile: path.path)!)
                    
                }
            }
        }
        
    }
    @objc func didDeselectAllButtonChecked() {
        if mModeAlbumPhoto == .view {
            mModeAlbumPhoto = .edit
            
        }
        else if mModeAlbumPhoto == .edit
        {
            mModeAlbumPhoto = .selectall
        }
        else if mModeAlbumPhoto == .selectall {
            mModeAlbumPhoto = .edit
        }
        
            navigationItem.rightBarButtonItem = selectBarButton
            // didSelectAllButtonChecked()
            if let indexPaths = mColectionView?.indexPathsForVisibleItems {
                arrImageToLibrary.removeAll()
                for indexpath in indexPaths {
                    if let cell = mColectionView.cellForItem(at: indexpath) as? PhotoAlbumCollectionViewCell {
                        cell.setImgCheck()
                        let imageoop = arrImage[indexpath.row]
                        let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
                        arrImageToLibrary.append(UIImage(contentsOfFile: path.path)!)
                    }
                }
            }
        
}
    func showspinner() {
        let activityData = ActivityData(type: .ballClipRotate)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let photolibaryscreen = PhotoLibaryViewController()
        photolibaryscreen.folderName = titleNavAlbum
      //  photolibaryscreen.pathsaveImage = try! String.init(contentsOf: pathtoancuc!)
        self.showspinner()
        self.navigationController?.pushViewController(photolibaryscreen, animated: true)
    }
    
    @IBAction func btnRecover(_ sender: Any) {
        if mModeAlbumPhoto == .selectall || mModeAlbumPhoto == .edit {
            // Thông báo
            let alert = UIAlertController(title: "This item will be moved to Camera Roll. Are you sure?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let btnMove: UIAlertAction = UIAlertAction(title: "Move to Camera Roll", style: UIAlertAction.Style.destructive) { (alertaction) in
                // Code bên trong
                self.saveImageToLibrary()
                self.arrSelectNameImageAlbum.removeAll()
                self.arrMoveIndex.removeAll()
                let alertthongbao = UIAlertController(title: "Notification", message: "Move to camera roll successfully!!\n Open libary to check", preferredStyle: UIAlertController.Style.alert)
                let actionthongbao = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil)
                alertthongbao.addAction(actionthongbao)
                self.present(alertthongbao, animated: true
                    , completion: nil)
                self.mModeAlbumPhoto = .view
            }
            let btnCancel: UIAlertAction = UIAlertAction(title: "Cancel ", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(btnMove)
            alert.addAction(btnCancel)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnMove(_ sender: Any) {
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
        if mModeAlbumPhoto == .selectall {
            let mhmovephoto = PhotoMoveAlbumViewController()
            mhmovephoto.arrPhotoMoveURL = arrIndexPath
            mhmovephoto.isMoveSingle = false
            self.navigationController?.pushViewController(mhmovephoto, animated: true)
        } else if mModeAlbumPhoto == .edit {
            if arrSelectNameImageAlbum.count == 0 {
                let alert = UIAlertController(title: "Notification", message: "No images have been selected. Can not delete !!!", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let mhmovephoto = PhotoMoveAlbumViewController()
                mhmovephoto.arrPhotoMoveURL = arrMoveIndex
                mhmovephoto.isMoveSingle = false
                self.arrSelectNameImageAlbum.removeAll()
                self.arrMoveIndex.removeAll()
                self.arrImageToLibrary.removeAll()
                self.navigationController?.pushViewController(mhmovephoto, animated: true)
            }
        }
    }
    func RemoveAlbum(nameFolder:URL)
    {
        
        do{
            try FileManager.default.removeItem(at: nameFolder)
            print("delete ok")
        }catch{
            debugPrint("CANNOT REMOVE FOLDER")
        }
    }
    @IBAction func btnDelete(_ sender: Any) {
        
      if mModeAlbumPhoto == .selectall {
            for i in 0..<arrIndexPath.count {
                RemoveAlbum(nameFolder: arrIndexPath[i])
        
        }
        self.arrMoveIndex.removeAll()
        self.arrImageToLibrary.removeAll()
        self.arrSelectNameImageAlbum.removeAll()
           arrImage.removeAll()
           arrIndexPath.removeAll()
        mColectionView.reloadData()
        mModeAlbumPhoto = .view
       } else if mModeAlbumPhoto == .edit {
        if arrSelectNameImageAlbum.count == 0 {
            let alert = UIAlertController(title: "Notification", message: "No images have been selected. Can not delete !!!", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okaction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            for i in 0..<arrSelectNameImageAlbum.count {
                let ind = arrSelectNameImageAlbum[i]
                RemoveAlbum(nameFolder: arrIndexPath[ind])
            }
            for i in 0..<arrSelectNameImageAlbum.count {
                let ind = arrSelectNameImageAlbum[i]
                arrIndexPath.remove(at: ind - i)
            }
            arrImage.removeAll()
            ReadFile()
            mColectionView.reloadData()
            mModeAlbumPhoto = .view
            arrSelectNameImageAlbum.removeAll()
          //  arrSelectNameImageAlbum.removeAll()
            self.arrMoveIndex.removeAll()
            self.arrImageToLibrary.removeAll()
        }
        }
    }
    
    
}

extension PhotoAlbumViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func saveImageToLibrary(){
        for i in 0..<arrImageToLibrary.count{
            UIImageWriteToSavedPhotosAlbum(arrImageToLibrary[i], nil, nil, nil)
        }
        arrImageToLibrary.removeAll()

        
}
}
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            arrImageToLibrary.removeAll()
        }
        let cell = mColectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        if mModeAlbumPhoto == .view {
            cell.setImgCheckHidden()
        }
        else if mModeAlbumPhoto == .edit{
            cell.setImgCheck()
        }
        else {
            cell.setImgChecked()
        }
        let imageoop = arrImage[indexPath.row]
        let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
        arrIndexPath.append(path)
//        if let dataimage = UIImage(contentsOfFile: path.path)?.jpegData(compressionQuality: 0.5) {
//            cell.imgPhotoAlbum.image = UIImage(data: dataimage)
//            print("123123123213 \(UIImage(contentsOfFile: path.path)?.jpegData(compressionQuality: 1.0))")
//
//        }
        cell.imgPhotoAlbum.image = UIImage(contentsOfFile: path.path)
      //  arrImageToLibrary.append(UIImage(contentsOfFile: path.path)!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mModeAlbumPhoto {
        case .view:
            // Chuyển màn hình
            let photosinglescreen = PhotoSingleViewController()
            photosinglescreen.numberImage = arrImage.count
            photosinglescreen.index = indexPath
            photosinglescreen.arrIndexPath = arrIndexPath
            //photosinglescreen.url = arrIndexPath[indexPath.row]
            //photosinglescreen.pathimage = arrIndexPath[indexPath.row]
            
            
            // Collection View mới
            photosinglescreen.imgArray = arrIndexPath
            photosinglescreen.passedContentOffset = indexPath
            self.navigationController?.pushViewController(photosinglescreen, animated: true)
        case .edit:
            if let cell = mColectionView.cellForItem(at: indexPath) as? PhotoAlbumCollectionViewCell {
                cell.setImgChecked()
                
                arrSelectNameImageAlbum.append(indexPath.row)
                arrMoveIndex.append(arrIndexPath[indexPath.row])
                
                if arrSelectNameImageAlbum.count == arrImage.count {
                    mModeAlbumPhoto = .selectall
                }
                let imageoop = arrImage[indexPath.row]
             //   if let data = im
                let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
                arrImageToLibrary.append(UIImage(contentsOfFile: path.path)!)
                print("arrImageToLibary\(arrImageToLibrary)")
                
            }
        case .selectall:
            self.mColectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if mModeAlbumPhoto == .edit {
            for i in 0..<arrSelectNameImageAlbum.count{
                if arrSelectNameImageAlbum[i] == indexPath.row {
                    arrSelectNameImageAlbum.remove(at: i)
                    arrMoveIndex.remove(at: i)
                    print("Update mảng sau khi remove \(arrMoveIndex)")
                    break
                }
                
            }
            let imageoop = arrImage[indexPath.row]
            let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
            for i in 0..<arrImageToLibrary.count {
                if arrImageToLibrary[i].toString() == UIImage(contentsOfFile: path.path)!.toString() {
                    arrImageToLibrary.remove(at: i)
                    break
                    
                }
            }
            print(arrSelectNameImageAlbum.count)
            if let cell = mColectionView.cellForItem(at: indexPath) as? PhotoAlbumCollectionViewCell {
                cell.setImgCheck()
            }
            
            
        } else if mModeAlbumPhoto == .selectall {
            
            for i in 0..<arrSelectNameImageAlbum.count{
                if arrSelectNameImageAlbum[i] == indexPath.row {
                    arrSelectNameImageAlbum.remove(at: i)
                    break
                }
                
            }
            let imageoop = arrImage[indexPath.row]
            let path = getDocumentsDicretory().appendingPathComponent(titleNavAlbum!).appendingPathComponent(imageoop)
            let count = arrImageToLibrary.count - 1
            for i in 0..<count {
                if arrImageToLibrary[i].toString() == UIImage(contentsOfFile: path.path)!.toString() {
                    arrImageToLibrary.remove(at: i)
                    break
                }
            }
            print(arrSelectNameImageAlbum.count)
            if arrSelectNameImageAlbum.count < arrImage.count {
                if let cell = mColectionView.cellForItem(at: indexPath) as? PhotoAlbumCollectionViewCell {
                    cell.setImgCheck()
                }
                //cell.setImgCheck()
                mModeAlbumPhoto = .edit
            }
        }
      //  countIndex = countIndex + 1
    }
}
extension PhotoAlbumViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return mSizeCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
  
}


