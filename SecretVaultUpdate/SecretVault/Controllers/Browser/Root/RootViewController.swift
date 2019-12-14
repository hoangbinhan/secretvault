//
//  RootViewController.swift
//  BrowserSafari
//
//  Created by TKapps_01 on 8/13/19.
//  Copyright © 2019 TKapps_01. All rights reserved.
//

import UIKit
import WebKit
import SCSafariPageController
import GoogleMobileAds

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

@objc protocol RootDelegate {
    @objc optional func onBackButtonTap(_ rootviewController:RootViewController)
    @objc optional func onNextButtonTap(_ rootviewController:RootViewController)
    
}


class RootViewController: UIViewController , SCSafariPageControllerDataSource, SCSafariPageControllerDelegate, ViewControllerDelegate, GADBannerViewDelegate {
     var delegate:RootDelegate?
    
    @IBOutlet weak var mDone: UIButton!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mNext: UIButton!
    @IBOutlet weak var mBack: UIButton!
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var bannerView: GADBannerView!
    
    var dataSource = Array<ViewController?>()
    let safariPageController:SCSafariPageController = SCSafariPageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //
        setupViewBackground()
        //
       setupNotificationCenter()
        //
        setupSafariPageController()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    
    //setupSafariPageController
    func setupSafariPageController () {
        self.safariPageController.dataSource = self
        self.safariPageController.delegate = self
    }
    //setupViewBackground
    func setupViewBackground () {
        // custom backgroundColor
        view.backgroundColor = Color.blackBgColor
        mView.backgroundColor = Color.navBgColor
        mDone.setTitle("Done", for: .normal)
        mDone.setTitleColor(Color.yellowTextColor, for: .normal)
        
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            mView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        } else {
            mView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        mBack.translatesAutoresizingMaskIntoConstraints = false
        mBack.leadingAnchor.constraint(equalTo: self.mView.leadingAnchor, constant: 16).isActive = true
        mBack.centerYAnchor.constraint(equalTo: self.mView.centerYAnchor).isActive = true
        mBack.widthAnchor.constraint(equalToConstant: 10).isActive = true
        mBack.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        mNext.translatesAutoresizingMaskIntoConstraints = false
        mNext.leadingAnchor.constraint(equalTo: self.mBack.trailingAnchor, constant: 75.5).isActive = true
        mNext.centerYAnchor.constraint(equalTo: self.mView.centerYAnchor).isActive = true
        mNext.widthAnchor.constraint(equalToConstant: 10).isActive = true
        mNext.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: self.mView.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: self.mView.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.trailingAnchor.constraint(equalTo: self.mView.trailingAnchor, constant: -17).isActive = true
        zoomButton.centerYAnchor.constraint(equalTo: self.mView.centerYAnchor).isActive = true
        zoomButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        mDone.translatesAutoresizingMaskIntoConstraints = false
        mDone.trailingAnchor.constraint(equalTo: self.mView.trailingAnchor, constant: -8).isActive = true
        mDone.centerYAnchor.constraint(equalTo: self.mView.centerYAnchor).isActive = true
        mDone.widthAnchor.constraint(equalToConstant: 37).isActive = true
        mDone.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    //setupNotificationCenter
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onTest), name: NSNotification.Name.testBrowser, object: nil)
    }
//onTest
    @objc func onTest() {
        mDone.alpha = 0
        zoomButton.alpha = 1
    }
//viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.mBack.isEnabled = true
        self.mNext.isEnabled = true
         self.zoomButton.isEnabled = true
        self.safariPageController.zoomOut(animated: true, completion: nil)
        //
        self.addChild(self.safariPageController)
        self.safariPageController.view.frame = self.view.bounds
        self.view.insertSubview(self.safariPageController.view, at: 0)
        self.safariPageController.didMove(toParent: self)
        // when ROOTVIEWCONTROLLER load then button Done will hide
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.mDone.alpha = 0
        })
        //
        self.dataSource.insert(nil, at: Int(self.safariPageController.numberOfPages))
        self.safariPageController.insertPages(at: IndexSet(integer: Int(self.safariPageController.numberOfPages)), animated: false) { () -> Void in
            self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages )
        }
        
    }
    // like name of functon
    func numberOfPages(in pageController: SCSafariPageController!) -> UInt {
        return UInt(self.dataSource.count)
    }
    // custom page
    func pageController(_ pageController: SCSafariPageController!, viewControllerForPageAt index: UInt) -> UIViewController! {
        
        var viewController = self.dataSource[Int(index)]

        if viewController == nil {
            viewController = ViewController()
            viewController?.delegate = self
            self.dataSource[Int(index)] = viewController
        }

        viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: false)

        return viewController
    }
 
    //hàm kéo qua phải để xoá
    func pageController(_ pageController: SCSafariPageController!, willDeletePageAt pageIndex: UInt) {
        
        if pageIndex != 0
        {
            self.dataSource.remove(at: Int(pageIndex))
            
        }
        else{
            self.dataSource.insert(nil, at: Int(self.safariPageController.numberOfPages))
            self.safariPageController.insertPages(at: IndexSet(integer: Int(self.safariPageController.numberOfPages)), animated: false) { () -> Void in
                self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages )
            }
            self.dataSource.remove(at: Int(pageIndex))
            mDone.alpha = 0
            zoomButton.alpha = 1
        }
        
        
    }
    
    // MARK: SCViewControllerDelegate
    
    func viewControllerDidReceiveTap(_ viewController: ViewController) {
        if !self.safariPageController.isZoomedOut {
            return
        }

        let pageIndex = self.dataSource.firstIndex{$0 === viewController}

        self.toggleZoomWithPageIndex(UInt(pageIndex!))
    }
    
    func viewControllerDidRequestDelete(_ viewController: ViewController) {
        
        let pageIndex = self.dataSource.firstIndex{$0 === viewController}!
        if pageIndex == 0
        {
            self.dataSource.insert(nil, at: Int(self.safariPageController.numberOfPages))
            self.safariPageController.insertPages(at: IndexSet(integer: Int(self.safariPageController.numberOfPages)), animated: false) { () -> Void in
                self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages )
            }
            self.dataSource.remove(at: Int(pageIndex))
             self.safariPageController.deletePages(at: IndexSet(integer: pageIndex), animated: true, completion: nil)
            mDone.alpha = 0
            zoomButton.alpha = 1
            
        }else{
            self.dataSource.remove(at: pageIndex)
            self.safariPageController.deletePages(at: IndexSet(integer: pageIndex), animated: true, completion: nil)
            
        }

     
    }
    
    // MARK: Private
    
    fileprivate func toggleZoomWithPageIndex(_ pageIndex:UInt) {
        if self.safariPageController.isZoomedOut {
            self.safariPageController.zoomIntoPage(at: pageIndex, animated: true, completion: nil)
        } else {
            self.safariPageController.zoomOut(animated: true, completion: nil)
        }
        
        for viewController in self.dataSource {
            viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: true)
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.addButton.alpha = (self.safariPageController.isZoomedOut ? 1.0 : 0.0)
            self.mBack.alpha = (self.safariPageController.isZoomedOut ? 0.0 : 1.0)
            self.mNext.alpha = (self.safariPageController.isZoomedOut ? 0.0 : 1.0)
           
            
            
        })
    }
    
    // func zoonbutton
    @IBAction fileprivate func onZoomButtonTap(_ sender: Any) {
          NotificationCenter.default.post(name: NSNotification.Name.zoomBrowser, object: nil)
        self.zoomButton.isEnabled = true
        self.toggleZoomWithPageIndex(self.safariPageController.currentPage)
        
        NotificationCenter.default.post(name: NSNotification.Name.hideBrowser, object: nil)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
             self.zoomButton.alpha = 0
            self.mDone.alpha = 1
        })
//        UIApplication.shared.statusBarView?.backgroundColor = Color.navBgColor
    }
    
    @IBAction func onBtnDone(_ sender: Any) {

        NotificationCenter.default.post(name: NSNotification.Name.doneBrowser, object: nil)
        self.toggleZoomWithPageIndex(self.safariPageController.currentPage)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.zoomButton.alpha = 1
            self.mDone.alpha = 0
        })
    }
    
    
    @IBAction fileprivate func onBtnBack(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.backBrowser, object: nil)
    }
    @IBAction fileprivate func onBtnNext(_ sender: UIButton) {
         NotificationCenter.default.post(name: NSNotification.Name.nextBrowser, object: nil)
    }
    @IBAction fileprivate func onAddButtonTap(_ sender: Any) {
        self.zoomButton.isEnabled = true
        self.mBack.isEnabled = true
        self.mNext.isEnabled = true
        self.dataSource.insert(nil, at: Int(self.safariPageController.numberOfPages))
        self.safariPageController.insertPages(at: IndexSet(integer: Int(self.safariPageController.numberOfPages)), animated: true) { () -> Void in
            self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages )
        }
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.zoomButton.alpha = 1
            self.mDone.alpha = 0
            
        })
        
        
    }
    
   

}
