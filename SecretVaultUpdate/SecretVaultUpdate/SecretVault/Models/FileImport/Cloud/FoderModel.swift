//
//  FoderModel.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

struct FoderModel {
    var idFoder: Int!
    var name: String
    var files: [FilesModel]
    init(name: String, files: [FilesModel]) {
        self.name = name
        self.files = files
    }
    
    func copyTo(foder: Foder) {
        foder.name = self.name
    }
}
