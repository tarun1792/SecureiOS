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
    
    public static func jailBreakCheck() -> Bool{
        return JailBreakDetection.check()
    }
    
    
    /*
     Puts the splashscreen over the application window once the application enters background
     place the method inside function ```sceneWillResignActive(_ scene:)``` inside SceneDelegate.
     
     Usage example
     ```
     SecureiOS.setupBackgroundSplashScreen(&window,image)
     ```
     */
    
    public static func setupBackgroundSplashScreen(_ window:inout UIWindow?,_ image: UIImage?){
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
    
    /*
     Determine if the app is running on emulator
     
     Usage example
     ```
     let emulator = SecureiOS.emulatorCheck()
     ```
     */
    
    public static func emulatorCheck() -> Bool {
        return EmulatorChecker.emulatorCheck()
    }
    
    /*
     Determine if the device proxy settings is enabled
     
     Usage example
     ```
     let emulator = SecureiOS.proxyCheck()
     ```
     */
    
    public static func proxyCheck() -> Bool {
        return ProxyChecker.proxyCheck()
    }
}
