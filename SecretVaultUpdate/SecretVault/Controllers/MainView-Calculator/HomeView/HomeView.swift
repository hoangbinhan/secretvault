//
//  HomeView.swift
//  SecretVault
//
//  Created by Quang Tran on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum UIUserInterfaceIdiom : Int {


    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}
class HomeView: UIViewController, GADBannerViewDelegate {
    
    

    @IBOutlet weak var mTitleSecretVault: UILabel!
    //

    @IBOutlet weak var mSetting: UIButton!
    @IBOutlet weak var mContact: UIButton!
    @IBOutlet weak var mBrowser: UIButton!
    @IBOutlet weak var mPassWordKey: UIButton!
    @IBOutlet weak var mMainButton: UIButton!
    @IBOutlet weak var mText: UILabel!
    @IBOutlet weak var mWide: UILabel!
    
    //banner ads
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setup()
        let document = String.init(format: "%@/Documents/\(Constants.DefaultFolder.titleFileImport)", NSHomeDirectory())
        do{
            try FileManager.default.createDirectory(atPath: document, withIntermediateDirectories: true, attributes: nil)
        }catch{}
        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    
    //
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }


   func setup()
   {
    
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        mText.font = Font.font(size: 32, weight: UIFont.Weight.bold)
           mTitleSecretVault.font = Font.font(size: 22, weight: UIFont.Weight.bold)
          
           
           //
           
           mText.text = StringConstants.titleHome
           mTitleSecretVault.text = StringConstants.titleHomeSecretVault
           
        
           
           //
           mPassWordKey.backgroundColor = Color.denableButtonColor
           mPassWordKey.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mPassWordKey.translatesAutoresizingMaskIntoConstraints = false
           mPassWordKey.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
           mPassWordKey.topAnchor.constraint(equalTo: self.mMainButton.bottomAnchor, constant: 15).isActive = true
           let wid: NSLayoutConstraint = NSLayoutConstraint(item: mPassWordKey, attribute: .width  , relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: -32)
           self.view.addConstraint(wid)
           mPassWordKey.heightAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           //
           mBrowser.backgroundColor = Color.denableButtonColor
           mBrowser.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mBrowser.translatesAutoresizingMaskIntoConstraints = false
           mBrowser.topAnchor.constraint(equalTo: self.mMainButton.bottomAnchor, constant: 15).isActive = true
           mBrowser.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
           mBrowser.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mBrowser.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mContact.backgroundColor = Color.denableButtonColor
           mContact.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mContact.translatesAutoresizingMaskIntoConstraints = false
           mContact.topAnchor.constraint(equalTo: self.mPassWordKey.bottomAnchor, constant: 15).isActive = true
           mContact.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
           mContact.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mContact.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mSetting.backgroundColor = Color.denableButtonColor
           mSetting.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mSetting.translatesAutoresizingMaskIntoConstraints = false
           mSetting.topAnchor.constraint(equalTo: self.mBrowser.bottomAnchor, constant: 15).isActive = true
           mSetting.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
           mSetting.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mSetting.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mMainButton.backgroundColor = Color.denableButtonColor
           mMainButton.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           
           //banner view
           bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
           bannerView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
           bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
           bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
           bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    default:
        mText.font = Font.font(size: 52, weight: UIFont.Weight.bold)
           mTitleSecretVault.font = Font.font(size: 42, weight: UIFont.Weight.bold)
        mWide.font = Font.font(size: 22, weight:.thin)
          
           
           //
           
           mText.text = StringConstants.titleHome
           mTitleSecretVault.text = StringConstants.titleHomeSecretVault
           
        
           
           //
           mPassWordKey.backgroundColor = Color.denableButtonColor
           mPassWordKey.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mPassWordKey.translatesAutoresizingMaskIntoConstraints = false
           mPassWordKey.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
           mPassWordKey.topAnchor.constraint(equalTo: self.mMainButton.bottomAnchor, constant: 15).isActive = true
           let wid: NSLayoutConstraint = NSLayoutConstraint(item: mPassWordKey, attribute: .width  , relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: -32)
           self.view.addConstraint(wid)
           mPassWordKey.heightAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           //
           mBrowser.backgroundColor = Color.denableButtonColor
           mBrowser.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mBrowser.translatesAutoresizingMaskIntoConstraints = false
           mBrowser.topAnchor.constraint(equalTo: self.mMainButton.bottomAnchor, constant: 15).isActive = true
           mBrowser.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
           mBrowser.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mBrowser.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mContact.backgroundColor = Color.denableButtonColor
           mContact.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mContact.translatesAutoresizingMaskIntoConstraints = false
           mContact.topAnchor.constraint(equalTo: self.mPassWordKey.bottomAnchor, constant: 15).isActive = true
           mContact.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
           mContact.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mContact.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mSetting.backgroundColor = Color.denableButtonColor
           mSetting.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           mSetting.translatesAutoresizingMaskIntoConstraints = false
           mSetting.topAnchor.constraint(equalTo: self.mBrowser.bottomAnchor, constant: 15).isActive = true
           mSetting.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
           mSetting.widthAnchor.constraint(equalTo: self.mPassWordKey.widthAnchor, multiplier: 1).isActive = true
           mSetting.heightAnchor.constraint(equalTo: self.mBrowser.widthAnchor, multiplier: 1).isActive = true
           //
           mMainButton.backgroundColor = Color.denableButtonColor
           mMainButton.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
           
           //banner view
           bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
           bannerView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(bannerView)
           bannerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
           bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
           bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
           bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
       
       
       
   }
    
    @IBAction func homeView(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.mContact.backgroundColor = Color.denableButtonColor
            self.mPassWordKey.backgroundColor = Color.denableButtonColor
            self.mBrowser.backgroundColor = Color.denableButtonColor
            self.mSetting.backgroundColor = Color.denableButtonColor
            self.mMainButton.backgroundColor = Color.enableButtonColor
            
        }, completion: nil)
        
        let categoriesVC = PhotoVaultViewController.loadFromNib()
        let window = AppDelegate.shared.window
        //        window?.rootViewController = categoriesVC
        //        window?.makeKeyAndVisible()
        //        //
        let navController = UINavigationController(rootViewController: categoriesVC)
        //
        navController.navigationBar.isTranslucent       = false
        navController.navigationBar.barTintColor        = Color.navBgColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
        //        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    @IBAction func PasswordBtn(_ sender: Any) {
       
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.mPassWordKey.backgroundColor = Color.enableButtonColor
            self.mContact.backgroundColor = Color.denableButtonColor
            self.mBrowser.backgroundColor = Color.denableButtonColor
            self.mSetting.backgroundColor = Color.denableButtonColor
            self.mMainButton.backgroundColor = Color.denableButtonColor
            
        }, completion: nil)
        //chuyển màn hình - để không bị che khuất ở phía trên màn hình
        
        let categoriesVC = PasswordKeeperViewController.loadFromNib()
        let window = AppDelegate.shared.window
        //        window?.rootViewController = categoriesVC
        //        window?.makeKeyAndVisible()
        //        //
        let navController = UINavigationController(rootViewController: categoriesVC)
        //
        navController.navigationBar.isTranslucent       = false
        navController.navigationBar.barTintColor        = Color.navBgColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
        //        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    @IBAction func BrowserBtn(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 0.01, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.mContact.backgroundColor = Color.denableButtonColor
            self.mPassWordKey.backgroundColor = Color.denableButtonColor
            self.mBrowser.backgroundColor = Color.enableButtonColor
            self.mSetting.backgroundColor = Color.denableButtonColor
            self.mMainButton.backgroundColor = Color.denableButtonColor
           
            
        }, completion: nil)
        
        let window = AppDelegate.shared.window
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
     
      
        
    }
    
    @IBAction func ContactBtn(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.mContact.backgroundColor = Color.enableButtonColor
            self.mPassWordKey.backgroundColor = Color.denableButtonColor
            self.mBrowser.backgroundColor = Color.denableButtonColor
            self.mSetting.backgroundColor = Color.denableButtonColor
            self.mMainButton.backgroundColor = Color.denableButtonColor
            
        }, completion: nil)
        //chuyển màn hình - để không bị che khuất ở phía trên màn hình
        
        let categoriesVC = ContactViewController.loadFromNib()
        let window = AppDelegate.shared.window
        //        window?.rootViewController = categoriesVC
        //        window?.makeKeyAndVisible()
        //        //
        let navController = UINavigationController(rootViewController: categoriesVC)
        //
        navController.navigationBar.isTranslucent       = false
        navController.navigationBar.barTintColor        = Color.navBgColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
        //        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    @IBAction func SettingBtn(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.mContact.backgroundColor = Color.denableButtonColor
            self.mPassWordKey.backgroundColor = Color.denableButtonColor
            self.mBrowser.backgroundColor = Color.denableButtonColor
            self.mSetting.backgroundColor = Color.enableButtonColor
            self.mMainButton.backgroundColor = Color.denableButtonColor
            
        }, completion: nil)
        
        //chuyển màn hình - để không bị che khuất ở phía trên màn hình
        
        let categoriesVC = SettingViewController.loadFromNib()
        let window = AppDelegate.shared.window
//        window?.rootViewController = categoriesVC
//        window?.makeKeyAndVisible()
//        //
        let navController = UINavigationController(rootViewController: categoriesVC)
        //
        navController.navigationBar.isTranslucent       = false
        navController.navigationBar.barTintColor        = Color.navBgColor
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.yellowTextColor]
//        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        
    }
    
}
