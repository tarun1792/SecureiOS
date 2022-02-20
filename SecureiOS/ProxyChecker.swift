//
//  ProxyChecker.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 20/02/22.
//  Copyright © 2022 Tarun Kaushik. All rights reserved.
//

import Foundation

import Foundation

internal class ProxyChecker {
    
    static func proxyCheck() -> Bool {
        
        guard let proxySettings = CFNetworkCopySystemProxySettings() else {
            return false
        }

        guard  let settings = proxySettings.takeRetainedValue() as? [String: Any] else {
            return false
        }
               
        return (settings.keys.contains("HTTPProxy") || settings.keys.contains("HTTPSProxy"))
    }
}
