//
//  ContactTableViewCell.swift
//  SecretVault
//
//  Created by Đặng Ngọc Đại on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var imgHinh  : UIImageView!
    @IBOutlet weak var lblName  : UILabel!
    @IBOutlet weak var lblNameST: UILabel!
    @IBOutlet weak var lblView  : UIView!
    @IBOutlet weak var View     : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetupUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func SetupUI() {
        imgHinh.layer.cornerRadius = imgHinh.frame.size.width/2
        lblView.layer.cornerRadius = lblView.frame.size.width/2
        imgHinh.backgroundColor    = Color.ColorText
    //    self.backgroundColor       = Color.denableButtonColor
        self.backgroundColor       = Color.tableviewcellColor
        lblName.textColor          = Color.SectionTextColor
        lblNameST.textColor        = Color.SectionText
        View.backgroundColor       = Color.ColorView
    }
}
