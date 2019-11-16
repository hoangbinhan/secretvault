//
//  InfoPasswordKeeperViewController.swift
//  SecretVault
//
//  Created by 5K on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

protocol InfoPasswordDelegate : class {
    func didEditButtonChecked1(model : PasswordKeeper)
    
}

class InfoPasswordKeeperViewController: BaseViewController {
    
    @IBOutlet weak var mName        : UILabel!
    @IBOutlet weak var mUserName    : UILabel!
    @IBOutlet weak var mPassword    : UILabel!
    @IBOutlet weak var mWeb         : UILabel!
    @IBOutlet weak var mNote        : UILabel!
    @IBOutlet weak var viewUserName : UIView!
    @IBOutlet weak var viewPassword : UIView!
    @IBOutlet weak var viewWeb      : UIView!
    @IBOutlet weak var viewNote     : UIView!
    
    var delege     : InfoPasswordDelegate?
    var model      : PasswordKeeper?
    var mname      : String?
    var musername  : String?
    var mpassword  : String?
    var mweb       : String?
    var mnote      : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
    }
    
    override func setupViews() {
        super.setupViews()
        
        mName.textColor     = Color.yellowTextColor
        mUserName.textColor = Color.yellowTextColor
        mPassword.textColor = Color.yellowTextColor
        mWeb.textColor      = Color.yellowTextColor
        mNote.textColor     = Color.yellowTextColor
        
        //
        viewUserName.backgroundColor = Color.subView
        viewPassword.backgroundColor = Color.subView
        viewWeb.backgroundColor      = Color.subView
        viewNote.backgroundColor     = Color.subView
        
        //
        mName.layer.cornerRadius     = Constants.Radius.defaultTextFieldRadius
        mUserName.layer.cornerRadius = Constants.Radius.defaultTextFieldRadius
        mPassword.layer.cornerRadius = Constants.Radius.defaultTextFieldRadius
        mWeb.layer.cornerRadius      = Constants.Radius.defaultTextFieldRadius
        mNote.layer.cornerRadius     = Constants.Radius.defaultTextFieldRadius
    }
    
    override func setupData() {
        super.setupData()
        
        mName.text      = model?.mName
        mUserName.text  = model?.mUserName
        mPassword.text  = model?.mPassword
        mWeb.text       = model?.mWebsite
        mNote.text      = model?.mNote
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: UIImage(named: "password_back"), style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    lazy var backBarTitle: UIBarButtonItem = {
        let barTitleItem = UIBarButtonItem(title: "Password", style: .plain, target: self, action: #selector(didBackButtonChecked))
        barTitleItem.tintColor = Color.yellowTextColor
        return barTitleItem
    }()
    
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked1))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    func configNavigationBar() {
        self.navigationItem.leftBarButtonItems   = [backBarButton, backBarTitle]
        self.navigationItem.rightBarButtonItem   = editBarButton
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
