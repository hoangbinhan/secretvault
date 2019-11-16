//
//  FolderModel.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

struct FolderModel {
    var path: String
    var createAt: String
    var files: [FilesModel]
    init(path: String, createAt: String, files: [FilesModel]) {
        self.path = path
        self.createAt = createAt
        self.files = files
    }
    
    func copyTo(file: Folder) {
        file.path = self.path
        file.createAt = self.createAt
    }
}
