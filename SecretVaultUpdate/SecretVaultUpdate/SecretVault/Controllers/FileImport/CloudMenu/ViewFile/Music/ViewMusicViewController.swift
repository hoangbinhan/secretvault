//
//  ViewMusicViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/17/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import MediaPlayer

class ViewMusicViewController: UIViewController {

    //MARK: --PROPERTIES
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var lblNameMusic: UILabel!
    @IBOutlet weak var lblNameSinger: UILabel!
    @IBOutlet weak var sldTimeMusic: UISlider!
    @IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewRepeat: UIView!
    @IBOutlet weak var imgRepeat: UIImageView!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    
    let defaultWallpaper:   UIImage = UIImage.init(named: "defaulticonmusic" )!
    let playButton:         UIImage = UIImage.init(named: "ic_playbutton")!
    let pauseButton:        UIImage = UIImage.init(named: "ic_pausebutton")!
    let repeatButton:       UIImage = UIImage.init(named: "repeat")!

    var isChangingDuration = false
    var musicPath:  URL?
    var musicName:  String?
    var player:     AVAudioPlayer?
    var playerItem: AVPlayerItem?
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = backBarButton
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        playerInit()
        setupView()
        player?.play()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: --METHODS
    
    func setupView() {
        lblNameMusic.text               = musicName?.fileName()
        imgWallpaper.layer.cornerRadius = 10
        imgWallpaper.clipsToBounds      = true
        
        viewPlay.layer.cornerRadius     = viewPlay.frame.size.width / 2
        viewPlay.backgroundColor        = .black
        imgPlay.layer.cornerRadius      = imgPlay.frame.size.width / 2
        imgPlay.clipsToBounds           = true
        imgPlay.image                   = pauseButton
        btnPlay.layer.cornerRadius      = imgPlay.frame.size.width / 2
        
//        viewRepeat.layer.cornerRadius   = viewRepeat.frame.size.width / 2
//        viewRepeat.backgroundColor      = .black
//        imgRepeat.layer.cornerRadius    = imgRepeat.frame.size.width / 2
//        imgRepeat.clipsToBounds         = true
//        imgRepeat.image                 = repeatButton
//        btnRepeat.layer.cornerRadius    = imgRepeat.frame.size.width / 2
        
        
    }
    
    @objc func didBackButtonChecked() {
        player?.stop()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateSlider() {
        if player!.isPlaying == true {
            sldTimeMusic.value = Float((player!.currentTime))
            let min = Int(player!.currentTime) / 60
            let second = Int(player!.currentTime) % 60
            self.lblStart.text = String(format: "%02d:%02d",min, second)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if player != nil {
            if sender.isSelected == true {
                imgPlay.image = playButton
                player?.stop()
            } else {
                imgPlay.image = pauseButton
                player?.play()
            }
        }
    }
    
    @IBAction func changeDuration(_ sender: UISlider, forEvent event: UIEvent) {
        if player != nil {
            if imgPlay.image == playButton {
                player?.currentTime = TimeInterval(sldTimeMusic.value)
                player?.stop()
            } else {
                player?.currentTime = TimeInterval(sldTimeMusic.value)
                player?.play()
            }
        }
    }
    
    @IBAction func repeatButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            imgRepeat.isHighlighted = true
            player?.numberOfLoops = -1
        }
        else {
            imgRepeat.isHighlighted = false
            player?.numberOfLoops = 0
        }
       
    }
    
    func playerInit() {
        player?.delegate = self
        if let musicPath = musicPath {
            let avAsset = AVURLAsset(url: musicPath, options: nil)
            playerItem = AVPlayerItem(asset: avAsset)
            let metadataList = playerItem!.asset.metadata
            var author = "Unknow"
            for item in metadataList {
                if item.commonKey != nil && item.value != nil {
                    if item.commonKey?.rawValue   == "artist" {
                        author = item.stringValue!
                        lblNameSinger.text = author
                    }
                    if item.commonKey?.rawValue  == "artwork" {
                        if let image = UIImage(data: item.dataValue!) {
                            imgWallpaper.image = image
                            if #available(iOS 10.0, *) {
                                let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: {  (_) -> UIImage in
                                    return image
                                })
                            }
                        }
                    }
                }
            }
            if imgWallpaper.image == nil{
                imgWallpaper.image = defaultWallpaper
            }
            if lblNameSinger.text == "" {
                lblNameSinger.text = "#unknown"
            }
            do {
                player = try AVAudioPlayer(contentsOf: musicPath)
                let duration = player?.duration
                let min = Int(duration!) / 60
                let second = Int(duration!) % 60
                self.lblEnd.text = String(format: "%02d:%02d",min, second)
                self.sldTimeMusic.maximumValue = Float(duration!)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }

}

extension ViewMusicViewController:  AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.delegate = self
        sldTimeMusic.value = 0
        player.currentTime = 0
        player.currentTime = TimeInterval(sldTimeMusic.value)
    }
}
