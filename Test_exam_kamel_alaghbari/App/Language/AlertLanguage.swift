//
//  AlertLanguage.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 06/02/2025.
//

import UIKit
final class AlertLanguage
{
    
    weak var delegate:IAlertDialogLanguage?
    static let sharedInstance: AlertLanguage = AlertLanguage()
    private var alertSetLanguage:SetLanguageVC?
    private init() { }
    
    
    //MARK: - showalertSetLanguage
    
    func showalertSetLanguage(_ uvc:UIViewController)
    {
        alertSetLanguage = nil
        alertSetLanguage = SetLanguageVC.instantiate(fromAppStoryboard: .Language)
        
        alertSetLanguage?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertSetLanguage?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        alertSetLanguage?.callBackOkButton = {[weak self] (langName: LocalizationManager.LanguageApp) in
             
             guard let self = self else {return}
           
            if  langName.rawValue == SharedDefault.languageKey
             {
                 self.delegate?.setLanguage(isLanguageUpdated: false)
                
             }
             else
             {
                 self.delegate?.setLanguage(isLanguageUpdated: true)
             }
 
            self.alertSetLanguage?.dismiss(animated: false)
         }
        
 
         uvc.present(alertSetLanguage!, animated: false)
    }
    
    
    func dissmisAlert()
    {
        if let vc = alertSetLanguage
        {
            vc.dismiss(animated: false)
        }
        
    }
 
}



protocol IAlertDialogLanguage : AnyObject {
    func setLanguage(isLanguageUpdated: Bool)
}
