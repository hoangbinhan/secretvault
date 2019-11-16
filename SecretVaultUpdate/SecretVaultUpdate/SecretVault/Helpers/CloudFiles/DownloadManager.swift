//
//  DownloadManager.swift
//  SecretVault
//
//  Created by MAC_OS on 9/7/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import Alamofire
class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    func downloadFile(folderName: String, url: URL, completion: @escaping (String) -> Void) {
       
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = FileHelpers.getURLFile(folderName: folderName, fileName: url.lastPathComponent)
                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
            }
            Alamofire.download(url.absoluteString, to: destination).response { response in
                if let filePath = response.destinationURL?.path {
                    completion(filePath)
                }
            }

        }
    
}
