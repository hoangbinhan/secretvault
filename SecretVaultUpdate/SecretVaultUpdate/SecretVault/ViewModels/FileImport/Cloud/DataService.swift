//
//  DataService.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation
import RealmSwift

class DataService: NSObject {
    let realm = try! Realm()
    
}

//MARK: - Files
extension DataService {
    static let shared = DataService()
    
    func getFiles() -> Results<File> {
        return realm.objects(File.self)
    }
    func getFiles(at folderPath: String) -> List<File> {
        return realm.objects(Folder.self).filter("path = %@", folderPath)[0].files
    }
    
    func addFile(fileModel: FilesModel) {
        let file = File()
        fileModel.copyTo(file: file)
        try!  realm.write {
            realm.add(file, update: true)
        }
    }
    
    func addToPlaylist(fileModel: FilesModel)  {
        let object = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        try! realm.write {
            object.isPlaylist = true
        }
    }
    
    func deleteFile(fileModel: FilesModel) {
        let objectToDelete = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
    
    func getFile(withPath: String) -> FilesModel {
        let object = realm.objects(File.self).filter("path = %@", withPath)[0]
        let file = FilesModel(path: object.path, type: object.type, isPlaylist: object.isPlaylist, isSelected: object.isSelected, isFolder: object.isFolder)
        return file
    }
    
    
    
    
}

//MARK: - Folder
extension DataService {
    func getFolders() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
    
    
    func addFolder(folderModel: FolderModel) {
        let folder = Folder()
        folderModel.copyTo(file: folder)
        for item in folderModel.files {
            let file = File()
            item.copyTo(file: file)
            folder.files.append(file)
        }
        try!  realm.write {
            realm.add(folder, update: true)
        }
    }
    
    func addFile(_ fileModel: FilesModel, to folder: FolderModel) {
        let folder = realm.objects(Folder.self).filter("path = %@", folder.path)[0]
        let file = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        try! realm.write {
            folder.files.append(file)
        }
    }
    
    func removeFileOutFolder(_ fileModel: FilesModel, folderPath: String) {
        let folder = realm.objects(Folder.self).filter("path = %@", folderPath)[0]
        let file = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        for i in 0..<folder.files.count {
            if file.path == folder.files[i].path {
                try! realm.write {
                    folder.files.remove(at: i)
                }
                return
            }
        }
        
    }
    
    func deleteFolder(folderModel: FolderModel) {
        let objectToDelete = realm.objects(Folder.self).filter("path = %@", folderModel.path)[0]
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
}

//MARK: - Play list
extension DataService {
    func getPlaylist() -> Results<Plays> {
        return realm.objects(Plays.self)
    }
    
    func getPlaylistBy(playlistModel: PlaylistModel) -> Plays {
        return realm.objects(Plays.self).filter("name = %@", playlistModel.name)[0]
    }
    
    func addPlaylist(playlistModel: PlaylistModel) {
        let plays = Plays()
        playlistModel.copyTo(plays: plays)
        plays.id = plays.incrementID()
        plays.files = List<File>()
        try!  realm.write {
            realm.add(plays, update: false)
        }
    }
    
    func addFileToPlaylist(fileModel: FilesModel, playlist: PlaylistModel) {
        let play = realm.objects(Plays.self).filter("name = %@", playlist.name)[0]
        let file = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        try! realm.write {
            play.files.append(file)
        }
    }
    
    func removeFileOutPlaylist(fileModel: FilesModel, playlist: PlaylistModel) {
        let plays = realm.objects(Plays.self).filter("name = %@", playlist.name)[0]
        for i in 0..<plays.files.count {
            if fileModel.path == plays.files[i].path {
                try! realm.write {
                    plays.files.remove(at: i)
                }
                return
            }
        }
    }
    
    func delete(playlistModel: PlaylistModel) {
        
        if playlistModel.id != nil {
            let play = realm.objects(Plays.self).filter("id = %@", playlistModel.id)[0]
            try! realm.write {
                realm.delete(play)
            }
        }
        
    }
    
    func update(playlistModel: PlaylistModel) {
        if playlistModel.id != nil {
            
            let play = realm.objects(Plays.self).filter("id = %@", playlistModel.id)[0]
            try! realm.write {
                play.name = playlistModel.name
            }
        }
        
    }
}

//MARK: - Folder
extension DataService {
    func getFoder() -> Results<Foder> {
        return realm.objects(Foder.self)
    }
    
    func getFodersBy(folderModel: FoderModel) -> Foder {
        return realm.objects(Foder.self).filter("name = %@", folderModel.name)[0]
    }
    
    func addFoder(folderModel: FoderModel) {
        let foders = Foder()
        folderModel.copyTo(foder: foders)
        foders.idFoder = foders.incrementID()
        foders.files = List<File>()
        try!  realm.write {
            realm.add(foders, update: false)
        }
    }
    
    func addFileToFoder(fileModel: FilesModel, foder: FoderModel) {
        let foders = realm.objects(Foder.self).filter("name = %@", foder.name)[0]
        let file = realm.objects(File.self).filter("path = %@", fileModel.path)[0]
        try! realm.write {
            foders.files.append(file)
        }
    }
    
    func removeFileOutFoder(fileModel: FilesModel, foder: FoderModel) {
        let foders = realm.objects(Foder.self).filter("name = %@", foder.name)[0]
        for i in 0..<foders.files.count {
            if fileModel.path == foders.files[i].path {
                try! realm.write {
                    foders.files.remove(at: i)
                }
                return
            }
        }
    }
    
    func delete(foder: FoderModel) {
        if foder.idFoder != nil {
            let foders = realm.objects(Foder.self).filter("idFoder = %@", foder.idFoder)[0]
            try! realm.write {
                realm.delete(foders)
            }
        }
        
    }
    
    func update(foder: FoderModel) {
        
        if foder.idFoder != nil {
            
            let foders = realm.objects(Foder.self).filter("idFoder = %@", foder.idFoder)[0]
            try! realm.write {
                foders.name = foder.name
            }
        }
        
    }
}

