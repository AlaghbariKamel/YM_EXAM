//
//  RequestHandler+Extension.swift
//  CleanArchitecture
//
//  Created by richa on 16/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation
// MARK: Request Handler Supporting methods

extension TargetType {
    
    func setQueryParams(parameters:[String: Any], url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: String(describing: element.value) ) }
        return components?.url ?? url
    }
    
  
    func setDefaultHeaders(parameters:[String: String],varURLRequest: inout URLRequest)  {
   
         
        varURLRequest.setValue(APIConstant.APIHeaders.contentTypeValue, forHTTPHeaderField: APIConstant.APIHeaders.kContentType)
        if parameters.count > 0
        {
 
            parameters.forEach {varURLRequest.addValue($0.key, forHTTPHeaderField: $0.value)}
        }
 
        
    }
    
    func bulidParamsQueryItems(task: TaskURLQueryParameter) -> ([String:Any]) {
   
       switch task
       {
           
       case .requsetPlain:
           return ([:])
       case .requestURLQueryParameters(parameters: let param):
           
           return param
       }
       
    
       
   }

   func bulidParams(task:TaskPostData) -> ([String:Any]) {
       
       switch task
       {
           
       case .requsetPlain:
           return ([:])
       case .requestParameters(parameters: let param):
           return (param)
       }
   }
    
    func makeRequest(target:TargetType) -> URLRequest? {
//        let urlString =  APIPath().posts
        let urlString = "\(target.baseURL)\(target.path)"
        print(urlString)
        if var url = URL(string: urlString) {
           
           
        
            let varMethod =  target.method.rawValue
            let varHeaders = target.headers ?? [:]
            let varParams =  bulidParams(task:  target.taskPostData)
            let varURLParams = bulidParamsQueryItems(task:target.taskURLQueryParameter)
            
            if varURLParams.count > 0 {
               
                url =  setQueryParams(parameters: varURLParams, url: url)
            }
            var urlRequest = URLRequest(url: url)
            setDefaultHeaders(parameters: varHeaders, varURLRequest: &urlRequest)
          
            urlRequest.httpMethod = varMethod
            if varMethod != HTTPMethod.get.rawValue
            {
                
 
           let requestBody =  try? JSONSerialization.data(withJSONObject: varParams, options: [])
                urlRequest.httpBody =  requestBody
            }
 
            
            
            return urlRequest
        }
        return nil
    }
   
}


