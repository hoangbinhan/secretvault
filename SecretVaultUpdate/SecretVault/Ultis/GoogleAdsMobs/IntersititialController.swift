//
//  IntersititialController.swift
//  SecretVault
//
//  Created by 5K on 8/29/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IntersititialController: NSObject {
    
    // intersitital ads unit id
    struct IntersititialAdsUnitID {
        static var strIntersititialAdsID = StringConstants().Interstitial_ID
    }
    
    static let sharedInstance: IntersititialController = IntersititialController()
    private var isInitIntersititial = false
    private var intersititialAds: GADInterstitial!
    
    override init() {
        super.init()
        self.createIntersititial()
    }
    
    //create an Intersititial ads
    private func createIntersititial() {
        intersititialAds = GADInterstitial(adUnitID: IntersititialAdsUnitID.strIntersititialAdsID)
        intersititialAds.delegate = self as! GADInterstitialDelegate
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "32ac7365685c8163d426cbbb5e243fd0", "7043e08ce605ff9d6addc2ac395d9e08" ]
        intersititialAds.load(request)
    }
    
    //show Intersititial ads
    func showIntersititial() {
        if intersititialAds.isReady {
            intersititialAds.present(fromRootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
        } else {
            debugPrint("Ads wasn't ready")
            createIntersititial()
        }
    }

}

extension IntersititialController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        showIntersititial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(error.description)")
    }
    
}

