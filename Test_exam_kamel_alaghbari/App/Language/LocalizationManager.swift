//
//  LocalizationManager.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 06/02/2025.
//
import Foundation
import UIKit

protocol LocalizationDelegate: AnyObject {
    func resetApp()
}

class LocalizationManager: NSObject {
    enum LanguageDirection {
        case leftToRight
        case rightToLeft
    }
    
    enum LanguageApp: String {
        case English = "en"
        case Arabic = "ar"
    }
    
    static let shared = LocalizationManager()
    private var bundle: Bundle? = nil
    weak var delegate: LocalizationDelegate?
    
    // get currently selected language from el user defaults
    func getLanguage() -> LanguageApp?
    {
        if SharedDefault.languageKey.trimmingCharacters(in: .whitespaces).count == 0
        {
            return nil
        }
       
        return LanguageApp(rawValue: SharedDefault.languageKey)
 
    }
    
    // check if the language is available
    private func isLanguageAvailable(_ code: String) -> LanguageApp? {
        var finalCode = ""
        if code.lowercased().contains("ar") {
            finalCode = "ar"
        } else if code.lowercased().contains("en") {
            finalCode = "en"
        }
        return LanguageApp(rawValue: finalCode)
    }
    
    // check the language direction
    private func getLanguageDirection() -> LanguageDirection {
        if let lang = getLanguage() {
            switch lang {
            case .English:
                return .leftToRight
            case .Arabic:
                return .rightToLeft
            }
        }
        return .leftToRight
    }
   
    // get localized string for a given code from the active bundle
    func localizedString(for key: String, value comment: String) -> String
    {
 
        let localized = bundle!.localizedString(forKey: key, value: comment, table: nil)
 
        return localized
    }
    
    
    
    // set language for localization
    func setLanguage(language: LanguageApp)
    {
       
        SharedDefault.languageKey = language.rawValue
         
        
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        {
            bundle = Bundle(path: path.path)
            
        } else {
            // fallback
            resetLocalization()
        }
 
        resetApp()
    }
    
    // reset bundle
    func resetLocalization() {
        bundle = Bundle.main
    }
    
    // reset app for the new language
    func resetApp() {
        
        let dir = getLanguageDirection()
        var semantic: UISemanticContentAttribute!
        switch dir {
        case .leftToRight:
            semantic = .forceLeftToRight
        case .rightToLeft:
            semantic = .forceRightToLeft
        }
        UITabBar.appearance().semanticContentAttribute = semantic
        UIView.appearance().semanticContentAttribute = semantic
        UINavigationBar.appearance().semanticContentAttribute = semantic
        
           
        

        delegate?.resetApp()
    }
    
    // configure startup language
    func setAppInitLanguage() {
        if let selectedLanguage = getLanguage() {
            setLanguage(language: selectedLanguage)
        } else {
            
            // no language was selected
            let languageCode = Locale.preferredLanguages.first
            if let code = languageCode, let language = isLanguageAvailable(code) {
                setLanguage(language: language)
            } else {
                // default fall back
                setLanguage(language: .English)
            }
        }
        resetApp()
    }
    
    
  
     

       
    

}

extension String
{
    
    var localized: String
    {
        return LocalizationManager.shared.localizedString(for: self, value: "")
 
    }
    
    
}
