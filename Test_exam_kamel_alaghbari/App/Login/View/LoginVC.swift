//
//  LoginVC.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    private var viewModel: LoginViewModel? = nil
    private let disposeBag = DisposeBag()
    
    private var oldLanguage =  SharedDefault.languageKey
    
    
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var lbLogBack: UILabel!
    @IBOutlet weak var lbWlecomBack: UILabel!
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var txtUserId: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel()
        
        subscribeToLoading()
        subscribeToErrorMessage()

        subscribeToResponse()
        flipLogoImage()
       
        
        // Do any additional setup after loading the view.
    }
    
    func flipLogoImage()
    
    {
        if SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue {
            imgLogo.image = imgLogo.image?.imageFlippedForRightToLeftLayoutDirection()
        }
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        LocalizationManager.shared.delegate = self
        AlertLanguage.sharedInstance.delegate = self
        resetAppLanguage()
      
    }
    
    func subscribeToErrorMessage()
    {
        viewModel?.messageError.subscribe(onNext: {[weak self] errorMessage in
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.displayMessage(titleMsg: "Error", message:  "\(errorMessage)" , messageStatus: .MessageError)
                
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeToLoading()
    {
        viewModel?.loadingBehavior.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingDialog()
                } else {
                    
                    self.hideMyDialog()
                }
            }
        }).disposed(by: disposeBag)
    }

    
    
    func subscribeToResponse()
    {
        
        viewModel?.loginModelObservable.subscribe(onNext: {[weak self] result in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let result = result, result.result.errNo == 0
                {
                   
                    self.txtUserId.text = ""
                    self.txtPassword.text = ""
                    
                    let vc = OrderVC.instantiate(fromAppStoryboard: .Order)
                    vc.userName = result.data.deliveryName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.displayMessage(message: "Error check you login info", messageStatus: .MessageError)
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    @objc private func submitLogin() {
        
        guard
            let userIdText = txtUserId.text, !userIdText.isEmpty,
            let password = txtPassword.text, !password.isEmpty
             
        else {
            self.displayMessage(message: "Please fill all fields correctly.",messageStatus: .MessageError)
            return
        }

       
        let loginValue = LoginValue(pLangNo: userIdText, pDlvryNo: "1010", pPsswrd: password)
        let loginRequest = LoginRequest(value: loginValue)

        if InternetConnectionManager.isConnectedToNetwork()
        {
            viewModel?.login(loginRequest: loginRequest)
        }
        else
        {
            
            self.displayMessage(titleMsg: "Warning", message: "No Internet Connection", messageStatus: .MessageError)
        }
       
 
    }

    
    @IBAction func btnSetLanuage(_ sender: UIButton) {
        
         
            // your code
            
            if sender.isEnabled {
                
                AlertLanguage.sharedInstance.showalertSetLanguage(self)
            }
            
            sender.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                sender.isEnabled = true
            }
            
         
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if sender.isEnabled {
            
            submitLogin()
        }
        
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.isEnabled = true
        }
        
    }
    

   
    
    
}


extension LoginVC: LocalizationDelegate {
    
    func resetApp()
    {
       
        resetAppLanguage()
    }
    
    func resetAppLanguage()
    {
        
       
        if oldLanguage != LocalizationManager.shared.getLanguage()?.rawValue
        {
           
            oldLanguage = SharedDefault.languageKey
            
            flipLogoImage()
            lbWlecomBack.text = LocalizationKey.welcomeBack.localized
            lbLogBack.text = LocalizationKey.logoBack.localized
            
            txtPassword.placeholder = LocalizationKey.password.localized
            txtUserId.placeholder = LocalizationKey.userId.localized
            
            buttonLogin.setTitle(LocalizationKey.login.localized, for: .normal)
            buttonLogin.setTitle(LocalizationKey.login.localized, for: .disabled)
            buttonLogin.setTitle(LocalizationKey.login.localized, for: .selected)
            
            btnShowMore.setTitle(LocalizationKey.showMore.localized, for: .normal)
            btnShowMore.setTitle(LocalizationKey.showMore.localized, for: .disabled)
            btnShowMore.setTitle(LocalizationKey.showMore.localized, for: .selected)
          
            UIApplication.shared.getActiveMainKeyWindow?.reload()
        }
    }
}
   

extension LoginVC: IAlertDialogLanguage {
    func setLanguage(isLanguageUpdated: Bool)
    {
        if isLanguageUpdated
        {
            if LocalizationManager.shared.getLanguage() == .Arabic {
                LocalizationManager.shared.setLanguage(language: .English)
            } else {
                LocalizationManager.shared.setLanguage(language: .Arabic)
            }
        }
    }
    
    
}
