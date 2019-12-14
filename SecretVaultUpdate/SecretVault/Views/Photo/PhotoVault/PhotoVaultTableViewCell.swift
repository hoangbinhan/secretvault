//
//  PhotoVaultTableViewCell.swift
//  SecretVault
//
//  Created by User01 on 9/4/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PhotoVaultTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblNumberphoto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI()
    {
        imgAlbum.image = Constants.ImagePhotoVault.imageAlbum
        lblAlbum.textColor = .white
        lblNumberphoto.textColor = .gray
        self.backgroundColor = Color.tableviewcellColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
