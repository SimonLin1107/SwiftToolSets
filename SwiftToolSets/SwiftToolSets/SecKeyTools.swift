import Foundation
import Security

open class SecKeyTools {
    
    public static func generateRsaKeyPair(keySize: Int) -> (SecKey?, SecKey?) {
        
        var publicKey: SecKey?
        var privateKey: SecKey?
        SecKeyGeneratePair([kSecAttrKeyType:kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits:keySize] as CFDictionary, &publicKey, &privateKey)
        
        return (publicKey, privateKey)
        
    }
    
    public static func createBase64From(key: SecKey) -> String? {
        var error:Unmanaged<CFError>?
        if let cfData = SecKeyCopyExternalRepresentation(key, &error) {
            let data = cfData as Data
            let b64 = data.base64EncodedString()
            return b64
        }
        return nil
    }
    
    public static func createPublicKeyFrom(base64: String) -> SecKey? {
        if let data = Data.init(base64Encoded: base64) {
            
            let dic:[NSObject:NSObject] = [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits: NSNumber(value: 1024),
                kSecReturnPersistentRef: true as NSObject
            ]
            
            if let key = SecKeyCreateWithData(data as CFData, dic as CFDictionary, nil) {
                return key
            }
            
        }
        return nil
    }
    
    public static func createPrivateKeyFrom(base64: String) -> SecKey? {
        if let data = Data.init(base64Encoded: base64) {
            
            let dic:[NSObject:NSObject] = [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                kSecAttrKeySizeInBits: NSNumber(value: 1024),
                kSecReturnPersistentRef: true as NSObject
            ]
            
            if let key = SecKeyCreateWithData(data as CFData, dic as CFDictionary, nil) {
                return key
            }
            
        }
        return nil
    }
    
    public static func encryptStringBy(publicKey: SecKey, secKeyAlgorithm: SecKeyAlgorithm, source: String) -> String? {
        if let data = source.data(using: String.Encoding.utf8) {
            var error: Unmanaged<CFError>?
            if let resData = SecKeyCreateEncryptedData(publicKey, secKeyAlgorithm, data as CFData, &error) as Data? {
                return resData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: Data.Base64EncodingOptions.lineLength64Characters.rawValue))
            }
        }
        return nil
    }
    
    public static func decryptStringBy(privateKey: SecKey, secKeyAlgorithm: SecKeyAlgorithm, source:String) -> String? {
        
        if let data = Data(base64Encoded: source, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            var error: Unmanaged<CFError>?
            if let resData =  SecKeyCreateDecryptedData(privateKey, secKeyAlgorithm, data as CFData, &error) as Data? {
                return String(data: resData, encoding: String.Encoding.utf8)
            }
            
        }
        
        return nil
    }
    
}
