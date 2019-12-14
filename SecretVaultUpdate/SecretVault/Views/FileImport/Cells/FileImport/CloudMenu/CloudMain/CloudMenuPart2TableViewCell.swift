//
//  CloudMenuPart2TableViewCell.swift
//  SecretVault
//
//  Created by MAC_OS on 9/9/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class CloudMenuPart2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var viewLine: UIView!
    
    var didTapEditButton: (()-> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(title: String, indexpath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        selectedBackgroundView = backgroundView
        tintColor                   = Color.yellowTextColor
        backgroundColor             = Color.navBgColor
        viewEdit.backgroundColor    = Color.navBgColor
        lblName.textColor           = .white
        let iconMusic: UIImage      = UIImage.init(named: "ic_music")!
        let iconVideo: UIImage      = UIImage.init(named: "ic_video")!
        let iconPicture: UIImage    = UIImage.init(named: "ic_picture")!
        let iconWord: UIImage       = UIImage.init(named: "ic_doc")!
        let iconPdf: UIImage        = UIImage.init(named: "ic_pdf")!
        let iconCompress: UIImage   = UIImage.init(named: "ic_compress")!
        
        lblName.text = title
        if FileHelpers.checkExtensionFilesInFolder(fileName: title)         == 1 {
            imgIcon.image = iconPicture
        }
        else if FileHelpers.checkExtensionFilesInFolder(fileName: title)    == 2 {
            imgIcon.image = iconMusic
        }
        else if FileHelpers.checkExtensionFilesInFolder(fileName: title)    == 3 {
            imgIcon.image = iconVideo
        }
        else if FileHelpers.checkExtensionFilesInFolder(fileName: title)    == 4 {
            imgIcon.image = iconWord
        }
        else if FileHelpers.checkExtensionFilesInFolder(fileName: title)    == 5 {
            imgIcon.image = iconPdf
        }
        else if FileHelpers.checkExtensionFilesInFolder(fileName: title)    == 6 {
            imgIcon.image = iconCompress
        }
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
          self.didTapEditButton?()
    }
    
    
}
