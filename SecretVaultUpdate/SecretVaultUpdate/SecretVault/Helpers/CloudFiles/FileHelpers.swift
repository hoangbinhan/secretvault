//
//  FileHelpers.swift
//  SecretVault
//
//  Created by MAC_OS on 9/4/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import Photos

class FileHelpers: NSObject {
    static func getURLFile(folderName: String, fileName: String) -> URL? {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let  filePath = documentsUrl.appendingPathComponent(Constants.DefaultFolder.titleFileImport
            ).appendingPathComponent("\(folderName)").appendingPathComponent("\(fileName)")
        return filePath
    }
    
    static func checkExtensionFileName(fileName: String) -> Bool {
        let extensionFile = fileName.fileExtension()
        for i in 0 ..< PathExtensionFile.pictureExtension.count {
            if extensionFile == PathExtensionFile.pictureExtension[i] {
                return true
            }
        }
        //--
        for i in 0 ..< PathExtensionFile.musicExtension.count {
            if extensionFile == PathExtensionFile.musicExtension[i] {
                return true
            }
        }
        //--
        for i in 0 ..< PathExtensionFile.videoExtension.count {
            if extensionFile == PathExtensionFile.videoExtension[i] {
                return true
            }
        }
        //--
        for i in 0 ..< PathExtensionFile.wordExtension.count {
           if extensionFile == PathExtensionFile.wordExtension[i] {
               return true
           }
        }
        //
        if extensionFile == PathExtensionFile.pdfExtension || extensionFile == PathExtensionFile.zipExtension {
            return true
        }
        
        return false
    }
    
    static func checkExtensionFilesInFolder(fileName: String) -> Int {
        let extensionFile = fileName.fileExtension()
        
        for i in 0 ..< PathExtensionFile.pictureExtension.count {
            if extensionFile == PathExtensionFile.pictureExtension[i] {
                return 1
            }
        }
        
        for i in 0 ..< PathExtensionFile.musicExtension.count {
            if extensionFile == PathExtensionFile.musicExtension[i] {
                return 2
            }
        }
        
        for i in 0 ..< PathExtensionFile.videoExtension.count {
            if extensionFile == PathExtensionFile.videoExtension[i] {
                return 3
            }
        }
        //--
       for i in 0 ..< PathExtensionFile.wordExtension.count {
           if extensionFile == PathExtensionFile.wordExtension[i] {
               return 4
           }
       }
       //--
       if extensionFile == PathExtensionFile.pdfExtension {
           return 5
       }
       //--
       if extensionFile == PathExtensionFile.zipExtension || extensionFile == PathExtensionFile.rarExtension {
           return 6
       }
        
    return 0
    }
    
    
//    static func tempZipPath(fileName: String) -> String {
//        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constants.DefaultFolder.title).path
//        path += "/\(fileName)"
//        return path
//    }
//    
//    static func tempUnzipPath(fileName: String? = nil) -> String? {
//        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//        path += "/\(Constants.DefaultFolder.title)"
//        let url = URL(fileURLWithPath: path)
//        return url.path
//    }
//    
//    static func createFolder() {
//        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        let folderPath = documentsPath.appendingPathComponent(Constants.DefaultFolder.title)
//        if !FileManager.default.fileExists(atPath: (folderPath?.path)!) {
//            do {
//                try FileManager.default.createDirectory(atPath: folderPath!.path, withIntermediateDirectories: true, attributes: nil)
//            } catch let error as NSError {
//                NSLog("Unable to create directory \(error.debugDescription)")
//            }
//        }
//        let folderPathPlaylist = documentsPath.appendingPathComponent(Constants.DefaultFolder.titlePlaylist)
//        if !FileManager.default.fileExists(atPath: (folderPath?.path)!) {
//            do {
//                try FileManager.default.createDirectory(atPath: folderPathPlaylist!.path, withIntermediateDirectories: true, attributes: nil)
//            } catch let error as NSError {
//                NSLog("Unable to create directory \(error.debugDescription)")
//            }
//        }
//    }
//    
//    
    static func listFilesFromDocumentsFolder(foldername: String?, name: String?) -> [String]? {
        let fileMngr = FileManager.default;
        let defaultFolderUrl = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constants.DefaultFolder.titleFileImport).appendingPathComponent(foldername ?? "")
        guard let name = name else {
            return try? fileMngr.contentsOfDirectory(atPath:defaultFolderUrl.path)
        }
        let  folderPath = defaultFolderUrl.appendingPathComponent(name).path
        return try? fileMngr.contentsOfDirectory(atPath:folderPath)
    }
//
//    
//    
//    static func deleteFile(filename: String) {
//        if let url = getURLFile(fileName: filename) {
//            do {
//                try FileManager.default.removeItem(at: url)
//            } catch let error as NSError {
//                print(error.debugDescription)
//            }
//        }
//    }
//    
//    static func deleteFolder(_ folderPath: String) {
//        do {
//            try FileManager.default.removeItem(atPath: folderPath)
//        } catch let error as NSError {
//            print(error.debugDescription)
//        }
//    }
//    
    static func writeFile(folderName: String, fileName: String, with data: Data) {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory.appendingPathComponent(Constants.DefaultFolder.titleFileImport).appendingPathComponent("\(folderName)").appendingPathComponent(fileName)
        do {
            // writing to disk
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
//
//    static func saveMediaFileToCameraroll(filePath: String) {
//        let filePathNString = filePath as NSString
//        switch filePathNString.pathExtension  {
//        case TypeFile.jpg.rawValue, TypeFile.png.rawValue:
//            if let image = UIImage(contentsOfFile: filePath) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//            break
//        case TypeFile.mp4.rawValue:
//            let status = PHPhotoLibrary.authorizationStatus()
//            switch status {
//            case .authorized:
//                if let url = FileHelpers.getURLFile(fileName: filePathNString.lastPathComponent) {
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
//                    }) { saved, error in
//                        if saved {
//                            print("Save successsfully")
//                        } else {
//                            print(error!)
//                        }
//                    }
//                }
//            case .denied, .restricted :
//                break
//            case .notDetermined:
//                // ask for permissions
//                PHPhotoLibrary.requestAuthorization() { status in
//                    switch status {
//                    case .authorized:
//                        if let url = FileHelpers.getURLFile(fileName: filePathNString.lastPathComponent) {
//                            PHPhotoLibrary.shared().performChanges({
//                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
//                            }) { saved, error in
//                                if saved {
//                                    print("Save successsfully")
//                                } else {
//                                    print(error!)
//                                }
//                            }
//                        }
//                    case .denied, .restricted:
//                        break
//                    case .notDetermined:
//                        break
//                    }
//                }
//            }
//            break
//        default:
//            break
//        }
//        
//    }
}

