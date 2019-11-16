//
//  Plays.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

final class Plays: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var files = List<File>()
    override static func primaryKey() -> String {
        return "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Plays.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
