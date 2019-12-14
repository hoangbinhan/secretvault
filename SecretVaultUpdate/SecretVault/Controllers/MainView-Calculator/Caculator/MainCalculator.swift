import UIKit
import SnapKit
import NVActivityIndicatorView
import LocalAuthentication

class MainCalculator: BaseViewController {
    
    // MARK: - Properties
    var progressView: NVActivityIndicatorView!
    //
    //UI
    @IBOutlet weak var displayNum: UILabel!
    //Button
    
    @IBOutlet weak var AC: UIButton!
    @IBOutlet weak var Equal: UIButton!
    @IBOutlet weak var Dot: UIButton!
    @IBOutlet weak var Zero: UIButton!
    @IBOutlet weak var Plus: UIButton!
    @IBOutlet weak var Three: UIButton!
    @IBOutlet weak var Two: UIButton!
    @IBOutlet weak var One: UIButton!
    @IBOutlet weak var Minus: UIButton!
    @IBOutlet weak var Six: UIButton!
    @IBOutlet weak var Five: UIButton!
    @IBOutlet weak var Four: UIButton!
    @IBOutlet weak var Multi: UIButton!
    @IBOutlet weak var Nine: UIButton!
    @IBOutlet weak var Eight: UIButton!
    @IBOutlet weak var Device: UIButton!
    @IBOutlet weak var PlusMinus: UIButton!
    @IBOutlet weak var Seven: UIButton!
    @IBOutlet weak var Device2: UIButton!
    //end Button
    
    var previousNum : Double = 0
    var currentNumber : Double = 0
    var preTag = "+"
    let tagList = ["+","-","*","/"]
    var modOccured = false
    var decimal : Bool = false
    
