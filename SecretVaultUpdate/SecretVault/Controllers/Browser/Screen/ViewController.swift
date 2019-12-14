//
//  ViewController.swift
//  BrowserSafari
//
//  Created by TKapps_01 on 8/13/19.
//  Copyright © 2019 TKapps_01. All rights reserved.
//

import UIKit
import WebKit





extension UIViewController {
    func HideKeyBoard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DissmissKeyBoard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DissmissKeyBoard(){
        view.endEditing(true)
    }
}



@objc protocol ViewControllerDelegate {
    @objc optional func viewControllerDidReceiveTap(_ viewController:ViewController)
    @objc optional func viewControllerDidRequestDelete(_ viewController:ViewController)
    
}



class ViewController: UIViewController , UITextFieldDelegate , WKNavigationDelegate ,RootDelegate , WKUIDelegate {
    
  
    
    // property
    var progBar = UIProgressView()
    
    @IBOutlet weak var mDeleteTextFile: UIButton!
    @IBOutlet weak var mDelete: UIButton!
    @IBOutlet weak var mHome: UIButton!
    var delegate:ViewControllerDelegate?
    @IBOutlet weak var mWebView: WKWebView!
    @IBOutlet weak var mTextField: UITextField!
 
    var headerVisible:Bool = false
     let button = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgress()
        //
          mTextField.keyboardType = .webSearch
        self.HideKeyBoard()
        //
        setupButtonDeleteTextField()
        //
        addButtonOnTextField()
        //
        setupNotificationCenter()
        //
        setupViewBackground()
        //
        setupTapGesture()
        //
        setupUI()
        // func load google làm mặc định
        load(link: "https://www.google.com")
        // call to use func in textField and Webkit
        mTextField.delegate = self
        mWebView.navigationDelegate = self
        

    }
    //setupUI
    func setupUI() {
        switch UIDevice.current.userInterfaceIdiom {
           case .phone:
                      //TextField
                      mTextField.translatesAutoresizingMaskIntoConstraints = false
                      mTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                      mTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -9).isActive = true
                      mTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
                      mTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
                      //Delete
                      mDelete.translatesAutoresizingMaskIntoConstraints = false
                      mDelete.trailingAnchor.constraint(equalTo: self.mTextField.leadingAnchor, constant: -1).isActive = true
                      mDelete.heightAnchor.constraint(equalToConstant: 20).isActive = true
                      mDelete.widthAnchor.constraint(equalToConstant: 20).isActive = true
                      mDelete.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true
                      //Home
                      mHome.translatesAutoresizingMaskIntoConstraints = false
                      mHome.trailingAnchor.constraint(equalTo: self.mTextField.leadingAnchor, constant: -9).isActive = true
                      mHome.heightAnchor.constraint(equalToConstant: 22).isActive = true
                      mHome.widthAnchor.constraint(equalToConstant: 23).isActive = true
                      mHome.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true
                      //WEBVIEW
                      mWebView.translatesAutoresizingMaskIntoConstraints = false
                      mWebView.topAnchor.constraint(equalTo: self.mTextField.bottomAnchor, constant: 9.5).isActive = true
                      mWebView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                      mWebView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                      mWebView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 557/675).isActive = true
                     //Delete TextFiel
                      mDeleteTextFile.translatesAutoresizingMaskIntoConstraints = false
                      mDeleteTextFile.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                      mDeleteTextFile.widthAnchor.constraint(equalToConstant: 15).isActive = true
                      mDeleteTextFile.heightAnchor.constraint(equalToConstant: 15).isActive = true
                      mDeleteTextFile.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true

           default:
               //TextField
                mTextField.translatesAutoresizingMaskIntoConstraints = false
                mTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 110).isActive = true
                mTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -9).isActive = true
                mTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
                mTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
                //Delete
                mDelete.translatesAutoresizingMaskIntoConstraints = false
                mDelete.trailingAnchor.constraint(equalTo: self.mTextField.leadingAnchor, constant: -1).isActive = true
                mDelete.heightAnchor.constraint(equalToConstant: 20).isActive = true
                mDelete.widthAnchor.constraint(equalToConstant: 20).isActive = true
                mDelete.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true
                //Home
                mHome.translatesAutoresizingMaskIntoConstraints = false
                mHome.trailingAnchor.constraint(equalTo: self.mTextField.leadingAnchor, constant: -9).isActive = true
                mHome.heightAnchor.constraint(equalToConstant: 22).isActive = true
                mHome.widthAnchor.constraint(equalToConstant: 23).isActive = true
                mHome.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true
                //WEBVIEW
                mWebView.translatesAutoresizingMaskIntoConstraints = false
                mWebView.topAnchor.constraint(equalTo: self.mTextField.bottomAnchor, constant: 9.5).isActive = true
                mWebView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                mWebView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                mWebView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 600/675).isActive = true
               //Delete TextFiel
                mDeleteTextFile.translatesAutoresizingMaskIntoConstraints = false
                mDeleteTextFile.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                mDeleteTextFile.widthAnchor.constraint(equalToConstant: 15).isActive = true
                mDeleteTextFile.heightAnchor.constraint(equalToConstant: 15).isActive = true
                mDeleteTextFile.centerYAnchor.constraint(equalTo: self.mTextField.centerYAnchor).isActive = true
            
           }
       
    }
    
    //setupTapGesture
    func setupTapGesture() {
        // when we click on textField then it will show for you
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:)))
        view.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:)))
        mTextField.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:)))
        mWebView.addGestureRecognizer(tapGesture2)
        // beacause in textfield can't use touch up inside so i use this func to do
        mTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
    }
    // set up view background
    func setupViewBackground() {
        // custom backgroundColor for View
        view.backgroundColor = Color.navBgColor
        //
        mDeleteTextFile.alpha = 0
        //mặc định khi chạy nút delete sẽ ẩn
        mDelete.alpha = 0
    }
    //set up NotificationCenter
    func setupNotificationCenter() {
        // pass data between two VC
        NotificationCenter.default.addObserver(self, selector: #selector(self.onBackButtonTap), name: NSNotification.Name.backBrowser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onNextButtonTap), name: NSNotification.Name.nextBrowser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideButton), name: NSNotification.Name.hideBrowser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDoneButtonTap), name: NSNotification.Name.doneBrowser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onZoomButtonTap), name: NSNotification.Name.zoomBrowser, object: nil)
       
    }
    // addButtonOnTextField
    func addButtonOnTextField() {
        // add button in textfield
        button.setImage(UIImage(named: "Shape 4"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(mTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(13), height: CGFloat(13.5))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        mTextField.rightView = button
        mTextField.rightViewMode = .always
    }
    //setupButtonDeleteTextField
    func setupButtonDeleteTextField() {
        //custom button mDeleteTextFile
        mDeleteTextFile.layer.cornerRadius = mDeleteTextFile.frame.size.width / 2
        mDeleteTextFile.clipsToBounds = true
        mDeleteTextFile.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    // func setupProgress
    func setupProgress()
    {
        //set up progress (if you want to do it , you can search it by "estimatedProgress")
        progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        progBar.progress = 0.0
        progBar.tintColor = #colorLiteral(red: 0.1015306822, green: 0.3291102617, blue: 0.9686274529, alpha: 1)
        mWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        mWebView.addSubview(progBar)
    }
    //set up progress bar
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(mWebView.estimatedProgress), animated: true)
            if self.mWebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    () -> Void in self.progBar.alpha = 0.0
                }, completion:{ (finished :Bool) -> Void in self.progBar.progress = 0
                })
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        mWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
   func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
             self.DissmissKeyBoard()
       }
    // the textField will reload link on textField
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mTextField.text = mWebView.url?.absoluteString
        mDeleteTextFile.alpha = 0
        button.alpha = 1
        self.DissmissKeyBoard()
       
      
        
    }
    
    // khi chạm vào textField
    @objc func myTargetFunction(textField: UITextField) {
        button.alpha = 0
        mDeleteTextFile.alpha = 1
        mTextField.becomeFirstResponder()
        mTextField.keyboardType = .webSearch
        
    }
