//
//  AppCoordinator.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 04/02/2025.
//


import UIKit


class AppCoordinator {
    
    private let window: UIWindow
    var oldLanguage = ""
    
 
    
    init(with window: UIWindow)
    {
        oldLanguage = SharedDefault.languageKey
        self.window = window
        LocalizationManager.shared.delegate = self
        LocalizationManager.shared.setAppInitLanguage()
    }
    
    
    func startApp()
    {
        
       
       let vc = SplashVC.instantiate(fromAppStoryboard: .Splash)
 
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationController?.navigationBar.backgroundColor = UIColor.secondarySystemGroupedBackground
        vc.navigationController?.navigationBar.tintColor = .systemRed
      
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        vc.navigationController?.navigationBar.standardAppearance = appearance
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
 
    }
}


extension AppCoordinator: LocalizationDelegate {

    func resetApp()
    {
        
        if oldLanguage != LocalizationManager.shared.getLanguage()?.rawValue
        {
            startApp()
        }
    }
    
}
