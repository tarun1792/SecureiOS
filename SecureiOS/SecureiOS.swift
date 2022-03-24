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
     let proxyCheck = SecureiOS.proxyCheck()
     ```
     */
    
    public static func proxyCheck() -> Bool {
        return ProxyChecker.proxyCheck()
    }
    
    /*
     Provides secure userDefaults functionality
     
     Usage example
     ```
     SecureiOS.secureUserDefaults().saveData(forKey: "key", value: value)
     
     guard let value = SecureiOS.secureUserDefaults().getAnyData(forKey: "key") as? String else {return}
     ```
     */
    
    public static func secureUserDefaults() -> SecureUserDefaults {
        return SecureUserDefaults.standard
    }
    
    /*
     Determine if the device has implemented Biometrics or passcode
     
     Usages example
     ```
     let deviceLockAndBiometricStatus = SecureiOS.getDeviceLockAndBiometryStatus()
     
     if deviceLockAndBiometricStatus.isEnabled{
        let type = deviceLockAndBiometricStatus.type
        switch type{
        case .touchId:
            print(type.name)
        case .faceId:
            print(type.name)
        case .passcode:
            print(type.name)
        case .none:
            print(type.name)
        @unknown default:
            print("unknown")
        }
     }
     ```
     */
    
    public static func getDeviceLockAndBiometryStatus() -> BiometryStatus{
        return BiometricControl().checkDeviceLockAndBiomtryStatus()
    }
    
    
    /*
     Returns the supported biometryType in the device
     
     Usages example
     ```
     switch SecureiOS.getSupportedBiometryType(){
     case .faceId:
         print("Face Id")
     case .touchId:
         print("Touch Id")
     case .none:
         print("None")
     @unknown default:
         print("unknown")
     }
     ```
     */
    public static func getSupportedBiometryType() -> BiometryType {
        return BiometricControl().supportedBiometryType
    }
}
