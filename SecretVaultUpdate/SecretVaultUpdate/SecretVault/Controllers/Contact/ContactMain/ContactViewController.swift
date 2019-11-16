//
//  ContactViewController.swift
//  SecretVault
//
//  Created by Đặng Ngọc Đại on 8/28/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import RealmSwift
import Contacts
import ContactsUI
import GoogleMobileAds
import NVActivityIndicatorView
class ContactViewController: BaseViewController, GADBannerViewDelegate {
    
    //MARK: ---PROPERTIES---
    @IBOutlet weak var handleView  : UIView!
    @IBOutlet weak var mTableView  : UITableView!
    @IBOutlet weak var handleImport: UIImageView!
    @IBOutlet weak var handleAdd   : UIImageView!
    @IBOutlet weak var btnDelete   : UIButton!
    @IBOutlet weak var lblHandleAdd: UIButton!
    @IBOutlet weak var btnhandle1  : UIButton!
    @IBOutlet var selectHandle     : [UIButton]!
    //Varible
    var Done = 1
    var loop = 0
    var flag = 1
    var c    = 0
    var indexP = 0
    //
    public var arrData : Array<String> = Array()
    var dbdanhbatable  : DBBDanhba!
    var datalist       : Results<Danhba2>!
    var dataID         : Array<String>!
    var arrDelete      : Array<String> = Array()
    //
    var email      : String?
    var url        : String?
    var data       : String?
    var nameee     : String?
    var string     : String?
    var firstIndex : String?
    //
    var fif        : Character?
    var str        : Character?
    // Rotate when we press the Edit button for the second time. For the first time, we can select many times, the second time we will select the content
    var editmore  : Bool = false
    var Select    : Bool = true
    var carousel  : Bool = true
    //false = more, true = one
    var DeleteOne : Bool = true
    //
    var arrDict          : [String] = []
    var avenvalue        : [String] = []
    var characterA       : [String] = []
    var characterE       : [String] = []
    var characterO       : [String] = []
    var characterI       : [String] = []
    var characterU       : [String] = []
    var characterSpecial : [String] = []
    var arrDict2         : [String: [String]] = [:]
    var arrDataCha       : [Character] = []
    var arrSec: Array<Int> = []
    
    //banner ads
    var bannerView: GADBannerView!
    
    //
    public var arrSectionsTitle = [String]()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupCell()
        configNavigationBar()
        SelectAll()
        registerNotification()
        
