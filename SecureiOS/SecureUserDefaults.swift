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

public class SecureUserDefaults{
    
      
    private static let iv = AES.GCM.Nonce()
    private static let key = SymmetricKey(size: .bits128)
    
    public init(){}
    
    public static var standard:SecureUserDefaults {return SecureUserDefaults()}
    
    private func getKey(){
        let string = SHA256.hash(data: "password".data(using:.utf8)!)
      //  let data = string.data(using:.utf8)
        print(string)
       // print(data)
    }
    
    public func saveData(forKey key:String,value:String){
        getKey()
        
        
        let userDefault = UserDefaults.standard
        // Perform some private encryption logic here
        let data = self.encryptData(value:value)!
        // finish the encrption
        
        userDefault.setValue(data, forKey: key)
    }
    
    public func getData(for key:String) -> String?{
        let userDefault = UserDefaults.standard
        
        let data = userDefault.value(forKey: key) as! Data
        
        // perform some decryption logic here
        let decryptedString = self.decryptData(data:data)
        // finshed getting the decoded data
        
        return decryptedString
    }
    
    
    private func encryptData(value:String)->Data?{
        var encryptData:Data?
        
        do
        {
            let dataToEncrypt = value.data(using: .utf8)
            let secureSealBox = try AES.GCM.seal(dataToEncrypt!,using:SecureUserDefaults.key,nonce:SecureUserDefaults.iv)
            encryptData = secureSealBox.combined
        }catch{
            print("error")
        }
        
        return encryptData
    }
    
    private func decryptData(data:Data)->String?{
       
        var decryptedString:String?
        
        print(data)

        let sealedBoxToOpen = try! AES.GCM.SealedBox(combined: data)

        if let decryptedData = try? AES.GCM.open(sealedBoxToOpen, using: SecureUserDefaults.key) {
              decryptedString = String(data: decryptedData, encoding: .utf8)!
        } else {
            print("error",CryptoKitError.self)
            // Ouch, doSomething() threw an error.
        }

          return decryptedString
    }
    
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
