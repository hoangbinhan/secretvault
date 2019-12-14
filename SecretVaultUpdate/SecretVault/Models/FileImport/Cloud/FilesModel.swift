//
//  FilesModel.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

struct FilesModel {
    var path: String
    var type: String
    var isPlaylist: Bool
    var isFolder: Bool
    var isSelected: Bool
    
    init(path: String, type: String, isPlaylist: Bool, isSelected: Bool, isFolder: Bool) {
        self.path = path
        self.type = type
        self.isPlaylist = isPlaylist
        self.isSelected = isSelected
        self.isFolder = isFolder
        
    }
    
    func copyTo(file: File) {
        file.path = self.path
        file.type = self.type
        file.isPlaylist = self.isPlaylist
        file.isFolder = self.isFolder
        file.isSelected = self.isSelected
        
    }
    
}
