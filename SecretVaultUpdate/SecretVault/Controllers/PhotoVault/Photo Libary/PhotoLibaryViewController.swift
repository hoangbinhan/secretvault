//
//  PhotoLibaryViewController.swift
//  SecretVault
//
//  Created by User01 on 9/9/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import Photos

import NVActivityIndicatorView
class PhotoLibaryViewController: BaseViewController {
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!
    
    var titleNav: String?
    var mSizeCell: CGSize = .zero
    let spacingCell : CGFloat = 1
    var selectAssets = [PHAsset]()
    
    var arrSelectedImage = Array<IndexPath>() // Mảng lưu giá trị khi Select
    var arrSelectNameImage = Array<UIImage>()
    var photos = PHFetchResult<PHAsset>()
    var imageRequest: UIImage?
    var countCell: Int?
    
    let fetchOptions = PHFetchOptions()
    
    let mygroup = DispatchGroup()
    var activityIndicator = UIActivityIndicatorView()
    var folderName: String! = nil
    var pathsaveImage:String?
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                // edit
                mCollectionView.allowsMultipleSelection = false
            case .edit:
                // done
                 mCollectionView.allowsMultipleSelection = true
            }
        }
    }
    
   
    // Button cancel on nav bar
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    // Button Camera
    lazy var cameraBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: Constants.ImagePhotoVault.imageCamera, style: .plain, target: self, action: #selector(didCameraButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
      didSelectButtonChecked()
        stopLoading()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        didSelectButtonChecked()

    }
  
    override func setupViews() {
        super.setupViews()
        setupUIComponent()
        configNavigationBar()
        setupUICollectionView()
     //   requestPermission()
        didSelectButtonChecked()
    }
    
    func setupUIComponent()
    {
        mCollectionView.backgroundColor = .black
        btnDone.backgroundColor = Color.enableButtonColor
        btnDone.tintColor = Color.yellowTextColor
    }
    func configNavigationBar() {
        self.navigationItem.title = "All photos"
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = cameraBarButton
    }
    func setupUICollectionView() {
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        let xib = UINib(nibName: "PhotoLibaryCollectionViewCell", bundle: nil)
        mCollectionView.register(xib, forCellWithReuseIdentifier: "PhotoLibaryCollectionViewCell")
        
        let remain = UIScreen.main.bounds.size.width - CGFloat(spacingCell*3)
        let wid = remain / 4
        let height = wid
        mSizeCell = CGSize.init(width: wid, height: height)
    }
    @objc func didCancelButtonChecked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didCameraButtonChecked() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    func didSelectButtonChecked() {
        if mMode == .view {
            mMode = .edit
        }else {
            mMode = .view
        }
        if mMode == .view {
            if let indexPaths = mCollectionView?.indexPathsForVisibleItems {
                for indexpath in indexPaths {
                    if let cell = mCollectionView.cellForItem(at: indexpath) as? PhotoLibaryCollectionViewCell {
                        cell.setImgCheckHidden()
                    }
                }
            }
        }
        else {
            //done
            if let indexPaths = mCollectionView?.indexPathsForVisibleItems {
                for indexpath in indexPaths {
                    if let cell = mCollectionView.cellForItem(at: indexpath) as? PhotoLibaryCollectionViewCell {
                       cell.setImgCheck()
                    }
                }
            }
        }
    }
    
    func stopLoading() {
               // let activityData = ActivityData(type: .ballClipRotate)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }


    
    
    func saveImage(foldername: String) {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      //  print(documents)
        for i in 0..<arrSelectNameImage.count {
            let imageName = UUID().uuidString
            debugPrint("huy123\(imageName)")
            
             let imgURL = documents.appendingPathComponent(foldername).appendingPathComponent("\(imageName).png")
            if !FileManager.default.fileExists(atPath: imgURL.path) {
                do {
                    let jpegData = arrSelectNameImage[i].jpegData(compressionQuality: 1.0)
                    try jpegData?.write(to: imgURL,options: .atomic)

                    print("image add successfully")
                }catch {
                  print("imgae not added")
                }
            }
    }
}
    
    @IBAction func btnDone(_ sender: Any) {
       if let foldername = folderName {
         saveImage(foldername: foldername)
       }
       navigationController?.popViewController(animated: true)
    }
}
extension PhotoLibaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        while (photos.count == 0){
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            debugPrint("countCell: \(photos.count)")
        }
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibaryCollectionViewCell", for: indexPath) as! PhotoLibaryCollectionViewCell
        if mMode == .view {
            cell.setImgCheckHidden()
        } else {
            cell.setImgCheck()
        }
        let mhphotoalbum = PhotoAlbumViewController()
        mhphotoalbum.titleNavAlbum = folderName
        // Trả về đối tượng quản lý hình ảnh
                    let imgManager = PHImageManager.default()
        //            // Các tuỳ chọn hình ảnh
                    let requestOptions = PHImageRequestOptions()
        //            // Xử lý hình ảnh một cách đồng bộ
                    requestOptions.isSynchronous = true
                    // Chất lượng hình ảnh
                    requestOptions.deliveryMode = .highQualityFormat
        imgManager.requestImage(for: self.photos.object(at: indexPath.row) as PHAsset, targetSize: CGSize(width: self.photos.object(at: indexPath.row).pixelWidth, height:self.photos.object(at: indexPath.row).pixelHeight),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
            if let image1 = image {
                cell.imgLibary.image = image1
            }

        })
        
        return cell
    }
    
    // Select && DidSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            print(indexPath)
        case .edit:
            if let cell = mCollectionView.cellForItem(at: indexPath) as? PhotoLibaryCollectionViewCell {
                cell.setImgChecked()
               // arr
                // Trả về đối tượng quản lý hình ảnh
                            let imgManager = PHImageManager.default()
                //            // Các tuỳ chọn hình ảnh
                            let requestOptions = PHImageRequestOptions()
                //            // Xử lý hình ảnh một cách đồng bộ
                            requestOptions.isSynchronous = true
                            // Chất lượng hình ảnh
                            requestOptions.deliveryMode = .highQualityFormat
                imgManager.requestImage(for: self.photos.object(at: indexPath.row) as PHAsset, targetSize: CGSize(width: self.photos.object(at: indexPath.row).pixelWidth, height:self.photos.object(at: indexPath.row).pixelHeight),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    if let image1 = image {
                        //cell.imgLibary.image = image1
                        //self.arrImage.append(image1)
                        self.arrSelectedImage.append(indexPath)
                        self.navigationItem.title = "\(self.arrSelectedImage.count) item selected"
                        print(self.arrSelectedImage)
                                        if let imgname = cell.imgLibary.image
                                        {
                                            self.arrSelectNameImage.append(imgname)
                                            let image = imgname.jpegData(compressionQuality: 0.8)
                                            
                        //                    arrSelectNameImage = arrSelectNameImage.filter{$0 != imgname}
                                            print("Lấy hình khi select \(self.arrSelectNameImage)")
                                        }
                    }
                })
            }
        }
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .edit {
            if let cell = mCollectionView.cellForItem(at: indexPath) as? PhotoLibaryCollectionViewCell {
               cell.setImgCheck()
               arrSelectedImage = arrSelectedImage.filter { $0 != indexPath}
                
                self.navigationItem.title = "\(arrSelectedImage.count) item selected"
                print(arrSelectedImage.count)
                if let imgname = cell.imgLibary.image
                {
                 debugPrint("aaaaa: \(imgname)")
                    print(arrSelectNameImage)
                    arrSelectNameImage = arrSelectNameImage.filter{$0 != imgname}
                   print(arrSelectNameImage)

                }
               
                
            }
        }
    }
    
    
}
extension PhotoLibaryViewController: UICollectionViewDelegateFlowLayout {
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
extension PhotoLibaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
           
           // arrImage.append(pickedImage)
         //   saveImage(foldername: String)
            
            
            arrSelectNameImage.append(pickedImage)
            if let foldername = folderName {
                saveImage(foldername: foldername)
            }
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            mCollectionView.reloadData()

        }
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
       self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
