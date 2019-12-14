//
//  PasswordKeeperTableCell.swift
//  SecretVault
//
//  Created by 5K on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class PasswordKeeperTableCell: UITableViewCell {

    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var view : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpUI(){
        view.backgroundColor = Color.subView
        mName.textColor = Color.sectionTextColor
        self.backgroundColor = Color.tableviewcellColor
    }
    
}
