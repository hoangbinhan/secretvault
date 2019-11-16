//
//  PhotoAlbumCollectionViewCell.swift
//  SecretVault
//
//  Created by User01 on 9/10/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewcheck: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgPhotoAlbum: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        viewcheck.backgroundColor = .clear
        
    }
    // hình oval
    func setImgCheck() {
        viewcheck.backgroundColor = .clear
        viewcheck.isHidden = false
        imgCheck.image = Constants.ImagePhotoVault.imageCheck
    }
    // có hình check
    // view check không màu
    // và hiện lên
    func setImgChecked() {
        viewcheck.backgroundColor = .clear
        viewcheck.isHidden = false
        imgCheck.image = Constants.ImagePhotoVault.imageChecked
    }
    // Ản view check đi và viewcheck không màu
    func setImgCheckHidden() {
        viewcheck.backgroundColor = .clear
        viewcheck.isHidden = true
    }
   
    
}
