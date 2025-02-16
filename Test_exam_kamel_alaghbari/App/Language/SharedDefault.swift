//
//  SharedDefault.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 06/02/2025.
//

import Foundation
 
private struct UserDefaultInfo<Value> {
    var key: String
    var defaultValue: Value
}
private extension UserDefaultInfo {
    
    func get() -> Value
    {
         
        guard let valueUntyped = UserDefaults.standard.object(forKey: self.key) else {
            return self.defaultValue
        }
        guard let value = valueUntyped as? Value else {
            return self.defaultValue
        }
        return value
    }
    
    func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: self.key)
        UserDefaults.standard.synchronize()
    }
    
    

    
}

enum SharedDefault
{

   
    
    static var languageKey : String
    {
        get { return varLanguage.get() }
        set { varLanguage.set(newValue) }
    }
    
   
    private static var varLanguage = UserDefaultInfo(key:K.languageAppKey, defaultValue: LocalizationManager.LanguageApp.Arabic.rawValue)
 
}

 


struct K {
    static let languageAppKey = "LangAppKey"
    
}
