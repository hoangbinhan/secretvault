//
//  ViewImageViewController.swift
//  SecretVault
//
//  Created by MAC_OS on 9/16/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit

class ViewImageViewController: UIViewController, UIScrollViewDelegate {

    //MARK: --PROPERTIES
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgImage: UIImageView!
    var imageName: String?
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem       =   UIBarButtonItem(image: Constants.ImageFileImport.defautBackNavigationImage, style: .plain, target: self, action: #selector(didBackButtonChecked))
        barButtonItem.tintColor =   Color.yellowTextColor
        return barButtonItem
    }()
    
    
    //MARK: --VIEWS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
      
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        self.navigationItem.leftBarButtonItem   = backBarButton
        // Do any additional setup after loading the view.
        if let imageName = imageName {
            print(imageName)
            imgImage.image = UIImage.init(contentsOfFile: imageName)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: --METHODS
    
    @IBAction func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: 3.0, center: sender.location(in: sender.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgImage.frame.size.height / scale
        zoomRect.size.width  = imgImage.frame.size.width  / scale
        let newCenter = imgImage.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgImage
    }
    
    @objc func didBackButtonChecked() {
        navigationController?.popViewController(animated: true)
    }
}

