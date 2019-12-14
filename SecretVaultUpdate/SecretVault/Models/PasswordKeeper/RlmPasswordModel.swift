//
//  RlmPasswordModel.swift
//  SecretVault
//
//  Created by 5K on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PasswordKeeper: Object {
    
    @objc dynamic var ID : String?
    @objc dynamic var mName : String?
    @objc dynamic var mUserName : String?
    @objc dynamic var mPassword : String?
    @objc dynamic var mWebsite : String?
    @objc dynamic var mNote : String?
    
    // Set primaryKey
    override static func primaryKey() -> String{
        return "ID"
    }
}

class DBPassword {
    // The variable refers to the Realm database
    private var database : Realm
    // The variable instance in singleton
    static let Instance = DBPassword()
    // The global variable of class DBManager contains the current value of the ID key field
    static var autoID : Int = 0
    // The variable refers to the UserDefault data to save autoID
    let userData : UserDefaults
    
    private init()
    {
        // Initialize database realm
        database = try! Realm()
        userData = UserDefaults.standard
        DBPassword.autoID = userData.integer(forKey: "autoID")
    }
    
    // Retrieve data from the database
    func getDataTable() -> Results<PasswordKeeper>{
        let result:Results<PasswordKeeper> = database.objects(PasswordKeeper.self)
        return result
    }
    // Function to add data
    func insertOnePassword(object: PasswordKeeper){
        try! database.write {
            // Increase the current value of key ID
            DBPassword.autoID += 1
            object.ID = "Password" + String(DBPassword.autoID)
            database.add(object)
            // Save current autoid information into userData
            userData.set(DBPassword.autoID, forKey: "autoID")
        }
    }
    // The function deletes an element
    func removeOnePassword(id_Password : String)
    {
        let realm = try! Realm()
        let found = realm.objects(PasswordKeeper.self).first { (item) -> Bool in
            if item.ID == id_Password{
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
    func deleTable(object : PasswordKeeper) -> Bool
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
    func deleteAllfromDB(object:PasswordKeeper) -> Bool
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
    func updateToDB(object:PasswordKeeper) -> Bool
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
