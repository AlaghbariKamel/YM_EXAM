//
//  SetLanguageVC.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 06/02/2025.
//

import UIKit

class SetLanguageVC: UIViewController {
    
    
    private var selectedLanguage: LocalizationManager.LanguageApp? = nil
    @IBOutlet weak var arabicView: UIView!
    
    @IBOutlet weak var englishView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let vAr = UITapGestureRecognizer(target: self, action: #selector(tapClickedArLanguage(_:)))
       
        arabicView.isUserInteractionEnabled = true
        arabicView.addGestureRecognizer(vAr)
        
        
        let vEn = UITapGestureRecognizer(target: self, action: #selector(tapClickedEnLanguage(_:)))
        
        englishView.isUserInteractionEnabled = true
        englishView.addGestureRecognizer(vEn)
        
        if SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue{
            selectedLanguage = LocalizationManager.LanguageApp.Arabic
            changeUiViewLanguageBgColor()
        }
        else{
            selectedLanguage = LocalizationManager.LanguageApp.English
            changeUiViewLanguageBgColor()
        }
        
        
    }
    
    @IBAction func btnApplayLanguage(_ sender: UIButton) {
        
        if sender.isEnabled{
            
            if let selectedLanguage = selectedLanguage{
                callBackOkButton?(selectedLanguage)
            }
            
//            self.dismiss(animated: true)
        }
        
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.isEnabled = true
        }
        
        
    }
    
    var callBackOkButton: ((_ langName: LocalizationManager.LanguageApp)-> Void)?
    
    @objc private func tapClickedArLanguage(_ sender: UITapGestureRecognizer)
    {
        selectedLanguage = LocalizationManager.LanguageApp.Arabic
        changeUiViewLanguageBgColor()
        
    }
    
    
    @objc private func tapClickedEnLanguage(_ sender: UITapGestureRecognizer)
    {
        
        selectedLanguage = LocalizationManager.LanguageApp.English
        changeUiViewLanguageBgColor()
        
    }
    
    func changeUiViewLanguageBgColor()
    {
        if selectedLanguage == LocalizationManager.LanguageApp.Arabic {
            
            arabicView.backgroundColor = UIColor.init(hexaString: "#CBFFCB")
            arabicView.borderColor = UIColor.init(hexaString: "#39A238")
            
            englishView.backgroundColor = .white
            englishView.borderColor = UIColor.init(hexaString: "#0A3F8F")
        }
        
        else  {
            
            englishView.backgroundColor = UIColor.init(hexaString: "#CBFFCB")
            englishView.borderColor = UIColor.init(hexaString: "#39A238")
            
            arabicView.backgroundColor = .white
            arabicView.borderColor = UIColor.init(hexaString: "#0A3F8F")
        }
    }
    
}
//
//extension SetLanguageVC{
//    
//    @objc func tapSelectLanguage(_ sender:CustomTapGesture)
//    {
//        getSelectedLanguageTap = sender.selectedLanaguage
//        
//    }
//    
//    
//    private struct SelectedLanguageTaped
//    {
//        static var varSelectedLanguageTap: LocalizationManager.LanguageApp? = .English
//    }
//    
//    var getSelectedLanguageTap: LocalizationManager.LanguageApp?
//    {
//        get { return SelectedLanguageTaped.varSelectedLanguageTap }
//        set { SelectedLanguageTaped.varSelectedLanguageTap = newValue }
//    }
//    
//}
//
//class CustomTapGesture: UITapGestureRecognizer {
//    var selectedLanaguage:LocalizationManager.LanguageApp = LocalizationManager.LanguageApp.English
//    
//}
