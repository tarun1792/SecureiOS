//
//  BackgroundModeOverlay.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 30/08/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit


class BackgroundModeOverlay{
    
    // Adds splash screen to the screen
    static func showSplashImage(_ window: inout UIWindow?,image:UIImage?){
        guard let window = window,let image = image else{return}
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        imageView.snapshotView(afterScreenUpdates: true)
        imageView.frame = window.bounds
        
        window.addSubview(imageView)
    }
    
    // Removes UIimage on the overlay
    static func removeSplashImage(_ window:inout UIWindow?){
     guard let window = window else{return}
        for view in window.subviews{
            if view is UIImageView{
                view.removeFromSuperview()
            }
        }
    }
}
