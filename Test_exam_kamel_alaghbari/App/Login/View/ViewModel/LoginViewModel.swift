//
//  LoginViewModel.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    
    
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    
    
    private var loginModelSubject = PublishSubject<LoginResponse?>()
    
    var loginModelObservable: Observable<LoginResponse?> {
        return loginModelSubject
    }
    
    var messageError = PublishSubject<String>()
    var messageErrorModelObservable: Observable<String> {
        return messageError
    }
    
    
    func login(loginRequest:LoginRequest)
    {
        
        loadingBehavior.accept(true)
        
        
        let jsonData = try? loginRequest.jsonData()
        
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
        guard let dictionary = json as? [String : Any] else {
            return
        }
        
        var api:APILoginProtocol = APILogin()
        api.dicValueData = dictionary
        api.login { [weak self] (reslut) in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            
            switch reslut
            {
                
            case .success(let resposne):
                
                guard let model = resposne else { return }
                
                loginModelSubject.onNext(model)
              
                
            case .failure(let error):
                
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
                
                
            }
        }
        
    }
    
}
