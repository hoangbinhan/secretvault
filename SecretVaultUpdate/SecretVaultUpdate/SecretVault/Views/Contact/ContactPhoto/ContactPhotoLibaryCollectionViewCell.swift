//
//  PhotoLibaryCollectionViewCell.swift
//  SecretVault
//
//  Created by User01 on 9/9/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import RealmSwift
protocol ContacttableviewAddimageDelega : class {
    func AddImagee(model : UIImage)
}

class ContactPhotoLibaryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgLibary: UIImageView!
    @IBOutlet weak var viewCheck1: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    var delege : ContacttableviewAddimageDelega?
    var model : UIImage?
    var hinhh : UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI1()
    }
    private func setupUI1() {
        viewCheck1.backgroundColor = .clear
    }
    func AddImagee()
    {
        if let model2 = model{
            delege?.AddImagee(model: model2)
        }
    }
    // hình oval
//    func setImgCheck() {
//        viewCheck.backgroundColor = .clear
//        viewCheck.isHidden = false
//        imgCheck.image = Constants.ImagePhotoVault.imageCheck
//    }
//     có hình check
//     view check không màu
//     và hiện lên
//    func setImgChecked() {
//        viewCheck.backgroundColor = .clear
//        viewCheck.isHidden = false
//        imgCheck.image = Constants.ImagePhotoVault.imageChecked
//    }
    // Ản view check đi và viewcheck không màu
    func setImgCheckHidden() {
        viewCheck1.backgroundColor = .clear
        viewCheck1.isHidden = true
    }
    
    

}
