//
//  UserDefaultsExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case UserName
    case UIEnabled
    case LastFetched
    
    case StoredConfigurations
}

extension UserDefaults {

    func string(forKey key: UserDefaultsKey) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    func integer(forKey key: UserDefaultsKey) -> Int? {
        return self.integer(forKey: key.rawValue)
    }
    
    func double(forKey key: UserDefaultsKey) -> Double? {
        return self.double(forKey: key.rawValue)
    }
    
    func array(forKey key: UserDefaultsKey) -> Array<Any>? {
        return self.array(forKey: key.rawValue)
    }
    
    func bool(forKey key: UserDefaultsKey) -> Bool? {
        return self.bool(forKey: key.rawValue)
    }
    
    func data(forKey key: UserDefaultsKey) -> Data? {
        return self.data(forKey: key.rawValue)
    }
    
    func dictionary(forKey key: UserDefaultsKey) -> [String: Any]? {
        return self.dictionary(forKey: key.rawValue)
    }
    
    func float(forKey key: UserDefaultsKey) -> Float? {
        return self.float(forKey: key.rawValue)
    }
    
    func object(forKey key: UserDefaultsKey) -> Any? {
        return self.object(forKey: key.rawValue)
    }
    
    func date(forKey key: UserDefaultsKey) -> Date?{
        return self.date(forKey: key.rawValue)
    }
    
    func date(forKey key: String) -> Date?{
        let storedTimeInterval = self.double(forKey: key)
        return Date(timeIntervalSince1970: storedTimeInterval)
    }
    
    func codable<T: Codable>(forKey key: UserDefaultsKey, type: T) -> T?{
        return self.codable(forKey: key.rawValue, type: type)
    }
    
    func codable<T: Codable>(forKey key: String, type: T) -> T?{
        // JSONをvalueに戻して
        let decoder = JSONDecoder()
        guard let value = self.string(forKey: key) else{return nil}
        guard let decoded = try? decoder.decode(T.self, from: value.data(using: .utf8)!) else{return nil}
        
        return decoded as T
    }
    
    func setValue(_ value: Any?, forKey key: UserDefaultsKey){
        self.setValue(value, forKey: key.rawValue)
    }
    
    // Date型拡張
    func setValue(_ value: Date?, forKey key: String){
        guard value != nil else {return}
        let timeInterval = value!.timeIntervalSince1970
        self.setValue(timeInterval, forKey: key)
    }
    
    // Codable拡張
    func setStruct<T: Codable>(_ value: T?, forKey key: UserDefaultsKey){
        self.setStruct(value, forKey: key.rawValue)
    }
    
    func setStruct<T: Codable>(_ value: T?, forKey key: String){
        // valueをJSONに直して
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(value) else {
            fatalError("Couldn't encode!")
        }
        
        // Stringに変換して保存
        let encodedJsonString = String(bytes: encoded, encoding: .utf8)!
        self.setValue(encodedJsonString, forKey: key)
    }

}
