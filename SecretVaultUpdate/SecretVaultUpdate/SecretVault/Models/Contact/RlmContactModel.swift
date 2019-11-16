//
//  RlmContactModel.swift
//  SecretVault
//
//  Created by Đặng Ngọc Đại on 8/30/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//
import Foundation
import RealmSwift
class Danhba2 : Object{
    @objc dynamic var ID : String?
    @objc dynamic var mHinh : String?
    @objc dynamic var mName : String?
    @objc dynamic var mFirst : String?
    @objc dynamic var mLast : String?
    @objc dynamic var mCompany : String?
    @objc dynamic var mMobile : String?
    @objc dynamic var mHome : String?
    @objc dynamic var mWork : String?
    @objc dynamic var mURL : String?
    @objc dynamic var mEmail : String?
    @objc dynamic var mNote : String?
    @objc dynamic var mnhinh : String?
    // Set primaryKey
    override static func primaryKey() -> String{
        return "ID"
    }
}
class DBBDanhba{
    // The variable refers to the Realm database
    private var database : Realm
    // The variable instance in singleton
    static let Instance = DBBDanhba()
    // The global variable of class DBManager contains the current value of the ID key field
    static var autoID : Int = 0
    // The variable refers to the UserDefault data to save autoID
    let userData : UserDefaults
    
    private init()
    {
        // Initialize database realm
        database = try! Realm()
        userData = UserDefaults.standard
        DBBDanhba.autoID = userData.integer(forKey: "autoID")
    }
    // Retrieve data from the database
    func getDataTable() -> Results<Danhba2>{
        let result:Results<Danhba2> = database.objects(Danhba2.self)
        return result
    }
    // Function to add data
    func insertOneSanPham(object: Danhba2){
        try! database.write {
            // Increase the current value of key ID
            DBBDanhba.autoID += 1
            object.ID = "Danhba2" + String(DBBDanhba.autoID)
            database.add(object)
            // Save current autoid information into userData
            userData.set(DBBDanhba.autoID, forKey: "autoID")
        }
    }
    func sortByName(object: Results<Danhba2>){
        //object.sorted(by: a,b)
    }
    // The function deletes an element
    func removeOneSanPham(id_SanPham : String)
    {
        let realm = try! Realm()
        let found = realm.objects(Danhba2.self).first { (item) -> Bool in
            if item.ID == id_SanPham{
                return true
            }
            return false
        }
        //unwrapp
        if let ifound = found{
            try! realm.write {
                realm.delete(ifound)
            }
        }
    }
    // The function deletes an element
    func deleTable(object : Danhba2) -> Bool
    {
        do{
            try database.write {
                database.delete(object)
            }
            return true
        }catch{
            return false
        }
    }
    // The function clears all data
    func deleteAllfromDB(object:Danhba2) -> Bool
    {
        do{
            try database.write {
                database.deleteAll()
            }
            return true
        }catch{
            return false
        }
    }
    // The function updates the information of an element
    func updateToDB(object:Danhba2) -> Bool
    {
        do{
            try database.write {
                database.add(object, update: true)
            }
            return true
        }catch{
            return false
        }
    }
}

