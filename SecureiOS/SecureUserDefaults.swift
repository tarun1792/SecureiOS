//
//  SecureUserDefault.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 15/09/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit

enum SecureUserDefaultsError: Error{
    case unknownError
    case encodingError
}

public class SecureUserDefaults{
    
    private let keychainWrapper = KeychainWrapper()
    
    private init(){}
    
    public static let standard:SecureUserDefaults = SecureUserDefaults()
    
    public func saveData(forKey key:String,value:String){
        let userDefault = UserDefaults.standard
        let hashedKey = self.getKeyHash(key: key)
        
        if let data = try? keychainWrapper.encrypt(text: value) {
            userDefault.setValue(data, forKey: hashedKey)
        }
    }
    
    public func saveData(forKey key: String, value: Any) {
        let hashedKey = self.getKeyHash(key: key)
        let dictionary:[String:Any] = [hashedKey:value]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary,options: .fragmentsAllowed)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw SecureUserDefaultsError.encodingError
            }
            if let data = try? keychainWrapper.encrypt(text: jsonString) {
                let userDefault = UserDefaults.standard
                userDefault.setValue(data, forKey: hashedKey)
            }
        }catch {
            print("Something went wrong")
        }
    }
    
    public func getStringData(forKey key:String) -> String? {
        let userDefault = UserDefaults.standard
        let hashedKey = self.getKeyHash(key: key)
        
        if let data = userDefault.value(forKey: hashedKey) as? Data{
            // perform some decryption logic here
            if let decryptedString = try? self.keychainWrapper.decrypt(data: data) {
                // finshed getting the decoded data
                return String(data: decryptedString,encoding: .utf8)
            }
        }
    
       return nil
    }
    
    public func getAnyData(forKey key:String) -> Any? {
        let userDefault = UserDefaults.standard
        let hashedKey = self.getKeyHash(key: key)
        
        if let data = userDefault.value(forKey: hashedKey) as? Data{
            // perform some decryption logic here
            if let decryptedData = try? self.keychainWrapper.decrypt(data: data) {
                // finshed getting the decoded data
                do {
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: decryptedData, options: .allowFragments) as? [String:Any] {
                        return jsonDictionary[hashedKey]
                    }
                } catch {
                    return nil
                }
            }
        }
    
       return nil
    }
    
    private func getKeyHash(key: String) -> String {
        let data = Data(key.utf8)
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
