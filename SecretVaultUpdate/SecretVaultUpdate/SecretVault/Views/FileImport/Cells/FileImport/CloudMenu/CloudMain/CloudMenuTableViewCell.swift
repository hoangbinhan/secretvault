//
//  CloudMenuTableViewCell.swift
//  SecretVault
//
//  Created by MAC_OS on 9/1/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class CloudMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    var didTapEditButton: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(title: String, image: String, indexpath: IndexPath) {
        self.imgIcon.image          = UIImage.init(named: image)
        self.lblName.text           = title
        self.backgroundColor        = Color.navBgColor
        containView.backgroundColor = Color.navBgColor
        imgEdit.image               = UIImage.init(named: "ic_edit")
        lineView.backgroundColor    = Color.enableButtonColor
        imgCheck.image              = UIImage.init(named: "ic_check")
    }
    
    func transformMoveRight() {
        imgCheck.transform  = CGAffineTransform(translationX: 30, y: 0)
        imgIcon.transform   = CGAffineTransform(translationX: 24, y: 0)
        lblName.transform   = CGAffineTransform(translationX: 24, y: 0)
    }
    func transformMoveLeft() {
        imgCheck.transform  = CGAffineTransform(translationX: -24, y: 0)
        imgIcon.transform   = CGAffineTransform(translationX:   0, y: 0)
        lblName.transform   = CGAffineTransform(translationX:   0, y: 0)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        self.didTapEditButton?()
    }
    
    
}
