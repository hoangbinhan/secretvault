//
//  PhotoMoveAlbumViewController.swift
//  SecretVault
//
//  Created by User01 on 9/20/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit


class PhotoMoveAlbumViewController: BaseViewController {

    @IBOutlet weak var mTableView: UITableView!
    // Mảng chưa các album (folder từ bên dưới)
    var arrAlbumPhotoMove = Array<String>()
    // Mảng nhận hình ảnh url
    var arrPhotoMoveURL = Array<URL>()
    var pathPhotoMoveURL: URL?
    var arrPhotoNhanURL = Array<URL>()
    var pathPhotoNhanURL: URL?
    var arrCountItem = Array<Int>()
    var path:String? = nil
    var isMoveSingle:Bool = true
    
    // Mang chu nhung folder khong can thiet
    let arrAlbumWantToRemove = [".DS_Store", "default.realm", "default.realm.lock", "default.realm.management", "default.realm.note", "fileimport"]
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonChecked))
        barButtonItem.tintColor = Color.yellowTextColor
        return barButtonItem
    }()
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didBackButtonChecked))
        return barButtonItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrCountItem.removeAll()
        getCountItem()
        mTableView.reloadData()
    }
    override func setupViews() {
        super.setupViews()
       // debugPrint("đã nhận dữ liệu \(arrPhotoMoveURL)")
//        debugPrint("đã nhận dữ liệu \(pathPhotoMoveURL!)")
        configNavigationBar()
        setupUIComponent()
        setupUITableView()
        showListAlbum()
         NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.CreateAndRenameAlbum, object: nil)
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
    func getCountItem(){
        let fm = FileManager.default
        for i in 0..<arrAlbumPhotoMove.count {
            let documents2 = String.init(format: "%@/Documents/\(arrAlbumPhotoMove[i])", NSHomeDirectory())
            var items2 = try! fm.contentsOfDirectory(atPath: documents2)
            items2 = items2.filter(){$0 != ".DS_Store"}
            items2 = items2.filter(){$0 != "fileimport"}
            arrCountItem.append(items2.count)
        }
    }
    func showListAlbum() {
        let fm = FileManager.default
        let documents = String.init(format: "%@/Documents/", NSHomeDirectory())
        let items = try! fm.contentsOfDirectory(atPath: documents)
        print("items\(items)")
        arrAlbumPhotoMove = items
        if arrAlbumPhotoMove.count > 0 {
            for i in 0..<arrAlbumWantToRemove.count {
                arrAlbumPhotoMove = arrAlbumPhotoMove.filter(){$0 != arrAlbumWantToRemove[i]}
            }
        }

         arrAlbumPhotoMove = arrAlbumPhotoMove.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
        print("Mảng chưa đường dẫn Photomove \(arrAlbumPhotoMove)")
        for i in 0..<arrAlbumPhotoMove.count{
            let element = getDocumentsDicretory().appendingPathComponent(arrAlbumPhotoMove[i])
            arrPhotoNhanURL.append(element)
        }
        print("iiiiiiiiiiiiiiiiiiiiiiiii: \(arrPhotoNhanURL)")
    }
    
    func getDocumentsDicretory() -> URL {
        let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    @objc func refresh() {
        showListAlbum()
        self.mTableView.reloadData()
    }
    func configNavigationBar() {
        self.navigationItem.title = "Move to Album"
        self.navigationItem.rightBarButtonItem = cancelBarButton
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    func setupUIComponent() {
        mTableView.backgroundColor = .black
    }
    func setupUITableView() {
        mTableView.delegate = self
        mTableView.dataSource = self
        // đăng ký xib
        let xib = UINib(nibName: "PhotoMoveAlbumTableViewCell", bundle: nil)
        mTableView.register(xib, forCellReuseIdentifier: "PhotoMoveAlbumTableViewCell")
    }

    @objc func didCancelButtonChecked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didBackButtonChecked() {
        
    }
    
    func Movearr(pathmove: Array<URL>, pathRemove: URL){
        for i in 0..<pathmove.count {
                do{
                    let imageName = UUID().uuidString
                    let path = pathRemove.appendingPathComponent("\(imageName).png")
                    try FileManager.default.moveItem(at: pathmove[i], to: path)
                    
                    print("lưu thành công")
                }catch{
                    print("Lỗi")
                }
        }
    }
    func Moveimage(pathmove: URL, pathRemove: URL){
            do{
                let imageName = UUID().uuidString
                let path = pathRemove.appendingPathComponent("\(imageName).png")
                try FileManager.default.moveItem(at: pathmove, to: path)

                print("lưu thành công một hình")
            }catch{
                print("Lỗi")
            }
        }
}
//extension PhotoAlbumViewController
extension PhotoMoveAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAlbumPhotoMove.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCell(withIdentifier: "PhotoMoveAlbumTableViewCell") as! PhotoMoveAlbumTableViewCell
        cell.lblNamePhotoMove.text = arrAlbumPhotoMove[indexPath.row]
        cell.numberPhotoMove.text = String(arrCountItem[indexPath.row]) + " photo"
        if arrCountItem[indexPath.row] == 0 {
            cell.imgPhotoMove.image = UIImage(named: "Unknown")
        } else {
            let name = ReadFile(name: arrAlbumPhotoMove[indexPath.row])
            let path = getDocumentsDicretory().appendingPathComponent(arrAlbumPhotoMove[indexPath.row]).appendingPathComponent(name)
            cell.imgPhotoMove.image = UIImage(contentsOfFile: path.path)
        }
     
       
        let backgroundview = UIView()
        backgroundview.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundview
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("ppppppppppppppppppppp")
        let albumScreen = PhotoAlbumViewController()
        let name = mTableView.cellForRow(at: indexPath) as! PhotoMoveAlbumTableViewCell
        albumScreen.titleNavAlbum = name.lblNamePhotoMove.text
        
        // Move image
        // lấy đường dẫn mảng
         let receiveAlbum = arrPhotoNhanURL[indexPath.row]
        // lấy đường dẫn ảnh
        
        
        //debugPrint("gggggggggggggggggg \(arrPhotoNhanURL)")
        // debugPrint("nguoichuyen\(arrPhotoMoveURL)")
   //     debugPrint("người chuyển \(pathPhotoMoveURL!)")
         debugPrint("nguoinhan\(receiveAlbum)")
        // đã có mangr chứa hình nhưng chưa có cách nào đổ mấy cái hình này sang thư mục bên kia
        // Select all
        if isMoveSingle == false {
            Movearr(pathmove: arrPhotoMoveURL, pathRemove: receiveAlbum)
        } else {
        // Single photo
            Moveimage(pathmove: pathPhotoMoveURL!, pathRemove: receiveAlbum)
        }
        albumScreen.isMoved = true
        self.navigationController?.pushViewController(albumScreen, animated: true)
        
    }
    
    
}

