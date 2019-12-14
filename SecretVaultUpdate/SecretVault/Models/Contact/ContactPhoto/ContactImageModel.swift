//
//  ImageModel.swift
//  SecretVault
//
//  Created by User01 on 9/10/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import UIKit
class ContactImageModels: NSObject {
    var indexPath:IndexPath
    var image:UIImage
    init(indexPath:IndexPath, image:UIImage) {
        self.indexPath = indexPath
        self.image = image
    }
}
class ContactImageModels1:NSObject
{
    var image:String
    init(image:String) {
        self.image = image
    }
}
