//
//  PasswordKeeperViewController.swift
//  SecretVault
//
//  Created by 5K on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import GoogleMobileAds

class PasswordKeeperViewController: BaseViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    //
    //varible
    var index: IndexPath!
    public var arrData : Array<String> = Array()
    var dbtable : DBPassword!
    var datalist:Results<PasswordKeeper>!
    var dataID : Array<String>!
    var data : String?
    var nameee : String?
    var fif : Character?
    var c = 0
    var Done = 1
    var loop = 0
    var flag = 1
    var string: String?
    var Select : Bool = true
    var carousel : Bool = true
    //xoay vòng khi ta ấn nút Edit lần 2. Lần 1 thì cho chọn nhiều, lần 2 thì cho chọn vào trong nội dung
    var editmore : Bool = false
    var DeleteOne : Bool = true
    var arrDict : [String] = []
    var avenvalue : [String] = []
    var firstIndex : String?
    var str : Character?
    var arrDataCha : [Character] = []
    public var arrSectionsTitle = [String]()
    var arrDelete : Array<String> = Array()
    var arrDict2 : [String: [String]] = [:]
    var characterA : [String] = []
    var characterE : [String] = []
    var characterO : [String] = []
    var characterI : [String] = []
    var characterU : [String] = []
    var characterSpecial : [String] = []
    
    //banner ads
    var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupCell()
        configNavigationBar()
        SelectAll()
        SetupSection()
        registerNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datalist = dbtable.getDataTable()
        setDataTableView()
        self.mTableView.reloadData()
        btnDelete.isHidden = true
        if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
            self.displayBanner()
        }
    }
    
    func displayBanner() {
        bannerView.adUnitID = StringConstants().Banner_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    //overide setupViews from baseviewcontroller
    override func setupViews() {
        super.setupViews()
        
        btnAdd.setBackgroundImage(UIImage(named: "password_add"), for: .normal)
        
        btnDelete.setTitle("Delete", for: .normal)
        btnDelete.backgroundColor = Color.denableButtonColor
        btnDelete.tintColor = Color.yellowButtonColor
        
        mTableView.backgroundColor = Color.blackBgColor
        mTableView.separatorColor = .clear
        
        self.view.backgroundColor = Color.blackBgColor
        
        //
        
    }
    
    //overide setupContraints from baseviewController
    override func setupConstraints() {
        super.setupConstraints()
        
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        
        btnDelete.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        btnAdd.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -77).isActive = true
        
        //btnDelete
        btnDelete.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        btnDelete.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //btnAdd
        btnAdd.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17).isActive = true
        btnAdd.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btnAdd.heightAnchor.constraint(equalTo: btnAdd.widthAnchor, multiplier: 1).isActive = true
        
        
        //banner view
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    //overide setupData from baseviewcontroller
    override func setupData() {
        super.setupData()
        
        //list section
        arrDict2 = ["A" : [], "B" : [], "C" : [], "D" : [], "E" : [], "F" : [], "G" : [], "H" : [], "I" : [], "J" : [], "K" : [], "L" : [], "M" : [], "N" : [], "O" : [], "P" : [], "Q" : [], "R" : [], "S" : [], "T" : [], "U" : [], "V" : [], "W" : [], "X" : [], "Y" : [], "Z" : [], "#" : [] ]
        
        //list special section
        characterA = [ "Ạ", "Á", "À", "Ả", "Ã", "Â", "Ậ", "Ấ", "Ầ", "Ẩ", "Ẫ", "Ă", "Ặ", "Ắ", "Ằ", "Ẳ", "Ẵ"  ]
        characterE = ["É", "È", "Ẻ", "Ẽ", "Ê", "Ế", "Ệ"]
        characterO = ["Ọ", "Ó", "Ò", "Ỏ", "Õ", "Ô", "Ộ", "Ố", "Ồ", "Ơ", "Ớ", "Ờ", "Ợ", "Ỡ"]
        characterI = ["Í", "Ì", "Ị", "Ĩ"]
        characterU = ["Ú", "Ù", "Ụ", "Ủ", "Ũ", "Ư", "Ứ", "Ừ", "Ự", "Ử", "Ữ"]
        characterSpecial = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "{", "}", "[", "]", "|", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "~", "`", "-", "+", "=", ";", ":", "?", "/", ">", "<", ",", ".", "'", ""]
        
        //data for table view
        setDataTableView()
    }
    
    func setDataTableView(){
        dbtable = DBPassword.Instance
        datalist = dbtable.getDataTable()
        for i in 0..<datalist.count {
            arrData.append(datalist[i].mName ?? "")
        }
    }
    
    // Notification
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: NSNotification.Name.Password, object: nil)
    }
    
    @objc func receiveNotification(notification:Notification){
        debugPrint("receive from B")
        if let value = notification.object as? String{
            debugPrint("DATA from B: \(value)")
        }
        else{
            debugPrint("no object")
        }
        removeData()
        createarrDict()
        mTableView.reloadData()
    }
    
    //button back for navigation
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: UIImage(named: "password_back"), style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //button edit for navigation
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didEditButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    
    //navigation
    func configNavigationBar() {
        self.navigationItem.title               = StringConstants.titleNavPassword
        self.navigationItem.leftBarButtonItem   = backBarButton
        self.navigationItem.rightBarButtonItem  = editBarButton
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
        let cellxib = UINib.init(nibName: "PasswordKeeperTableCell", bundle: nil)
        mTableView.register(cellxib, forCellReuseIdentifier: "PasswordKeeperTableCell")
    }
    
    //
    func SelectAll() {
        mTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    //
    func removeData() {
        //clear
        arrDict.removeAll()
        arrData.removeAll()
        arrDataCha.removeAll()
        for i in datalist {
            arrData.append(i.mName!)
            if (i.mName == " " || i.mName == nil) && i.mPassword != "" {
                arrData.append(i.mPassword!)
            }
        }
        arrData.sort()
        //xoá trùng lặp
        arrData = removeDuplicates(array: arrData)  //okokok
        //xoá khoảng trắng đầu
        var n = 0
        for u in arrData{
            arrData[n] = removeNilString(old: u)
            n = n + 1
        }
        n=0
    }
    
    func remove1(index: Int){
        for i in datalist {
            arrData.append(i.mName!)
            if (i.mName == " " || i.mName == nil) && i.mPassword != "" {
                arrData.append(i.mPassword!)
            }
        }
        arrData.sort()
        //xoá trùng lặp
        arrData = removeDuplicates(array: arrData)  //okokok
        //xoá khoảng trắng đầu
        var n = 0
        for u in arrData{
            arrData[n] = removeNilString(old: u)
            n = n + 1
        }
        n=0
    }
    
    // remove duplicates password
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
    
    //remove nil string
    func removeNilString(old: String)->String{
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
        // lọc xem có chữ cái nào trùng k,, trùng thì sẽ gộp còn 1
        arrDataCha.sort()
        let str = arrDataCha
        var set = Set<Character>()
        let squeezed = str.filter{ set.insert($0).inserted }
        //đưa vào arrDic
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
        // Xoá trùng lập
        arrDict = removeDuplicates(array: arrDict)
        //chuẩn hoá vị trí
        //tránh trường hợp xoá hết, ko có phần tử nào để mà chạy lệnh.
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
        //tránh xoá lầm
        arrData.sort()
        datalist = datalist.sorted(byKeyPath: "mName")
        arrSectionsTitle = arrDict
        addArrData2()
    }
    //
    func initArrDict() {
        arrDict2.removeAll()
        arrDict2 = ["A" : [], "B" : [], "C" : [], "D" : [], "E" : [], "F" : [], "G" : [], "H" : [], "I" : [], "J" : [], "K" : [], "L" : [], "M" : [], "N" : [], "O" : [], "P" : [], "Q" : [], "R" : [], "S" : [], "T" : [], "U" : [], "V" : [], "W" : [], "X" : [], "Y" : [], "Z" : [], "#" : [] ]
    }
    //
    func addArrData2() {
        initArrDict()
        //add data arrData
        for i in arrDict2 {
            for n in arrData {
                if n != "" {
                    if i.key == "A"{
                        for t in characterA{
                            if t == String(n.uppercased().first!){
                                arrDict2["A"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "E"{
                        for t in characterE{
                            if t == String(n.uppercased().first!){
                                arrDict2["E"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "O"{
                        for t in characterO{
                            if t == String(n.uppercased().first!){
                                arrDict2["O"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "I"{
                        for t in characterI{
                            if t == String(n.uppercased().first!){
                                arrDict2["I"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "U"{
                        for t in characterU{
                            if t == String(n.uppercased().first!){
                                arrDict2["U"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if i.key == "#"{
                        
                        for t in characterSpecial{
                            if t == String(n.first!){
                                arrDict2["#"]?.append(n)
                                Done = 2
                            }
                        }
                    }
                    if String(n.uppercased().first!) == "Đ" && i.key == "D"{
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
        debugPrint(arrData)
    }
    //
    func SelectDeleteContact() {
        //mTableView.allowsMultipleSelectionDuringEditing = true
    }
    // Thêm
    @IBAction func addPassword(_ sender: Any) {
        let updateScreen = ChangePasswordKeeperViewController()
        self.navigationController?.pushViewController(updateScreen, animated: true)
    }
    // Xoá
    @IBAction func deletePassword(_ sender: Any) {
        //alert
        let alertController = UIAlertController(title: "Nofitication!!", message: "Do you want to delete!!!", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            
            NSLog("OK Pressed")
            
            let selectedRows = self.mTableView.indexPathsForSelectedRows
            if selectedRows != nil {
                for var selectionIndex in selectedRows! {
                    self.tableView(self.mTableView, commit: .delete, forRowAt: selectionIndex)
                    self.flag = 2
                }
                //làm lại data
                self.removeData()
                self.createarrDict()
                self.mTableView.reloadData()
            }
            if self.datalist.count == 0 {
                self.btnDelete.isEnabled = false
            }
            self.setEditing(false, animated: true)   //ko cho sửa
            self.Select = true               //đc chọn cell đó
            // lblDelete.isEnabled = true //để ẩn đi, ko đc xoá
            self.carousel = true               //cho lần sau
            self.DeleteOne = true
            self.editBarButton.title = "Edit"
            self.btnDelete.isHidden = true
            self.btnAdd.isHidden = false
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

extension PasswordKeeperViewController {
    
    @objc func didBackButtonChecked() {
        let window = AppDelegate.shared.window
        window?.rootViewController = HomeView()
        window?.makeKeyAndVisible()
    }
    @objc func didEditButtonChecked() {
        if carousel == true && datalist.count > 0 {
            setEditing(true, animated: true)    //cho phép sửa
            Select = false
            btnDelete.isHidden = false//ko đc chọn vào cell đó
            btnDelete.isEnabled = false //cho việc xoá
            carousel = false            //cho lần sau
            DeleteOne = false
            editBarButton.title = "Done"
            btnAdd.isHidden = true
        } else {
            setEditing(false, animated: true)   //ko cho sửa
            Select = true               //đc chọn cell đó
            // lblDelete.isEnabled = true //để ẩn đi, ko đc xoá
            carousel = true               //cho lần sau
            DeleteOne = true
            editBarButton.title = "Edit"
            btnDelete.isHidden = true
            btnAdd.isHidden = false
        }
        return
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mTableView.setEditing(editing, animated: true)
    }
}

extension PasswordKeeperViewController: UITableViewDataSource, UITableViewDelegate, InfoPasswordDelegate {
    
    func didEditButtonChecked1(model: PasswordKeeper) {
        let updateScreen = ChangePasswordKeeperViewController()
        updateScreen.isEditmode = true
        updateScreen.currentPassword = datalist[c]
        self.navigationController?.pushViewController(updateScreen, animated: true)
        updateScreen.title = "Edit"
        mTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let avenkey = arrSectionsTitle[section]
        guard let avenValue = arrDict2[avenkey] else { return 0}
        return avenValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mTableView.dequeueReusableCell(withIdentifier: "PasswordKeeperTableCell", for: indexPath) as! PasswordKeeperTableCell
        // "A" "B" "C "
        let avenKey = arrSectionsTitle[indexPath.section]
        //Lấy dữ liệu trong mảng 2 chiều so vs 1 chiều
        if let avenValue = arrDict2[avenKey]{
            cell.mName.text = avenValue[indexPath.row]
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView    = backgroundView
        cell.tintColor                 = Color.yellowTextColor
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDict.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrDict[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Color.Sectionbackgroud
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor            = Color.SectionTextColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let Cell = mTableView.cellForRow(at: indexPath) as? ContactTableViewCell {
            Cell.lblView.backgroundColor = Color.ColorText
            Cell.View.backgroundColor    = Color.ColorView
        }
        c = 0
        //lấy name
        //lấy section
        let avenKey = arrSectionsTitle[indexPath.section]
        let avenValue = arrDict2[avenKey]
        let names = avenValue![indexPath.row]
        for i in datalist{
            if (i.mName == " " || i.mName == nil) && i.mPassword != ""{
                string = removeNilString(old: i.mPassword!)
            }else {
                string = removeNilString(old: i.mName!)
            }
            if string == names{
                break
            }
            c = c + 1
        }
        if Select == true{
            let updateScreen = InfoPasswordKeeperViewController()
            updateScreen.model = datalist[c]
            // "A" "B" "C "
            let avenKey = arrSectionsTitle[indexPath.section]
            //Lấy dữ liệu trong mảng 2 chiều so vs 1 chiều
//            if let avenValue = arrDict2[avenKey] {
//                let STR = "\(String(describing: avenValue[indexPath.row].first!))".uppercased()
//                updateScreen.mName = STR
//            }
            self.navigationController?.pushViewController(updateScreen, animated: true)
            updateScreen.delege = self as? InfoPasswordDelegate // Coi lại
        }
        btnDelete.isEnabled = true

        let selectedRows = self.mTableView.indexPathsForSelectedRows
        if selectedRows == nil {
            if selectedRows?.count ?? 2 > 1
            {
                btnDelete.isEnabled = true
            }
            else
            {
                btnDelete.isEnabled = true
            }
            
        }
    }
    // Xoá trượt
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            //lấy section
            let avenKey = arrSectionsTitle[indexPath.section]
            let avenValue = arrDict2[avenKey]
            //debugPrint(avenValue[indexPath.row])
            let names = avenValue![indexPath.row]
    
            //xoá dữ liệu phải để trước tất cả, hoặc sẽ bị crach
            for i in datalist{
                if (i.mName == " " || i.mName == nil) && i.mPassword != "" {
                    string = removeNilString(old: i.mPassword!)
                } else {
                    string = removeNilString(old: i.mName!)
                }
                if string == names{
                    
                    self.dbtable.removeOnePassword(id_Password: i.ID!)
                     if DeleteOne == true {
                     self.removeData()
                     self.createarrDict()
                     self.mTableView.reloadData()
                    }
                }
            }
            debugPrint(arrDict)
//            if UserDefaults.standard.value(forKey: UserDefaultKey.purchased) == nil{
//                IntersititialController.sharedInstance.showIntersititial()
//            }
            self.mTableView.reloadData()
        }
        
        if datalist.count > 0 {
            btnDelete.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedRows = self.mTableView.indexPathsForSelectedRows
        if selectedRows == nil {
            btnDelete.isEnabled = false
        }
    }
}

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func removeFirstElementEqual(to element: Element) -> Element? {
        guard let index = firstIndex(of: element) else { return nil }
        return remove(at: index)
    }
}


