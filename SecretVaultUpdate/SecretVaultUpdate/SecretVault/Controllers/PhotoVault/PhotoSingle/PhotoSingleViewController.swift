//
//  PhotoSingleViewController.swift
//  SecretVault
//
//  Created by User01 on 9/18/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PhotoSingleViewController: BaseViewController {
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var uiViewtoolBar: UIView!
    @IBOutlet weak var uiViewRecover: UIView!
    @IBOutlet weak var btnRecover: UIButton!
    @IBOutlet weak var lblRecover: UILabel!
    @IBOutlet weak var uiViewMove: UIView!
    @IBOutlet weak var lblMove: UILabel!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var uiViewDelete: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblDelete: UILabel!
    
    var f = true
    
    var hinh:UIImage?
    var url:URL?
    var numberImage:Int?
    var index: IndexPath?
    //var pathimage:URL? // biến chứa đường dẫn hình
    var isScrollView: Bool = false
    
    var arrIndexPath = Array<URL>()
    var imgArray = Array<URL>()
    var passedContentOffset = IndexPath()
    var mSizeCell: CGSize = .zero
    let spacingCell : CGFloat = 0
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: Constants.ImagePhotoVault.defaultBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        f = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if f == true {
//                            mCollectionView.scrollToItem(at: passedContentOffset, at: [.centeredVertically, .centeredHorizontally], animated: false)
//                            f = false
//                    }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

    }
    override func setupViews() {
        super.setupViews()
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DissmissKeyBoard))
//        self..addGestureRecognizer(tAp)
        
        configNavigationBar()
        setupUIComponent()
        setupCollectionView()
        //print("Số lượng hình single\(arrImageSingle.count)")
        //print("biến giữ hình \(pathimage!)")
          NotificationCenter.default.addObserver(self, selector: #selector(self.isTapPhoto), name: NSNotification.Name.isTapPhoto, object: nil)
    }
    override var prefersStatusBarHidden: Bool {
        if isScrollView == false {
            return false
        }
       return true
    }
    @objc func isTapPhoto() {
                if uiViewtoolBar.isHidden == false {
                    isScrollView = true
                    uiViewtoolBar.isHidden = true
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    
        
                }else {
                    isScrollView = false
                    uiViewtoolBar.isHidden = false
                    self.navigationController?.hidesBarsOnTap = false
                    self.navigationController?.setNavigationBarHidden(false, animated: true)

                }
    }
    func setupUIComponent() {
        self.uiViewtoolBar.backgroundColor = Color.navBgColor
        self.uiViewRecover.backgroundColor = .clear
        self.uiViewMove.backgroundColor = .clear
        self.uiViewDelete.backgroundColor = .clear
           // imgSingle.image =  try! UIImage(data:  Data.init(contentsOf: pathimage!))
        
    }
    func setupCollectionView() {
//        if let layout = mCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        let xib = UINib(nibName: "PhotoSingleCollectionViewCell", bundle: nil)
        mCollectionView.register(xib, forCellWithReuseIdentifier: "PhotoSingleCollectionViewCell")


        
//        mCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "cell")
//        mCollectionView.isPagingEnabled = true
//        mCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    func configNavigationBar() {
        //self.navigationItem.title = "\(index!.row + 1)/\(numberImage!)"
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    // Delete Images
    func RemoveAlbum(nameFolder:URL)
    {
        
        do{
            try FileManager.default.removeItem(at: nameFolder)
            print("xoa thanh cong")
        }catch{
            debugPrint("CANNOT REMOVE FOLDER")
        }
    }
    @objc func didBackButtonChecked() {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnRecover(_ sender: Any) {
      
            // Thông báo
            let alert = UIAlertController(title: "This item will be moved to Camera Roll. Are you sure?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let btnMove: UIAlertAction = UIAlertAction(title: "Move to Camera Roll", style: UIAlertAction.Style.destructive) { (alertaction) in
                // Code bên trong
                self.saveImageToLibary()
            //    self.saveImageToLibrary()
                let alertthongbao = UIAlertController(title: "Notification", message: "Move to camera roll successfully!!\n Open libary to check", preferredStyle: UIAlertController.Style.alert)
                let actionthongbao = UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { (alertaction) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertthongbao.addAction(actionthongbao)
                self.present(alertthongbao, animated: true
                    , completion: nil)
            }
            let btnCancel: UIAlertAction = UIAlertAction(title: "Cancel ", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(btnMove)
            alert.addAction(btnCancel)
            present(alert, animated: true, completion: nil)
    }
    @IBAction func btnMove(_ sender: Any) {
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
        let mhmovephoto = PhotoMoveAlbumViewController()
        mhmovephoto.pathPhotoMoveURL = url
        mhmovephoto.isMoveSingle = true
        self.navigationController?.pushViewController(mhmovephoto, animated: true)
        
    }
    @IBAction func btnDelete(_ sender: Any) {
       // deleteDirectory(path: String)
       // RemoveAlbum(nameFolder: hinh!)
      //  print(url)
        if let url1 = url {
            RemoveAlbum(nameFolder: url1)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension PhotoSingleViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func saveImageToLibary() {
        UIImageWriteToSavedPhotosAlbum(hinh!, nil, nil, nil)
    }
}
extension PhotoSingleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSingleCollectionViewCell", for: indexPath) as! PhotoSingleCollectionViewCell
        cell.imgPhotoSingle.image = UIImage(contentsOfFile: imgArray[indexPath.row].path)
        
        if f == true {
                          mCollectionView.scrollToItem(at: passedContentOffset, at: .left, animated: false)
                            f = false
                        }
      //  self.navigationItem.title = "\(indexPath.row + 1)/\(numberImage!)"

        
//        defer {
//
//            if f == true {
//                mCollectionView.scrollToItem(at: passedContentOffset, at: [.centeredVertically, .centeredHorizontally], animated: false)
//                f = false
//            }
//        }
//
//        let cell = mCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewFullViewCell
//
//        cell.imgView.image = UIImage(contentsOfFile: imgArray[indexPath.row].path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        debugPrint(indexPath)
        self.navigationItem.title = "\(indexPath.row + 1)/\(numberImage!)"
        hinh = UIImage(contentsOfFile: imgArray[indexPath.row].path)
        url = arrIndexPath[indexPath.row]
    }
//    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
//        return passedContentOffset
//    }
//    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
//        return passedContentOffset
//    }
////    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.navigationItem.title = "\(indexPath.row)/\(numberImage!)"
//        hinh = UIImage(contentsOfFile: imgArray[indexPath.row].path)
//        url = arrIndexPath[indexPath.row]
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if uiViewtoolBar.isHidden == false {
            isScrollView = true
            uiViewtoolBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            
        }else {
            isScrollView = false
            uiViewtoolBar.isHidden = false
            self.navigationController?.hidesBarsOnTap = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//    }
    
    // UI
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = mCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
  
    
   
    
    
}
//class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
//
//    var scrollImg: UIScrollView!
//    var imgView: UIImageView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        scrollImg = UIScrollView()
//        scrollImg.delegate = self
//        scrollImg.alwaysBounceVertical = false
//        scrollImg.alwaysBounceHorizontal = false
//        scrollImg.showsVerticalScrollIndicator = true
//        scrollImg.flashScrollIndicators()
//        scrollImg.minimumZoomScale = 1.0
//        scrollImg.maximumZoomScale = 4.0
//       // let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapScrollView(recognizer:)))
//        scrollImg.addGestureRecognizer(tap)
//      //  doubleTapGest.numberOfTapsRequired = 2
//      //  scrollImg.addGestureRecognizer(doubleTapGest)
//        self.addSubview(scrollImg)
//        imgView = UIImageView()
//       // imgView.image = UIImage(named: "user3")
//        scrollImg.addSubview(imgView!)
//        imgView.contentMode = .scaleAspectFit
//    }
// //   scrollViewWillBeginDragging
////    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
////        //return 1
////        print("3232122222")
////    }
//    @objc func handleTapScrollView(recognizer: UITapGestureRecognizer){
////        if scrollImg.zoomScale != 1 {
////            NotificationCenter.default.post(name:  NSNotification.Name.isTapPhoto, object: nil)
////
////        } else {
////        }
//        NotificationCenter.default.post(name:  NSNotification.Name.isTapPhoto, object: nil)
//
//    }
//
////    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
////        if scrollImg.zoomScale == 1 {
////            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
////            debugPrint("scrollImg.zoomScale \(scrollImg.zoomScale)" )
////         //   NotificationCenter.default.post(name:  NSNotification.Name.isTapPhoto, object: nil)
////
////        } else {
////            scrollImg.setZoomScale(1, animated: false)
////            imgView.contentMode = .scaleAspectFit
////         //   NotificationCenter.default.post(name:  NSNotification.Name.isTapPhoto, object: nil)
////
////        }
////    }
//
////    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
////        var zoomRect = CGRect.zero
////        zoomRect.size.height = imgView.frame.size.height / scale
////        zoomRect.size.width  = imgView.frame.size.width  / scale
////        let newCenter = imgView.convert(center, from: scrollImg)
////        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
////        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
////        return zoomRect
////    }
//
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imgView
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        scrollImg.frame = self.bounds
//        imgView.frame = self.bounds
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        scrollImg.setZoomScale(1, animated: true)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
