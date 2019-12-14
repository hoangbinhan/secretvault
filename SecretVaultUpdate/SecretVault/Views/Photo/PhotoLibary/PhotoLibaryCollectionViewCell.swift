//
//  PhotoLibaryCollectionViewCell.swift
//  SecretVault
//
//  Created by User01 on 9/9/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PhotoLibaryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgLibary: UIImageView!
    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        viewCheck.backgroundColor = .clear
    }
    // hình oval
    func setImgCheck() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden = false
        imgCheck.image = Constants.ImagePhotoVault.imageCheck
    }
    // có hình check
    // view check không màu
    // và hiện lên
    func setImgChecked() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden = false
        imgCheck.image = Constants.ImagePhotoVault.imageChecked
    }
    // Ản view check đi và viewcheck không màu
    func setImgCheckHidden() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden = true
    }

}
