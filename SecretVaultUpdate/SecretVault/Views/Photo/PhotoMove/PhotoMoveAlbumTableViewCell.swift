//
//  PhotoMoveAlbumTableViewCell.swift
//  SecretVault
//
//  Created by User01 on 9/20/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PhotoMoveAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var numberPhotoMove: UILabel!
    @IBOutlet weak var lblNamePhotoMove: UILabel!
    @IBOutlet weak var imgPhotoMove: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupUI()
    {
        imgPhotoMove.image = Constants.ImagePhotoVault.imageAlbum
        lblNamePhotoMove.textColor = .white
        numberPhotoMove.textColor = .gray
        self.backgroundColor = Color.tableviewcellColor
    }
    
   
    
}
