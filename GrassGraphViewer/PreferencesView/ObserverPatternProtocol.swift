//
//  PreferencesObserver.swift - ObserverとSubjectのプロトコル
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/09.
//

import Foundation

protocol Subject {
    var observers: [Observer] { get set }
    
    mutating func addObserver(_ observer: Observer)
    mutating func removeObserver(_ observer: Observer)
    
    func notify(_ object: Any)
}

extension Subject {
    mutating func addObserver(_ observer: Observer){
        self.observers.append(observer)
    }
    
    mutating func removeObserver(_ observer: Observer){
        self.observers.removeAll{$0.id == observer.id}
    }
    
    func notify(_ object: Any){
        self.observers.forEach({$0.update(object)})
    }
}

protocol Observer {
    
    var id: String { get }
    
    func update(_ object: Any)
}

extension Observer {
    func update(_ object: Any){
         print(object)
    }
}

