//
//  Folder.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

final class Folder: Object {
    @objc dynamic var path = ""
    @objc dynamic var createAt = ""
    var files = List<File>()
    override static func primaryKey() -> String {
        return "path"
    }
}
