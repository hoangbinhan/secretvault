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



class ContactPhotoLibaryViewController: BaseViewController {
    
    @IBOutlet weak var imgtest: UIImageView!
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!
    
    var indexViewController: Int!
    var titleNav: String?
    var mSizeCell: CGSize = .zero
    let spacingCell : CGFloat = 1
    var arrImage = Array<UIImage>() // mảng chứa hình
    var arrSelectedImage = Array<IndexPath>() // Mảng lưu giá trị khi Select
    var arrSelectNameImage = Array<UIImage>()
    var arrModels = Array<ImageModels1>()
    var folderName: String! = nil
    var hinh : UIImage?

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
  
    override func setupViews() {
        super.setupViews()
       
        setupUIComponent()
        configNavigationBar()
        setupUICollectionView()
        requestPermission()
        stopLoading()
       // didSelectButtonChecked()
    }
    func setupUIComponent()
    {
        mCollectionView.backgroundColor = .black
    }
    
    func configNavigationBar() {
        self.navigationItem.title = "All photos"
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = cameraBarButton
    }
    func setupUICollectionView() {
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        let xib = UINib(nibName: "ContactPhotoLibaryCollectionViewCell", bundle: nil)
        mCollectionView.register(xib, forCellWithReuseIdentifier: "ContactPhotoLibaryCollectionViewCell")
        
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
    func stopLoading() {
              
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    func requestPermission() {
          //self.showLoading()
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.grabPhotos()
                        
                }
                else {
                        
                }
            }
        }
    }
    // grabPhotos()
    func grabPhotos() {
        
        // Trả về đối tượng quản lý hình ảnh
        let imgManager = PHImageManager.default()
        // Các tuỳ chọn hình ảnh
        let requestOptions = PHImageRequestOptions()
        // Xử lý hình ảnh một cách đồng bộ
        requestOptions.isSynchronous = true
        // Chất lượng hình ảnh
        requestOptions.deliveryMode = .highQualityFormat
        //requestOptions.resizeMode = .none
        let fetchOptions = PHFetchOptions()
        //fetchOptions.fetchLimit = 3
        fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        
        
        if photos.count > 0 {
            for i in 0..<photos.count{
                
                imgManager.requestImage(for: photos.object(at: i) as PHAsset, targetSize: CGSize(width: 275, height:275),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    if let image1 = image {
                        self.arrImage.append(image1)
                        debugPrint("nnnnnnnnnnnnnnnnnn\(image?.jpegData(compressionQuality: 0.8))")
                    } else {
                        imgManager.requestImage(for: photos.object(at: i) as PHAsset, targetSize: CGSize(width: 255, height: 255),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                            if let image1 = image {
                                self.arrImage.append(image1)
                                debugPrint("nnnnnnnnnnnnnnnnnn\(image?.jpegData(compressionQuality: 0.8))")
                            }
                        })
                    }
                    
                })
            }
            mCollectionView.reloadData()
        } else {
            print("You got no photos.")
        }
        print("imageArray count: \(self.arrImage.count)")
        
    }
}
extension ContactPhotoLibaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mCollectionView.dequeueReusableCell(withReuseIdentifier: "ContactPhotoLibaryCollectionViewCell", for: indexPath) as! ContactPhotoLibaryCollectionViewCell
        cell.imgLibary.image = arrImage[indexPath.row]
        return cell
    }
    // Select && DidSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = mCollectionView.cellForItem(at: indexPath) as? ContactPhotoLibaryCollectionViewCell {
                arrSelectedImage.append(indexPath)
               print(arrSelectedImage.count)
                if let imgname = cell.imgLibary.image
                {
                    let a = self.navigationController!.viewControllers[indexViewController] as! ContactUpdateViewController
                    a.hinh = imgname
                    a.isLoading = true
                    navigationController?.popViewController(animated: true)
                }
            }
   }
}
extension ContactPhotoLibaryViewController: UICollectionViewDelegateFlowLayout {
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
extension ContactPhotoLibaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
           let a = self.navigationController!.viewControllers[indexViewController] as! ContactUpdateViewController
                a.hinh = UIImage.scaleImage(image: pickedImage, by: CGFloat(0.05))
                a.isLoading = true
                mCollectionView.reloadData()
        }
       self.dismiss(animated: true, completion: nil)
       self.navigationController?.popViewController(animated: true)
    }
}
extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio  = targetSize.width  / image.size.width
            let heightRatio = targetSize.height / image.size.height
            var newSize: CGSize
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
    }
    class func scaleImage(image: UIImage, by scale: CGFloat) -> UIImage? {
            let size = image.size
            let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
            return UIImage.resize(image: image, targetSize: scaledSize)
    }
}
