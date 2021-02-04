//
//  UserDefaultsExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Foundation

enum UserDefaultsKey: String {
    case UserName
    case UIEnabled
    case LastFetched
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
    
    func setValue(_ value: Any?, forKey key: UserDefaultsKey){
        self.setValue(value, forKey: key.rawValue)
    }
}
