//
//  FileCollectionViewCell.swift
//  SecretVault
//
//  Created by MAC_OS on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgFolder: UIImageView!
    @IBOutlet weak var lblNameFolder: UILabel!
    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        viewCheck.backgroundColor = .clear
        imgFolder.image = Constants.ImageFileImport.imageFolder
    }
    
    func setImgCheck() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden  = false
        imgCheck.image      = Constants.ImageFileImport.imageCheck
    }
    
    func setImgChecked() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden  = false
        imgCheck.image      = Constants.ImageFileImport.imageChecked
    }
    
    func setImgCheckHidden() {
        viewCheck.backgroundColor = .clear
        viewCheck.isHidden  = true
    }
    

}