    var firstTime : Bool = true
    var changePass: Bool = false    //thay đổi password
    var pass : String?
    var passTime = 1
    var pass1 : String?
    var pass2 : String?
    var recentEqual = false
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupConstraints()
        self.setupData()
        setupUIButton()
        checkUserDefaults()
        print("sadssd \(NSHomeDirectory())")

    }
    
    @IBAction func longPressFingerAuthenticate(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            authenticateUsingTouchID()
        }
    }
    
    func authenticateUsingTouchID() {
        let authContext = LAContext()
        let authReason = "Please"
        var authError : NSError?
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError)
        {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: authReason, reply: {(success,error) -> Void in
                if success {
                    self.progressView.startAnimating()
                    Thread.mainAsyncAfter(delay: 1) { [weak self] in
                        self?.MoveScreen()
                    }
                }
            })
            
        }else {
            print(authError?.localizedDescription)
        }
    }
    
    func checkUserDefaults() {
        //set coi trước đó đã có tồn tại pass chưa
        if (UserDefaults.standard.value(forKey: "user.pass") as? String) != nil && changePass == false {
            //remove image
            Device.setImage(nil, for: .normal)
            Device.backgroundColor = UIColor(red:46/255, green:56/255, blue:74/255, alpha:1)
            
            firstTime = false //đã tồn tại
            //pass = UserDefaults.standard.value(forKey: "user.pass") as? String
            debugPrint("NO ")
            displayNum.text = "0"
            
        }else if (UserDefaults.standard.value(forKey: "user.pass") as? String) == nil || changePass == true {
            //chưa từng có pass
            displayNum.text = "0"
            //add image
            Device.backgroundColor = UIColor(named: "#0C0C0C")
            Device.setImage(UIImage(named: "Try"), for: UIControl.State.normal)
            
            //code hiển thị thông báo khi ta vào app
            let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
            topWindow?.rootViewController = UIViewController()
            topWindow?.windowLevel = UIWindow.Level.alert + 1
            let alert = UIAlertController(title: "Instructions", message: "Type in a password then '%' to continue \n\n Once password is confirmed, you will use '%' to gain access to your secret folder \n\n You can hold '%' to use TouchID, FaceID ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("I UNDERSTAND", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                // continue your work
                
                // important to hide the window after work completed.
                // this also keeps a reference to the window until the action is invoked.
                topWindow?.isHidden = true // if you want to hide the topwindow then use this
                //topWindow? = nil // if you want to hide the topwindow then use this
            }))
            topWindow?.makeKeyAndVisible()
            topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            // hết code
            
            firstTime = true   //chưa từng có password bao giờ
            passTime = 1
            debugPrint("Change Pass")
            
        }
    }
    func setupUIButton() {
        //UI
        PlusMinus.backgroundColor = Color.denableButtonColor
        Device.backgroundColor = Color.denableButtonColor
        AC.backgroundColor = Color.denableButtonColor
        Equal.backgroundColor = Color.denableButtonColor
        Dot.backgroundColor = Color.denableButtonColor
        One.backgroundColor = Color.denableButtonColor
        Two.backgroundColor = Color.denableButtonColor
        Three.backgroundColor = Color.denableButtonColor
        Four.backgroundColor = Color.denableButtonColor
        Five.backgroundColor = Color.denableButtonColor
        Six.backgroundColor = Color.denableButtonColor
        Seven.backgroundColor = Color.denableButtonColor
        Eight.backgroundColor = Color.denableButtonColor
        Nine.backgroundColor = Color.denableButtonColor
        Zero.backgroundColor = Color.denableButtonColor
        Device2.backgroundColor = Color.yellowButtonColor
        Multi.backgroundColor = Color.yellowButtonColor
        Minus.backgroundColor = Color.yellowButtonColor
        Plus.backgroundColor = Color.yellowButtonColor
        Equal.backgroundColor = Color.yellowButtonColor
        
        
        
        //
        AC.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        One.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Two.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Three.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Four.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Five.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Six.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Seven.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Eight.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Nine.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Zero.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        Dot.setTitleColor(Color.yellowTextColor, for: UIControl.State.normal)
        
        
        //Button
        AC.layer.cornerRadius = AC.frame.size.width/2
        Equal.layer.cornerRadius = AC.frame.size.width/2
        Dot.layer.cornerRadius = AC.frame.size.width/2
        Zero.layer.cornerRadius = AC.frame.size.width/2
        Plus.layer.cornerRadius = AC.frame.size.width/2
        Three.layer.cornerRadius = AC.frame.size.width/2
        Two.layer.cornerRadius = AC.frame.size.width/2
        One.layer.cornerRadius = AC.frame.size.width/2
        Minus.layer.cornerRadius = AC.frame.size.width/2
        Six.layer.cornerRadius = AC.frame.size.width/2
        Five.layer.cornerRadius = AC.frame.size.width/2
        Four.layer.cornerRadius = AC.frame.size.width/2
        Multi.layer.cornerRadius = AC.frame.size.width/2
        Nine.layer.cornerRadius = AC.frame.size.width/2
        Eight.layer.cornerRadius = AC.frame.size.width/2
        Device.layer.cornerRadius = AC.frame.size.width/2
        PlusMinus.layer.cornerRadius = AC.frame.size.width/2
        Seven.layer.cornerRadius = AC.frame.size.width/2
        Device2.layer.cornerRadius = AC.frame.size.width/2
        //End Button
    }
    
    deinit {
        // perform the deinitialization
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    // MARK: - Setup views
    override func setupViews() {
        super.setupViews()
        
        // Loading indicator
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.progressView = NVActivityIndicatorView(frame: frame,type: .circleStrokeSpin)
        self.progressView.color = .white
        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
    }
    
    override func setupData() {
        super.setupData()
        
    }
    //chuyển màn hình
    func MoveScreen() {
        let categoriesVC = HomeView.loadFromNib()
//        let mainNav = BaseNavigationController(rootViewController: categoriesVC)
        let window = AppDelegate.shared.window
        window?.rootViewController = categoriesVC
        window?.makeKeyAndVisible()
   
    }
    //hàm
    func password () {
        //ko sửa pass, là vào thẳng
        if displayNum.text == UserDefaults.standard.value(forKey: "user.pass") as? String {
            debugPrint("Confirm")  //gõ đúng pass
            //đổi qua màn hình khác
                    self.progressView.startAnimating()
                    Thread.mainAsyncAfter(delay: 1) { [weak self] in
                        self?.MoveScreen()
                    }
            //chuyển ngược lại
            // self.dismiss(animated: true, completion: nil)
        } else {
            //gõ sai pass
            //tính toán mạc định
            currentNumber = Double(displayNum.text!) ?? 0
            previousNum = currentNumber/100
            modOccured = true
            decimal = true
            
        }
        
    }
    
    // 1 -> 9 và 0, . Thay đổi passWord
    @IBAction func numButtonsPressed(_ sender: Any) {
        
        if (displayNum.text! == "Choose Password" || displayNum.text! == "Confirm Password" || displayNum.text! == "Enjoy :)" || displayNum.text! == "+" || displayNum.text! == "-" || displayNum.text! == "*" || displayNum.text! == "/" || displayNum.text! == "0" || modOccured ) && !((sender as AnyObject).tag == 0) && !((sender as AnyObject).tag==100){
            displayNum.text = String((sender as AnyObject).tag)
        }
        else if (sender as AnyObject).tag == 100 && !decimal{
            decimal = true
            displayNum.text = displayNum.text! + "."
        }
        else if !(displayNum.text! == "0") && !((sender as AnyObject).tag == 100){
            if recentEqual == true {
                displayNum.text = String((sender as AnyObject).tag)
                recentEqual = false
            } else {
            displayNum.text = displayNum.text! + String((sender as AnyObject).tag)
            }
        }
        
    }
    
    //các nút chức năng %, chia, nhân, trừ, cộng, bằng
    @IBAction func performOperation(_ sender: Any) {
        
        if previousNum==0 {
            previousNum = Double(displayNum.text!) ?? 0
            decimal = false
        }
        else{
            // decimal = true
            currentNumber = Double(displayNum.text!) ?? 0
            if preTag == "+"{
                previousNum += currentNumber
            }
            else if preTag == "-"{
                previousNum -= currentNumber
            }
            else if preTag == "*"{
                previousNum *= currentNumber
            }
            else if preTag == "/"{
                previousNum /= currentNumber
            }
           
        }
        
        if (sender as AnyObject).tag == 4{
            if firstTime == false {
                password()
            }
            else if firstTime == true && passTime == 1 {
                debugPrint("no pass")
                //chưa từng có password
                //cài pass mới
                pass1 = displayNum.text //lưu lần 1
                displayNum.text = "Confirm Password"
                passTime = 2    //chuyển qua giai đoạn 2
                //processPass = true
                return
                
            }
                //giai đoạn 2
            else if firstTime == true && passTime == 2 {
                
                if displayNum.text == pass1 {
                    //nếu nhập lại đúng pass trước đó
                    //thì cho lưu pass
                    UserDefaults.standard.setValue(pass1, forKey: "user.pass")  //lưu pass
                    UserDefaults.standard.synchronize()
                    debugPrint("Done")
                    Device.setImage(UIImage(named: "+"), for: UIControl.State.normal)
                    Device.backgroundColor = Color.navBgColor
                    
                    displayNum.text = "Enjoy :)"
                    
                    firstTime = false   //đã có pass
                    //donePass = true     //Đã xong pass
                    return
                } else {
                    //nhập sai
                    //processPass = false //ko cho nhập pass nữa
                    passTime = 1 //set laị lần 1
                    firstTime = true    //xem như chưa có pass
                    //tính toán mạc định
                    currentNumber = Double(displayNum.text!) ?? 0
                    previousNum = currentNumber/100
                    modOccured = true
                    decimal = true
                }
            } //kết thúc tạo pass mới
            //thay đổi password
        }
        
        if (sender as AnyObject).tag == 10 || (sender as AnyObject).tag == 4{
            decimal = true
            displayNum.text = String(previousNum)
            previousNum = 0
            preTag = "+"
            if (sender as AnyObject).tag == 10 {
                recentEqual = true
            }
        }
        else{
            displayNum.text = String(tagList[(sender as AnyObject).tag])
            preTag = tagList[(sender as AnyObject).tag]
        }
        
    }
    
    //xoá tất cả
    @IBAction func clearScreen(_ sender: Any) {
        displayNum.text = "0"
        previousNum = 0
        currentNumber = 0
        preTag = "+"
        modOccured = false
        decimal = false
    }
    
    
    @IBAction func invertnum(_ sender: Any) {
        
        currentNumber = Double(displayNum.text!) ?? 0
        currentNumber = -currentNumber
        displayNum.text = String(currentNumber)
        previousNum = currentNumber
    }
    
    
}


// MARK: -
extension MainCalculator {
    
}