        debugPrint("view did load................................")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SetupSection()
        datalist = dbdanhbatable.getDataTable()
        btnDelete.isHidden = true
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    func showLoadinga() {
        let activityData = ActivityData(type: .ballClipRotate)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    func stopLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    @IBAction func btnAddContact(_ sender: Any) {
        let updateScreen = ContactUpdateViewController()
        self.navigationController?.pushViewController(updateScreen, animated: true)
    }
    @IBAction func btnImportContact(_ sender: Any) {
        let enti     = CNEntityType.contacts
        let austatus = CNContactStore.authorizationStatus(for: enti)
        self.showLoadinga()
        if austatus  == CNAuthorizationStatus.notDetermined{
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: enti) { (success, nil) in
                if success {
                    self.openContact()
                }else {
                    print("Not Not")
                }
            }
        }
        else if austatus == CNAuthorizationStatus.authorized {
            self.openContact()
        }
    }
    //
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.Image.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem       = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    func configNavigationBar() {
        self.navigationItem.title               = StringConstants.titleNavContact
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
    }
    //
    func initArrDict() {
        arrDict2.removeAll()
        arrDict2 = ["A" : [], "B" : [], "C" : [], "D" : [], "E" : [], "F" : [], "G" : [], "H" : [], "I" : [], "J" : [], "K" : [], "L" : [], "M" : [], "N" : [], "O" : [], "P" : [], "Q" : [], "R" : [], "S" : [], "T" : [], "U" : [], "V" : [], "W" : [], "X" : [], "Y" : [], "Z" : [], "#" : [] ]
    }
    //
    override func setupData() {
        super.setupData()
        arrDict2   = ["A" : [], "B" : [], "C" : [], "D" : [], "E" : [], "F" : [], "G" : [], "H" : [], "I" : [], "J" : [], "K" : [], "L" : [], "M" : [], "N" : [], "O" : [], "P" : [], "Q" : [], "R" : [], "S" : [], "T" : [], "U" : [], "V" : [], "W" : [], "X" : [], "Y" : [], "Z" : [], "#" : [] ]
        characterA = [ "Ạ", "Á", "À", "Ả", "Ã", "Â", "Ậ", "Ấ", "Ầ", "Ẩ", "Ẫ", "Ă", "Ặ", "Ắ", "Ằ", "Ẳ", "Ẵ"  ]
        characterE = ["É", "È", "Ẻ", "Ẽ", "Ê", "Ế", "Ệ"]
        characterO = ["Ọ", "Ó", "Ò", "Ỏ", "Õ", "Ô", "Ộ", "Ố", "Ồ", "Ơ", "Ớ", "Ờ", "Ợ", "Ỡ"]
        characterI = ["Í", "Ì", "Ị", "Ĩ"]
        characterU = ["Ú", "Ù", "Ụ", "Ủ", "Ũ", "Ư", "Ứ", "Ừ", "Ự", "Ử", "Ữ"]
        characterSpecial = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "{", "}", "[", "]", "|", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "~", "`", "-", "+", "=", ";", ":", "?", "/", ">", "<", ",", ".", "'", ""]
        dbdanhbatable = DBBDanhba.Instance
        datalist      = dbdanhbatable.getDataTable()
        for i in 0..<datalist.count {
            arrData.append(datalist[i].mName ?? "")
        }
    }
    override func setupViews() {
        super.setupViews()
        if self.navigationController == nil {
            return
        }
        // Create a navView to add to the navigation bar
        let navView = UIView()
        // Create the label
        let label   = UILabel()
        label.text  = StringConstants.titleNavContact
        label.sizeToFit()
        label.center        = navView.center
        label.textAlignment = .center
        label.textColor     = Color.yellowTextColor
        // Add both the label and image view to the navView
        navView.addSubview(label)
        let btn = backBarButton
        btn.tintColor = Color.yellowTextColor
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView         = navView
        self.navigationItem.leftBarButtonItem = btn
        navView.sizeToFit()
        //
        mTableView.separatorColor  = .clear
        mTableView.backgroundColor = Color.blackBgColor
        handleView.backgroundColor = Color.ColorText1
        btnDelete.backgroundColor  = Color.enableButtonColor
        btnDelete.tintColor        = Color.yellowButtonColor
        
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        btnDelete.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        btnDelete.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            btnDelete.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        } else {
            btnDelete.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
    }
    //
    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        let window = AppDelegate.shared.window
        window?.rootViewController = ContactViewController()
        window?.makeKeyAndVisible()
    }
    //
    func SetupSection() {
        removeData()
        createarrDict()
        mTableView.reloadData()
    }
    //
    func SetupCell()
    {
        mTableView.dataSource = self
        mTableView.delegate   = self
        let cellxib = UINib.init(nibName: "ContactTableViewCell", bundle: nil)
        mTableView.register(cellxib, forCellReuseIdentifier: "ContactTableViewCell")
    }
    //
    func SelectAll() {
        mTableView.allowsMultipleSelectionDuringEditing = true
        lblHandleAdd.setImage(UIImage(named: "normal"), for: .normal)
    }
    // Notification
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: NSNotification.Name.Contact, object: nil)
    }
    @objc func receiveNotification(notification:Notification){
        debugPrint("Receive from B")
        if let value = notification.object as? String{
            debugPrint("DATA from B: \(value)")
        }
        else{
            debugPrint("No object")
        }
        removeData()
        createarrDict()
        mTableView.reloadData()
    }
    func removeData() {
        //clear
        arrDict.removeAll()
        arrData.removeAll()
        arrDataCha.removeAll()
        for i in datalist {
            arrData.append(i.mName!)
            if (i.mName == " " || i.mName == nil) && i.mMobile != "" {
                arrData.append(i.mMobile!)
            }
        }
        arrData.sort()
        // Delete duplicate
        arrData = removeDuplicates(array: arrData)  //okokok
        // Remove leading space
        var n = 0
        for u in arrData {
            arrData[n] = removeNilString(old: u)
            n = n + 1
        }
        n = 0
    }
    func removeData1() {
        //clear
        arrDict.removeAll()
        arrData.removeAll()
        arrDataCha.removeAll()
        for i in datalist {
            arrData.append(i.mName!)
            if (i.mName == " " || i.mName == nil) && i.mMobile != "" {
                arrData.append(i.mMobile!)
            }
        }
        arrData.sort()
        // Delete duplicate
        arrData = removeDuplicates(array: arrData)  //okokok
        // Remove leading space
        var n = 0
        for u in arrData {
            arrData[n] = removeNilString(old: u)
            n = n + 1
        }
        n = 0
    }
    //
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    //
    func removeNilString(old: String)->String {
        var result : String?
        result = old
        // Phát hiện nil
        if old.first == " "
        {
            result = old.replacingCharacters(in: ...old.startIndex, with: "")
        }
        //trả về kết quả, hoặc giá trị ko đổi
        return result ?? old
    }
    //
    func createarrDict()
    {
        for i in arrData{
            if i != "" {
                for u in characterSpecial{
                    if String(i.first!) == u {
                        arrDataCha.append("#")
                    }
                    else if String(i.uppercased().first!) == "Đ"{
                        arrDataCha.append("D")
                    }else{
                        let str1 = i.uppercased().first!
                        // lấy chữ cái đầu bỏ vào mảng
                        arrDataCha.append(str1)
                    }
                }
            }
        }
        // Filter to see if there are any matches for k ,, concurrently, it will include 1
        arrDataCha.sort()
        let str = arrDataCha
        var set = Set<Character>()
        let squeezed = str.filter{ set.insert($0).inserted }
        // Put in arrDic
        for n in squeezed {
            if n != "#" {
                let ABC : String = "\(n)"
                arrDict.append(ABC.uppercased())
            } else if n == "#"{
                let ABC : String = "\(n)"
                arrDict.append(ABC)
            }
        }
        arrDict.sort()
        // Delete duplicates
        arrDict = removeDuplicates(array: arrDict)
        // Normalize position
        // Void deletion, there are no elements to run the command from.
        loop = 0
        if arrDict.count > 0 {
            while loop <= datalist.count + 1 {
                for m in characterSpecial{
                    
                    if arrDict[0] == m  && arrDict[0] != "#" {
                        
                        arrDict.removeFirstElementEqual(to: m)
                    }
                    if arrDict[0] == "#" {
                        arrDict.removeFirstElementEqual(to: "#")
                        arrDict.append("#")
                    }
                }
                loop = loop + 1
            }
        }
        // Void deleting
        arrData.sort()
        datalist         = datalist.sorted(byKeyPath: "mName")
        //debugPrint(datalist)
        arrSectionsTitle = arrDict
        addArrData2()
    }
    
    //
    func addArrData2() {
        initArrDict()
        //add data arrData
        for i in arrDict2 {
            for n in arrData {
                if n != "" {
                    if i.key == "A" {
                        for t in characterA {
                            if t == String(n.uppercased().first!) {
                                arrDict2["A"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "E" {
                        for t in characterE {
                            if t == String(n.uppercased().first!) {
                                arrDict2["E"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "O" {
                        for t in characterO {
                            if t == String(n.uppercased().first!) {
                                arrDict2["O"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "I" {
                        for t in characterI {
                            if t == String(n.uppercased().first!) {
                                arrDict2["I"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "U" {
                        for t in characterU {
                            if t == String(n.uppercased().first!) {
                                arrDict2["U"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "#" {
                        
                        for t in characterSpecial {
                            if t == String(n.first!) {
                                arrDict2["#"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if String(n.uppercased().first!) == "Đ" && i.key == "D" {
                        arrDict2["D"]?.append(n)
                    }
                    if Done == 1 {
                        if i.key == String(n.uppercased().first!) || i.key == String(n.lowercased().first!)
                        {
                            arrDict2[i.key]?.append(n)
                        }
                    }
                }
            }
            Done = 1
        }
       // debugPrint(arrData)
    }
    
    @IBAction func handleSelect(_ sender: UIButton) {
        selectHandle.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.handleView.isHidden = !self.handleView.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func btnHandelImport(_ sender: Any) {
        selectHandle.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.handleView.isHidden = !self.handleView.isHidden
                self.view.layoutIfNeeded()
                self.lblHandleAdd.setBackgroundImage( UIImage(named: "normal"), for: .normal)
            })
        }
    }
    @IBAction func btnHandleAddContact(_ sender: Any) {
        selectHandle.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.handleView.isHidden = !self.handleView.isHidden
                self.view.layoutIfNeeded()
                self.lblHandleAdd.setBackgroundImage( UIImage(named: "normal"), for: .normal)
            })
        }
    }
    
    @IBAction func btnHandleAdd(_ sender: Any) {
        if lblHandleAdd.currentBackgroundImage == UIImage(named: "normal-1")
        {
            lblHandleAdd.setImage(nil, for: .normal)
            lblHandleAdd.setBackgroundImage( UIImage(named: "normal"), for: .normal)
        }
        else
        {
            lblHandleAdd.setImage(nil, for: .normal)
            lblHandleAdd.setBackgroundImage( UIImage(named: "normal-1"), for: .normal)
        }
    }
    // Xoá chọn nhiều
    @IBAction func btnDelete(_ sender: Any) {
        //Alert
        let alertController = UIAlertController(title: "Notification!!", message: "You want to delete !! Are you sure??", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let selectedRows = self.mTableView.indexPathsForSelectedRows
            if selectedRows != nil {
                for selectionIndex in selectedRows! {
                    self.tableView(self.mTableView, commit: .delete, forRowAt: selectionIndex)
                    self.flag = 2
                }
                // Redo data
                self.removeData()
                self.createarrDict()
                self.mTableView.reloadData()
                self.indexP = 0
            }
            if self.datalist.count > 0
            {
                self.btnDelete.isEnabled = false
            }
            self.setEditing(false, animated: true)
            self.Select    = true
            self.carousel  = true
            self.DeleteOne = true
            self.editBarButton.title   = "Edit"
            self.btnDelete.isHidden    = true
            self.lblHandleAdd.isHidden = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension ContactViewController: UITableViewDataSource, UITableViewDelegate, ContacttableviewDelega, UITextFieldDelegate {
    func didEditButtonChecked1(model: Danhba2) {
        let updateScreen           = ContactUpdateViewController()
        updateScreen.isEditmode    = true
        updateScreen.currentDanhba = datalist[c]
        self.navigationController?.pushViewController(updateScreen, animated: true)
        updateScreen.title = "Edit Contact"
        mTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDict.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrDict[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let avenkey = arrSectionsTitle[section]
        guard let avenValue = arrDict2[avenkey] else { return 0}
        return avenValue.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrSectionsTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Color.Sectionbackgroud
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor            = Color.SectionTextColor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mTableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as!
        ContactTableViewCell
        // "A" "B" "C "
        let avenKey = arrSectionsTitle[indexPath.section]
        // Get data in a 2-dimensional array vs 1 dimension
        if let avenValue = arrDict2[avenKey] {
            cell.lblName.text   = avenValue[indexPath.row]
            let STR = "\(String(describing: avenValue[indexPath.row].first!))".uppercased()
            cell.lblNameST.text = STR
        }
        // Change color when didselect in swift
        let backgroundView = UIView()
        cell.lblView.backgroundColor   = Color.ColorText
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView    = backgroundView
        cell.tintColor                 = Color.yellowTextColor
        for i in 0..<datalist.count {
            if let fname = datalist[i].mFirst {
                let name = datalist[i].mName
                if name  == cell.lblName.text {
                    let img = datalist[i].mHinh
                    cell.imgHinh.image = img?.toImage()
                    if img != nil {
                        cell.lblNameST.text = ""
                    }
                }
            }
        }
        //--add
        for i in 0..<datalist.count {
            let fname = datalist[i].mFirst ?? ""
            let lname = datalist[i].mLast ?? ""
            let name  = fname + lname
            if name   == cell.lblName.text {
                let img = datalist[i].mHinh
                cell.imgHinh.image = img?.toImage()
                if let img1 = img {
                    cell.lblNameST.text = ""
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change color when didSelect
        if let Cell = mTableView.cellForRow(at: indexPath) as? ContactTableViewCell {
            Cell.lblView.backgroundColor = Color.ColorText
            Cell.View.backgroundColor    = Color.ColorView
        }
        // Reassign the value
        c = 0
        // Get name
        // Get section
        let avenKey   = arrSectionsTitle[indexPath.section]
        let avenValue = arrDict2[avenKey]
        let names     = avenValue![indexPath.row]
        for i in datalist {
            if (i.mName == " " || i.mName == nil) && i.mMobile != "" {
                string  = removeNilString(old: i.mMobile!)
            }else {
                string  = removeNilString(old: i.mName!)
            }
            if string   == names {
                break
            }
            c = c + 1
        }
        if Select == true {
            let updateScreen     = ContactInfomationViewController()
            //debugPrint(datalist[c].mHinh)
            if let img = datalist[c].mHinh {
                updateScreen.hinh = img
            }
            //updateScreen.mHinh.setImage(datalist[c].mHinh!.toImage(), for: .normal)
            updateScreen.mname   = datalist[c].mName
            updateScreen.mmobile = datalist[c].mMobile
            updateScreen.mhome   = datalist[c].mHome
            updateScreen.mwork   = datalist[c].mWork
            updateScreen.murl    = datalist[c].mURL
            updateScreen.memail  = datalist[c].mEmail
            updateScreen.mnote   = datalist[c].mNote
            // "A" "B" "C "
            let avenKey = arrSectionsTitle[indexPath.section]
            // Get data in a 2-dimensional array vs 1 dimension
            if let avenValue = arrDict2[avenKey] {
                let STR = "\(String(describing: avenValue[indexPath.row].first!))".uppercased()
                updateScreen.mnameLabel = STR
            }
            self.navigationController?.pushViewController(updateScreen, animated: true)
            updateScreen.delege = self
            updateScreen.model  = datalist[indexPath.row]
        }
        btnDelete.isEnabled = true
        let selectedRows    = self.mTableView.indexPathsForSelectedRows
        if selectedRows     == nil
        {
            if selectedRows?.count ?? 2 > 1
            {
                btnDelete.isEnabled = true
            }
            else
            {
                btnDelete.isEnabled = true
            }
            btnDelete.isEnabled     = true
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedRows = self.mTableView.indexPathsForSelectedRows
        if selectedRows == nil
        {
            if selectedRows?.count ?? 2 > 1
            {
                btnDelete.isEnabled = true
            }
            else
            {
                btnDelete.isEnabled = true
            }
            btnDelete.isEnabled     = false
        }
    }
    // Xoá trượt
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            //Get section
            let avenKey   = arrSectionsTitle[indexPath.section]
            let avenValue = arrDict2[avenKey]
            let names     = avenValue![indexPath.row]
            // Deleting data must be before all, or will be crach
            for i in datalist{
                if (i.mName == " " || i.mName == nil) && i.mMobile != "" {
                    string = removeNilString(old: i.mMobile!)
                } else {
                    string = removeNilString(old: i.mName!)
                }
                if string == names {
                    self.dbdanhbatable.removeOneSanPham(id_SanPham: i.ID!)
                }
                if DeleteOne == true {
                    self.removeData1()
                    self.createarrDict()
                    self.mTableView.reloadData()
                }
            }
           // debugPrint(arrDict)
        }
        if datalist.count == 0
        {
            btnDelete.isEnabled = false
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mTableView.setEditing(editing, animated: true)
    }
    @objc func didBackButtonChecked() {
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    @objc func didEditButtonChecked() {
        if carousel == true && datalist.count > 0
        {
            // Allow to fix
            setEditing(true, animated: true)
            Select    = false
            // For next time
            carousel  = false
            //
            DeleteOne = false
            // Not selected into that cell
            btnDelete.isHidden    = false
            // For deletion
            btnDelete.isEnabled   = false
            editBarButton.title   = "Done"
            lblHandleAdd.isHidden = true
        } else {
            setEditing(false, animated: true)
            Select    = true
            carousel  = true
            DeleteOne = true
            editBarButton.title   = "Edit"
            btnDelete.isHidden    = true
            lblHandleAdd.isHidden = false
        }
        return
    }
}
extension ContactViewController : CNContactPickerDelegate {
    func openContact() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion:
        {
            self.stopLoading()
        })
    }
    // select and done
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        for contact in contacts {
            // User name
            let userName:String = contact.givenName
            // User phone number
            var userPhoneNumbers  : [CNLabeledValue<CNPhoneNumber>]?
            let firstPhoneNumber  : CNPhoneNumber?
            var secondPhoneNumber : CNPhoneNumber?
            var threadPhoneNumber : CNPhoneNumber?
            // Get Phonenumber
            if contact.phoneNumbers.count > 0 {
                // user phone number
                userPhoneNumbers  = contact.phoneNumbers
                firstPhoneNumber  = userPhoneNumbers?[0].value
            }else {
                // user phone number
                userPhoneNumbers  = contact.phoneNumbers
                firstPhoneNumber  = CNPhoneNumber(stringValue: "")
            }
            // Get phoneHome
            if contact.phoneNumbers.count > 1 {
                userPhoneNumbers  = contact.phoneNumbers
                secondPhoneNumber = userPhoneNumbers?[1].value
            }
            else {
                userPhoneNumbers  = contact.phoneNumbers
                secondPhoneNumber = CNPhoneNumber(stringValue: "")
            }
            // Get phoneWork
            if contact.phoneNumbers.count > 2 {
                userPhoneNumbers  = contact.phoneNumbers
                threadPhoneNumber = userPhoneNumbers?[2].value
            }
            else {
                userPhoneNumbers  = contact.phoneNumbers
                threadPhoneNumber = CNPhoneNumber(stringValue: "")
            }
            // Mobile
            let primaryPhoneNumberStr : String = firstPhoneNumber?.stringValue  ?? ""
            // Home
            let primaryHome           : String = secondPhoneNumber?.stringValue ?? ""
            // Work
            let primaryWork           : String = threadPhoneNumber?.stringValue ?? ""
            //FamilyName
            let FamilyName:String = contact.familyName
            //print(FamilyName)
            let note : String     = contact.note
            // Get The Email
            for mail in contact.emailAddresses {
                email = mail.value as String
            }
            for ul in contact.urlAddresses {
                url   = ul.value as String
            }
            // Save to realm
            let danhba = Danhba2()
            danhba.mName    = userName + " " + FamilyName
            danhba.mFirst   = userName
            danhba.mLast    = FamilyName
            danhba.mEmail   = email
            danhba.mURL     = url
            danhba.mHome    = primaryHome
            danhba.mWork    = primaryWork
            danhba.mMobile  = primaryPhoneNumberStr
            danhba.mNote    = note
            DBBDanhba.Instance.insertOneSanPham(object: danhba)
            // Reset email and url
            email = ""
            url   = ""
        }
        //Create section, add data
        SetupSection()
    }
}

extension String {
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    }
}

//extension RangeReplaceableCollection where Element: Equatable {
//    @discardableResult
//    mutating func removeFirstElementEqual(to element: Element) -> Element? {
//        guard let index = firstIndex(of: element) else { return nil }
//        return remove(at: index)
//    }
//}
// Convert text to image
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}
// Convert image to text
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