// fucn xoá url
    @IBAction func mDeleteTextFieldButtonTap(_ sender: Any) {
        mTextField.text = ""
        mDeleteTextFile.alpha = 0
        
    }
    
    //add button in text field
    @IBAction func refresh(_ sender: Any) {
        mWebView.reload()
 
    }
   

    // zoom
    @objc func onZoomButtonTap() {

        mDeleteTextFile.alpha = 0
        mTextField.isEnabled = false
        button.alpha = 0
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        self.view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.layer.borderWidth = 3
        //action of user on WebView or WebKit (true : user can action / false : user can't action)
        self.mWebView.isUserInteractionEnabled = false
        
        
        
    }
    //Done
    @objc func onDoneButtonTap() {
        mTextField.isEnabled = true
       self.mHome.alpha = 1
        self.mDelete.alpha = 0
        self.button.alpha = 1
        self.view.layer.cornerRadius = 0
        self.view.clipsToBounds = true
        self.view.layer.borderWidth = 0
        
        
    }
    //back
    @objc func onBackButtonTap() {
      if mWebView.canGoBack{
        mWebView.goBack()
        }
    }
    //next
    @objc func onNextButtonTap() {
        if mWebView.canGoForward{
            mWebView.goForward()
        }
    }
    // hide button
    @objc func hideButton() {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.mDelete.alpha  = 1
                    self.mHome.alpha = 0
                })
    }
 
    
    // button delete will show and action when we click button zoom
    
    @IBAction func btnDelete(_ sender: Any) {
    self.delegate?.viewControllerDidRequestDelete?(self)
        
    }
    // button come back to home
    @IBAction func btnDeleteTap(_ sender: Any) {
//        self.delegate?.viewControllerDidRequestDelete?(self)
        // func come back to home
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            IntersititialController.sharedInstance.showIntersititial()
        }
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    // func load first Link on WebKit
    func load(link : String)
    {
        
        if let url:URL = URL(string: link)
        {
        let request = URLRequest(url: url)
        mWebView.load(request)
        }
        else
        {
            print("Can't search UTF-8 🥰")
        }


    }

    // func of textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let link : String = mTextField.text!
        if (link.hasPrefix("http://") || link.hasPrefix("https://"))
        {
            load(link: link)
        }
        else
        {
            let temp = "http://\(link)"
            var f = false
            if let url = URL(string: temp){
                 f = UIApplication.shared.canOpenURL(url)
               
            }
            if (f == true && temp.hasSuffix(".com")||temp.hasSuffix(".vn")||temp.hasSuffix(".us")||temp.hasSuffix("gov.vn")||temp.hasSuffix("gov.us"))  {
                load(link: temp)
                debugPrint("this is true")
                debugPrint(temp)
            }
            else {
                // use escapedString to encode this link
                if let escapedString = link.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                    load(link: "https://www.google.com/search?query=\(escapedString)")
                }
                 debugPrint("not true")
            }
        }
        return true
    }
    
    func setHeaderVisible(_ visible:Bool, animated:Bool) {
        self.headerVisible = visible
        
        if self.isViewLoaded == false {
            return
        }
    }
 
    
    @objc func onBackgroundTap(_ tapGesture:UITapGestureRecognizer) {
        self.delegate?.viewControllerDidReceiveTap?(self)
        mTextField.isEnabled = true
        mDelete.alpha = 0
        mHome.alpha = 1
        self.view.layer.cornerRadius = 0
        self.view.clipsToBounds = true
        self.view.layer.borderWidth = 0
         NotificationCenter.default.post(name: NSNotification.Name.testBrowser, object: nil)
//        mTextField.text = ""
        //action of user on WebView or WebKit (true : user can action / false : user can't action)
        self.mWebView.isUserInteractionEnabled = true
        
        
        
    }

}

