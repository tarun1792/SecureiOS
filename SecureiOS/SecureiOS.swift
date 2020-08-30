//
//  SecureiOS.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 29/08/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit

public class SecureiOS{
    
    /*
     Determine if the device is Jailbroken
     
     Usage example
     ```
     let jailBreakStatus = SecureiOS.jailBreakCheck()
     ```
     */
    
    public static func jailBreakCheck()->Bool{
        return JailBreakDetection.check()
    }
    
    
    /*
     Puts the splashscreen over the application window once the application enters background
     place the method inside function ```sceneWillResignActive(_ scene:)``` inside SceneDelegate.
     
     Usage example
     ```
     SecureiOS.setupSplashScreen(&window,image)
     ```
     */
    
    public static func setupSplashScreen(_ window:inout UIWindow?,_ image: UIImage?){
        BackgroundModeOverlay.showSplashImage(&window, image: image)
    }
    
    /*
      Removes the splashscreen over the application window once the application enters foreground
      place the method inside function ```sceneDidBecomeActive(_ scene:)``` inside SceneDelegate.
      
      Usage example
      ```
      SecureiOS.removeSplashScreen(&window)
      ```
      */
    
    public static func removeSplashScreen(_ window:inout UIWindow?){
        BackgroundModeOverlay.removeSplashImage(&window)
    }
    
    
}
