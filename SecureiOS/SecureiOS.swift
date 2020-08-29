//
//  SecureiOS.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 29/08/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation

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
}
