//
//  File.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

final class File: Object {
    @objc dynamic var path = ""
    @objc dynamic var type = ""
    @objc dynamic var isPlaylist = false
    @objc dynamic var isFolder = false
    @objc dynamic var isSelected = false
    override static func primaryKey() -> String {
        return "path"
    }
}
