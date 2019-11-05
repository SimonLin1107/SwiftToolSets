//
//  StringTools.swift
//  Football
//
//  Created by Apple on 2019/11/5.
//  Copyright © 2019 SportsTracker. All rights reserved.
//

import Foundation

open class StringTools {
    public static func codableObjectToBase64<T: Codable>(obj:T) -> String? {
        do {
            let data = try JSONEncoder().encode(obj)
            return data.base64EncodedString()
        } catch {
        }
        return nil
    }
    
    public static func base64ToCodableObject<T: Codable>(base64:String) -> T? {
        
        if let data = Data(base64Encoded: base64) {
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                return obj
            } catch {
            }
        }
        return nil
        
    }
    
    public static func stringToBase64(string: String) -> String? {
        let utf8EncodeData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String
    }
    
    public static func base64ToString(base64: String) -> String? {
        if let base64Data = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0)) {
            if let stringWithDecode = String(data: base64Data, encoding: String.Encoding.utf8) {
                return stringWithDecode
            }
        }
        return nil
    }
    
    public static func htmlStringToAttributedString(html: String) -> NSAttributedString? {
        
        if let data = html.data(using: String.Encoding.utf8) {
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                
            }
        }
        
        return nil
    }
}
