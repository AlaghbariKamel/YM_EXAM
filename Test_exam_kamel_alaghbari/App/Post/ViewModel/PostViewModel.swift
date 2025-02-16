//
//  PostViewModel.swift
//  CleanArchitecture
//
//  Created by Kamel Alaghbari on 05/02/2025.
//  Copyright © 2025 harsivo. All rights reserved.
//


import Foundation
import RxCocoa
import RxSwift

class PostViewModel {
    
  
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
   
    private var allPostsModelSubject = PublishSubject<[ResponsePost]>()
    
    var allPostsModelObservable: Observable<[ResponsePost]> {
        return allPostsModelSubject
    }
    
    private var onePostsModelSubject = PublishSubject<ResponsePost?>()
    
    var onePostsModelObservable: Observable<ResponsePost?> {
        return onePostsModelSubject
    }
    
    var messageError = PublishSubject<String>()
    var messageErrorModelObservable: Observable<String> {
        return messageError
    }
   
    
    
    func getAllPosts()
    {
        self.loadingBehavior.accept(true)
        
        let api:PostAPIProtocol = PostAPI()
        api.getAllPosts { [weak self] (reslut) in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
           
            switch reslut
            {
            
            case .success(let resposne):
                
                guard let model = resposne else { return }
                
                allPostsModelSubject.onNext(model)
                print(model)
                
            case .failure(let error):
  
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
 
                
            }
        }
        
        
    }
    
    
    func getPost(postId:Int)
    {
        self.loadingBehavior.accept(true)
       
        var api:PostAPIProtocol = PostAPI()
        api.postId = String(postId)
        api.getPost { [weak self] (reslut) in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
           
            switch reslut
            {
            
            case .success(let resposne):
                
                guard let model = resposne else { return }
                
                onePostsModelSubject.onNext(model)
                print(model)
                
            case .failure(let error):
  
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
 
                
            }
        }
        
        
    }
    
    
    func addPost(post:ResponsePost)
    {
       
        loadingBehavior.accept(true)
       
        
        let jsonData = try? post.jsonData()
        
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
        guard let dictionary = json as? [String : Any] else {
            return
        }
        
        var api:PostAPIProtocol = PostAPI()
        api.dicValuePostData = dictionary
        api.addPost { [weak self] (reslut) in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
           
            switch reslut
            {
            
            case .success(let resposne):
                
                guard let model = resposne else { return }
                
                onePostsModelSubject.onNext(model)
                print(model)
                
            case .failure(let error):
  
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
 
                
            }
        }
        
        
    }
    
}
    
 
  
