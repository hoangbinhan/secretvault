//
//  PlaylistModel.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

struct PlaylistModel {
    var id: Int!
    var name: String
    var files: [FilesModel]
    init(name: String, files: [FilesModel]) {
        self.name = name
        self.files = files
    }
    
    func copyTo(plays: Plays) {
        plays.name = self.name
    }
}
