//
//  ContactInfomationViewController.swift
//  SecretVault
//
//  Created by Đặng Ngọc Đại on 8/29/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

protocol ContacttableviewDelega : class {
    func didEditButtonChecked1(model : Danhba2)
    
}
class ContactInfomationViewController: BaseViewController {
    
    @IBOutlet weak var mHinh      : UIButton!
    @IBOutlet weak var mView      : UIView!
    @IBOutlet weak var mNameLabel : UILabel!
    @IBOutlet weak var mName      : UILabel!
    @IBOutlet weak var mMobile    : UILabel!
    @IBOutlet weak var mHome      : UILabel!
    @IBOutlet weak var mWork      : UILabel!
    @IBOutlet weak var mURL       : UILabel!
    @IBOutlet weak var mEmail     : UILabel!
    @IBOutlet weak var mNote      : UILabel!
    // View
    @IBOutlet weak var viewNote   : UIView!
    @IBOutlet weak var viewEmail  : UIView!
    @IBOutlet weak var viewURL    : UIView!
    @IBOutlet weak var viewWork   : UIView!
    @IBOutlet weak var viewHome   : UIView!
    @IBOutlet weak var viewMobile : UIView!
    


    var isEditmode : Bool = false // Mặc định ở chế độ thêm
    var delege     : ContacttableviewDelega?
    var model      : Danhba2?
    var hinh       : String?
    var mnameLabel : String = ""
    var mname      : String?
    var mmobile    : String?
    var mhome      : String?
    var mwork      : String?
    var murl       : String?
    var memail     : String?
    var mnote      : String?

    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.Image.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked1))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    func configNavigationBar() {
       // self.navigationItem.title               = StringConstants.titleNavContact
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    func ColorContactt() {
        viewNote.backgroundColor   = Color.ColorView
        viewEmail.backgroundColor  = Color.ColorView
        viewURL.backgroundColor    = Color.ColorView
        viewHome.backgroundColor   = Color.ColorView
        viewMobile.backgroundColor = Color.ColorView
        viewWork.backgroundColor   = Color.ColorView
        mMobile.textColor          = Color.ColorInfo
        mHome.textColor            = Color.ColorInfo
        mWork.textColor            = Color.ColorInfo
        mURL.textColor             = Color.ColorInfo
        mEmail.textColor           = Color.ColorInfo
        mNote.textColor            = Color.ColorInfo
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        ColorContactt()
        Reference()
        CornerRadiusimage()
        
    }
    func CornerRadiusimage() {
        mHinh.layer.cornerRadius   = mHinh.frame.size.width/2
        mView.layer.cornerRadius   = mView.frame.size.width/2

        
        
    }
    func Reference() {
        mNameLabel.text = mnameLabel
        if let _ = hinh {
            mNameLabel.text = ""
            mHinh.setBackgroundImage(hinh!.toImage(), for: .normal)
        }
        mName.text      = mname
        mMobile.text    = mmobile
        mHome.text      = mhome
        mWork.text      = mwork
        mURL.text       = murl
        mEmail.text     = memail
        mNote.text      = mnote
    }
    
    @objc func didBackButtonChecked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didEditButtonChecked1() {
        if let model2 = model{
            delege?.didEditButtonChecked1(model: model2)
        }
    }
}
