//
//  PhotoVaultViewController.swift
//  SecretVault
//
//  Created by User01 on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PhotoVaultViewController: BaseViewController, GADBannerViewDelegate {

    // MARK : PROPERTIES
    @IBOutlet weak var btnPhotoVault: UIButton!
    @IBOutlet weak var btnFileImport: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRename: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    //banner ads
    var bannerView: GADBannerView!
    
    var isEditMode:Bool = false // Chuyển màn hình
    var numberimage:Int?
    var arrCountItem = Array<Int>()
    var isAdding = false
    var countAdd = 0
    
    // Mang chu nhung folder khong can thiet
    let arrAlbumWantToRemove = [".DS_Store", "default.realm", "default.realm.lock", "default.realm.management", "default.realm.note", "fileimport"]
    
    // Init backbarbutton
    lazy var backBarButton: UIBarButtonItem = {
        // button edit
        let barButtonItem  = UIBarButtonItem(image: Constants.ImagePhotoVault.defaultBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    // Init editBarbutton
    lazy var editBarButton: UIBarButtonItem = {
        // button edit
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
   
    var arrAlbum = Array<String>() // mảng chứa tên album folder
    var arrSelectedNameAlbum = Array<String>() // Mảng lưu giá trị của folder khi chọn dòng để xoá
    var arrSelectedAlbum = Array<IndexPath>()  // mangr lưu giá trị indexpath khi chọn album để xoá
    
    var iscarousel : Bool = true // Biến kiểm tra có click vào edit hay không
  //  var isSelect : Bool = true // Biến không được chọn vào cell
    // MARK : VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        arrCountItem.removeAll()
        getCountItem()
        mTableView.reloadData()
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    func displayBanner() {
                bannerView.adUnitID = StringConstants().Banner_ID
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    
    // SetupViews
    override func setupViews() {
        super.setupViews()
        
        print("\(NSHomeDirectory())/Documents")
        configNavigationBar()
        setupUIComponent()
        setupUITableView()
        showListAlbum()
      //  arrCountItem.removeAll()
      //  getCountItem()
       // mTableView.reloadData()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.CreateAndRenameAlbum, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(self.renamePhotoDone), name: NSNotification.Name.isRenamePhotoDone, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.isAddNumberAlbumPhoto), name: NSNotification.Name.isAddNumberPhoto, object: nil)
//         NotificationCenter.default.addObserver(self, selector: #selector(self.cancelRenamePhoto), name: NSNotification.Name.isDissmissAlertEditAlbum, object: nil)
        
    }
     // MARK : METHODS
    // Confignavitaion Bar (Item)
    func configNavigationBar()
    {
        self.navigationItem.title = StringConstants.titleNavPhotoVault
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    
    // Setup UI Button
    func setupUIComponent()
    {
        // Hình tròn
        btnAdd.layer.cornerRadius = btnAdd.frame.size.width / 2
        
        // Btn Sáng , màu vàng
        btnPhotoVault.backgroundColor = Color.enableButtonColor
        btnPhotoVault.tintColor = Color.yellowTextColor
        
        // Btn tối đi và màu gray
        btnFileImport.backgroundColor = Color.denableButtonColor
        btnFileImport.tintColor = Color.grayTextColor
        
        // Background mTableView
        mTableView.backgroundColor = .black
        
        // Button Rename and Delete
        btnRename.backgroundColor = Color.denableButtonColor
        btnRename.tintColor = Color.grayTextColor
        btnRename.layer.cornerRadius = Constants.Radius.defaultButtonRadius
        btnRename.isHidden = true
        btnDelete.backgroundColor = Color.denableButtonColor
        btnDelete.tintColor = Color.grayTextColor
        btnDelete.layer.cornerRadius = Constants.Radius.defaultButtonRadius
        btnDelete.isHidden = true
    }
    func setupUITableView()
    {
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.separatorColor = .clear
        // SignUp Xib
        let xib = UINib(nibName: "PhotoVaultTableViewCell", bundle: nil)
        mTableView.register(xib, forCellReuseIdentifier: "PhotoVaultTableViewCell")
        // Dấu tròn click vào
        mTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func getCountItem(){
        //arrCountItem.removeAll()
        let fm = FileManager.default
        for i in 0..<arrAlbum.count {
            let documents2 = String.init(format: "%@/Documents/\(arrAlbum[i])", NSHomeDirectory())
            var items2 = try! fm.contentsOfDirectory(atPath: documents2)
//            items2 = items2.filter(){$0 != ".DS_Store"}
//            items2 = items2.filter(){$0 != "fileimport"}
//            items2 = items2.filter(){$0 != "default.realm"}
//            items2 = items2.filter(){$0 != "default.realm.lock"}
            if items2.count > 0 {
                for i in 0..<arrAlbumWantToRemove.count {
                    items2 = items2.filter(){$0 != arrAlbumWantToRemove[i]}
                }
            }
            arrCountItem.append(items2.count)
        }
    }
    
    func showListAlbum()
    {
      //  arrCountItem.removeAll()
      //  mTableView.reloadData()
        let fm = FileManager.default
        let documents = String.init(format: "%@/Documents/", NSHomeDirectory())
        let items = try! fm.contentsOfDirectory(atPath: documents)
        arrAlbum = items
        if arrAlbum.count > 0 {
            for i in 0..<arrAlbumWantToRemove.count {
                arrAlbum = arrAlbum.filter(){$0 != arrAlbumWantToRemove[i]}
            }
        }
//        arrAlbum = items.filter(){$0 != ".DS_Store"}
//        arrAlbum = items.filter(){$0 != "fileimport"}
//        arrAlbum = items.filter(){$0 != "default.realm"}
//        arrAlbum = items.filter(){$0 != "default.realm.lock"}

//
//        print("doc item \(items)")
//        print("11111111111111111111\(NSHomeDirectory())")
        
        arrAlbum = arrAlbum.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        
        

    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mTableView.setEditing(editing, animated: true)
        
    }
    // update new
    @objc func renamePhotoDone() {
        showListAlbum()
        arrCountItem.removeAll()
        self.mTableView.reloadData()
        getCountItem()
        didEditButtonChecked()
    }
    @objc func isAddNumberAlbumPhoto() {
       // arrCountItem.removeAll()
        //showListAlbum()
        showListAlbum()
        arrCountItem.removeAll()
        self.mTableView.reloadData()
        getCountItem()
    }
    
//    @objc func cancelRenamePhoto() {
//        showListAlbum()
//        self.mTableView.reloadData()
//        didEditButtonChecked()
//    }

    @objc func refresh() {
        showListAlbum()
        self.mTableView.reloadData()
        //didEditButtonChecked()
    }
    

    @objc func  didBackButtonChecked(){
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    @objc func didEditButtonChecked(){
        if iscarousel == true
        {
            setEditing(true, animated: true)
            isEditMode = true
            editBarButton.title = "Done"
            btnRename.isHidden = false
            
            btnDelete.isHidden = false
            
            btnRename.isEnabled = false
            btnDelete.isEnabled = false
            btnRename.tintColor = Color.yellowTextColor
            btnDelete.tintColor = Color.yellowTextColor
//            btnRename.backgroundColor = Color.enableButtonColor
//            btnDelete.backgroundColor = Color.enableButtonColor
            btnAdd.isHidden = true
            iscarousel = false
        }
        else {
            setEditing(false, animated: true)
            editBarButton.title = "Edit"
            isEditMode = false
            btnDelete.isHidden = true
            btnRename.isHidden = true
            btnAdd.isHidden = false
            iscarousel = true
        }
        
        
    }
    func ReadFile(name:String) -> String{
//        if let path = titleNavAlbum {
//            arrImage.removeAll()
            let fm = FileManager.default
            let documents = String.init(format: "%@/Documents/\(name)", NSHomeDirectory())
            let items = try! fm.contentsOfDirectory(atPath: documents)
            let temp = items.filter(){$0 != ".DS_Store"}
        return temp[0]
//            arrImage = arrImage.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        }
    
    func getDocumentsDicretory() -> URL {
        let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func RemoveAlbum(nameFolder:String)
    {
        let documents = String.init(format: "%@/Documents/", NSHomeDirectory())
        let pathFolder = documents + nameFolder
        do{
            try FileManager.default.removeItem(atPath: pathFolder)
        }catch{
            debugPrint("CANNOT REMOVE FOLDER")
        }
    }
    @IBAction func btnPhotoVault(_ sender: Any) {
    }
    
    @IBAction func btnFileImport(_ sender: Any) {
        let categoriesVC = FileScreenViewController.loadFromNib()
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
    
    @IBAction func btnAdd(_ sender: Any) {
        let alertCreateAlbum = AlertPhotoViewController()
        countAdd = countAdd + 1
        alertCreateAlbum.modalTransitionStyle = .crossDissolve
        alertCreateAlbum.modalPresentationStyle = .overCurrentContext
        alertCreateAlbum.TextLabel = "Create New Album"
        alertCreateAlbum.isAdd = true
        alertCreateAlbum.count = countAdd
        self.present(alertCreateAlbum, animated: true, completion: nil)
        //mTableView.reloadData()
        
        
    }
    
    
    
    @IBAction func btnRename(_ sender: Any) {
        let alertRename = AlertPhotoViewController()
        var temp = ""
        if let selectedRows = mTableView.indexPathsForSelectedRows{
            for indexPath in selectedRows {
                temp = arrAlbum[indexPath.row]
            }
        alertRename.modalTransitionStyle = .crossDissolve // hien thi o giữa vị trí ban đầu
        alertRename.modalPresentationStyle = .overCurrentContext
        alertRename.TextLabel = "Rename"
        alertRename.isAdd = false
        alertRename.currentName = temp
        print(temp)
        self.present(alertRename, animated: true, completion: nil)
    }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
       
       if let selectedRows = mTableView.indexPathsForSelectedRows{
         for indexPath in selectedRows {
            arrSelectedNameAlbum.append(arrAlbum[indexPath.row])
            RemoveAlbum(nameFolder: arrAlbum[indexPath.row])
        }
        for item in arrSelectedNameAlbum {
            if let index = arrAlbum.index(of: item) {
                arrAlbum.remove(at: index)
            }
        }
        mTableView.deleteRows(at: selectedRows, with: UITableView.RowAnimation.automatic)
        arrSelectedNameAlbum.removeAll()
        arrCountItem.removeAll()
        mTableView.reloadData()
        getCountItem()
        self.didEditButtonChecked() // quay lại chế độ ban đầu
        }
    }
}
extension PhotoVaultViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // Đổ cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("cell for row at")
        let cell = mTableView.dequeueReusableCell(withIdentifier: "PhotoVaultTableViewCell") as! PhotoVaultTableViewCell
        cell.lblAlbum.text = arrAlbum[indexPath.row]
        cell.lblNumberphoto.text = String(arrCountItem[indexPath.row]) + " photo"
        if arrCountItem[indexPath.row] == 0 {
            cell.imgAlbum.image = UIImage(named: "Unknown")
        } else {
            let name = ReadFile(name: arrAlbum[indexPath.row])
            let path  = getDocumentsDicretory().appendingPathComponent(arrAlbum[indexPath.row]).appendingPathComponent(name)
            print("pạtttttttttt\(path)")
            cell.imgAlbum.image = UIImage(contentsOfFile: path.path)
            
        }
        let backgroundView = UIView()
        // Icon click
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.tintColor = Color.yellowTextColor
       
        return cell
    }
    
    
    // Click Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDelete.isEnabled = true
        btnRename.isEnabled = true
        

        if isEditMode == true {
            let selectedRows = self.mTableView.indexPathsForSelectedRows
            if selectedRows!.count > 1
            {
                btnRename.isEnabled = false
                btnRename.backgroundColor = Color.denableButtonColor
                
                
            }
            else if selectedRows!.count == 1 {
                btnRename.isEnabled = true
                btnDelete.backgroundColor = Color.enableButtonColor
                btnRename.backgroundColor = Color.enableButtonColor
            }
        } else {
            // Chuyển màn hình
            let albumScreen = PhotoAlbumViewController()
            let name = mTableView.cellForRow(at: indexPath) as! PhotoVaultTableViewCell
            albumScreen.titleNavAlbum = name.lblAlbum.text
            navigationController?.pushViewController(albumScreen, animated: true)
//            albumScreen.btnRecover.isHidden = true
//            albumScreen.btnMove.isHidden = true
//            albumScreen.btnDelete.isHidden = true
          //  print("Chuyển màn hình tại đây")
        }
       
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedRows = self.mTableView.indexPathsForSelectedRows
        if selectedRows == nil {
            btnRename.isEnabled = false
            btnDelete.isEnabled = false
            btnDelete.backgroundColor = Color.denableButtonColor
            btnRename.backgroundColor = Color.denableButtonColor
            
        }
       else  if selectedRows!.count > 1
        {
            btnRename.isEnabled = false
        }
        else  if selectedRows!.count == 1{
            btnRename.isEnabled = true
            btnRename.backgroundColor = Color.enableButtonColor
        }
        
    }
}

