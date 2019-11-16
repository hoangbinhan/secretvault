//
//  SettingViewController.swift
//  testSetting
//
//  Created by 5K on 8/22/19.
//  Copyright © 2019 5K. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import GoogleMobileAds

class SettingViewController: UIViewController, GADBannerViewDelegate {

    //Outlet button
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var btnRemoveAds: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnRateOnReview: UIButton!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var btnShareApp: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    
    //outlet label
    @IBOutlet weak var lblRemoveAds: UILabel!
    @IBOutlet weak var lblRestorePurchase: UILabel!
    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var lblRateOnReview: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblShareApp: UILabel!
    @IBOutlet weak var lblFeedBack: UILabel!
    //bannerview
    var bannerView: GADBannerView!
    
    // product for purchase, remove ads
    var p = SKProduct()
    var list = [SKProduct]()
    var checkPIs = false
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
            self.setupRemoveAds()
        } else {
            lblRemoveAds.textColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            lblRestorePurchase.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            if !self.checkPIs{
                self.setupRemoveAds()
            }
        } else {
            lblRemoveAds.textColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            lblRestorePurchase.textColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    

    //setupUI
    private func setupUI(){
        
        //
        if self.navigationController == nil {
            return
        }
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = StringConstants.titleNavSetting
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = .center
        label.textColor = Color.yellowTextColor

    
        // Add both the label and image view to the navView
        navView.addSubview(label)
        var btn =  UIBarButtonItem.init(image: UIImage(named: "Arrow Left 3"), style: .plain, target: self, action: #selector(self.action(sender:)))
        btn.tintColor = Color.yellowTextColor
       
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        self.navigationItem.leftBarButtonItem = btn
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
        //reset password
        btnResetPassword.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnResetPassword.clipsToBounds = true
        btnResetPassword.backgroundColor = Color.navBgColor
        lblResetPassword.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        //remove ads
        btnRemoveAds.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnRemoveAds.clipsToBounds = true
        btnRemoveAds.backgroundColor = Color.navBgColor
        lblRemoveAds.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        //restore purchase
        btnRestore.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnRestore.clipsToBounds = true
        btnRestore.backgroundColor = Color.navBgColor
        lblRestorePurchase.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        //rate on view
        btnRateOnReview.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnRateOnReview.clipsToBounds = true
        btnRateOnReview.backgroundColor = Color.navBgColor
        lblRateOnReview.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        //feedback
        btnFeedback.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnFeedback.clipsToBounds = true
        btnFeedback.backgroundColor = Color.navBgColor
        lblFeedBack.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        //share app
        btnShareApp.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnShareApp.clipsToBounds = true
        btnShareApp.backgroundColor = Color.navBgColor
        lblShareApp.font = Font.font(size: 17, weight: UIFont.Weight.regular)
        
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        //privacy policy
        btnPrivacyPolicy.layer.cornerRadius = Constants.Radius.defaultButtonHomeRadius
        btnPrivacyPolicy.clipsToBounds = true
        btnPrivacyPolicy.backgroundColor = Color.navBgColor
    }

    //
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    //reset password
    @IBAction func ResetPassword(_ sender: Any) {
        
        let alert = UIAlertController(title: "Change Your Password", message: "You will set your new password. Are you sure ?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in

            // let viewB = MainCalculator()

            let viewB = MainCalculator.loadFromNib()
            // thực hiện thay đổi pass
            viewB.changePass = true
            viewB.passTime = 1
            viewB.firstTime = true
            viewB.previousNum = 0
            viewB.currentNumber = 0
            //chuyển màn hình
            let window = AppDelegate.shared.window
            window?.rootViewController = viewB
            window?.makeKeyAndVisible()

            //            self.navigationController?.pushViewController(viewB, animated: true)


        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    //remove ads
    @IBAction func RemoveAds(_ sender: Any) {
        
        tapRemoveAds()
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) != nil{
            self.bannerView.isHidden = true
            btnRemoveAds.isEnabled = false
            btnRestore.isEnabled = true
            lblRemoveAds.textColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            lblRestorePurchase.textColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            //alert successful
            let alert = UIAlertController.init(title: "Nofitication", message: "Remove Ads successful!\n Reopen for seen result", preferredStyle: .alert)
            let btnOK = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //restore purchase
    @IBAction func RestorePurchase(_ sender: Any) {
        tapRestore()
    }
    
    //rate on review
    @IBAction func RateOnReView(_ sender: Any) {
        
        openLinkOutsideApp(link: StringConstants().link_app_to_rate)
    }
    
    //feedback
    @IBAction func Feedback(_ sender: Any) {
        
         sendFeedback()
    }
    
    //share app
    @IBAction func ShareApp(_ sender: Any) {
        
        shareAppWithLink()
    }

    //privacy policy
    @IBAction func PrivacyPolicy(_ sender: Any) {
        
        openLinkOutsideApp(link: StringConstants().link_app_to_policy)
        
    }
}




//extension: function for setting
extension SettingViewController {
    //
    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    //feedback
    func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let appname = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            mail.setSubject("Feedback - \(appname)")
            mail.setToRecipients([StringConstants().email_recevie_feeback])
            self.present(mail, animated: true, completion: nil)
            
        } else {
            // show failure alert
            let alert = UIAlertController(title: "Notify", message: "Not found email source", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    //share app
    func shareAppWithLink(){
        let share = UIActivityViewController(activityItems: [StringConstants().link_app_to_share], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
    }
    
    //open link outside app
    func openLinkOutsideApp(link:String){
        if let url = URL.init(string: link){
            UIApplication.shared.open(url, options: [:], completionHandler: {(result) in
                if result {
                    print("Success")
                } else {
                    print("Failed")
                }
            })
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            let alert = UIAlertController(title: "Notify", message: "Error", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert,animated: true, completion: nil)
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}


//remove ads (inapp)
extension SettingViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Product request")
        let myProduct = response.products
        
        for prod in myProduct{
            print("Product added")
            print(prod.productIdentifier)
            print(prod.localizedTitle)
            print(prod.localizedDescription)
            print(prod.price)
            
            list.append(prod)
        }
        
    }
    
    //payment  
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions{
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState{
            case .purchased:
                print("buy ok")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID{
                case StringConstants().pID:
                    print("remove ads")
                    removeAds()
                default:
                    print("IAP not found")
                }
            queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                //queue.finishTransaction(trans)
                break
            }
        }
    }
    
    func removeAds() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.purchased)
        self.bannerView.isHidden = true
    }
    
    func setupRemoveAds() {
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: StringConstants().pID)
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
            self.checkPIs = true
        } else {
            self.checkPIs = false
            print("please enable IAPS")
        }
    }
    
    func buyProduct() {
        
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
    }
    func tapRemoveAds(){
        for product in list {
            
            let prodID = product.productIdentifier
            if(prodID == StringConstants().pID) {
                p = product
                buyProduct()
            }
        }
    }
    func tapRestore(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}



