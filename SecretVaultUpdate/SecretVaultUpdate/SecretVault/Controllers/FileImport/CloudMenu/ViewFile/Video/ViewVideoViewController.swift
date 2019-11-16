//
//  ViewVideoViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/17/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewVideoViewController: UIViewController {
    
    //MARK:--PROPERTIES
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var imgPlay: UIImageView!
    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer : AVPlayer?
    var videoPath: URL?
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    //MARK:--VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.leftBarButtonItem = backBarButton
        if let videoPath = videoPath {
            imgThumbnail.image = getThumbnailFrom(path: videoPath)
            let movieURL = NSURL(fileURLWithPath: videoPath.path)
            self.avPlayer = AVPlayer(url: movieURL as URL)
            self.avPlayerViewController.player = self.avPlayer
        }

        // Do any additional setup after loading the view.
        
    }
    
    //MARK:--METHODS
    
    func setupUI(){
        viewPlay.backgroundColor    = .black
        viewPlay.layer.cornerRadius = viewPlay.frame.size.width / 2
        imgPlay.layer.cornerRadius  = imgPlay.frame.size.width / 2
        imgPlay.clipsToBounds       = true
        imgPlay.image               = UIImage.init(named: "ic_playvideo")
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        present(self.avPlayerViewController, animated: true) {
            self.avPlayerViewController.player?.play()
        }
    }
    
    @objc func didBackButtonChecked() {
        navigationController?.popViewController(animated: true)
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let timestamp = asset.duration
            print("Timestemp:   \(timestamp)")
            let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
}
