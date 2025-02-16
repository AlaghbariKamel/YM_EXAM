//
//  APILoader.swift
//  CleanArchitecture
//
//  Created by richa on 15/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation

struct BaseAPI<T:TargetType> {

    var urlSession: URLSession

    init (urlSession:URLSession = .shared)
    {
        self.urlSession = urlSession
    }

   
    
    func fetchData<M: Codable>(target:T,responseClass: M.Type, completionHandler:@escaping (Result<M?,ServiceError>) -> Void)
    {

      
        

        if let urlRequest = target.makeRequest(target: target) {

            print("resuqst")
            urlSession.dataTask(with: urlRequest) { data, response, error in

                if let httpResponse = response as? HTTPURLResponse {
//
                    
                    print(httpResponse.statusCode)
                    guard error == nil else {
                        let serviceError = ServiceError(httpStatus: httpResponse.statusCode, message: "ServiceError : \(error?.localizedDescription ?? "Unknown Error")")
                        completionHandler(.failure(serviceError))
                        print(serviceError)
                        return
                    }

                    let serviceError = ServiceError(httpStatus: httpResponse.statusCode, message: "ServiceError : \(error?.localizedDescription ?? "Unknown Error")")
                  
                    
                    guard let responseData = data else {
    
                        completionHandler(.failure(serviceError))
                        print(serviceError)
                        return
                    }

                    
                    
                        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201
                        {

//                            if (!JSONSerialization.isValidJSONObject(responseData))
//                            {
//                                print("is not a valid json object")
//
//                                guard let responseOjb = try? JSONDecoder().decode(M.self, from: responseData)
//                                else {
//
//
//                                    completionHandler(.failure(serviceError))
//                                    print(serviceError)
//                                    return
//                                }
//
//                                completionHandler(.success(responseOjb))
//
////
////
//                            }
//                            else
//                            {

//                                guard let theJSONData = try? JSONSerialization.data(withJSONObject: responseData, options: JSONSerialization.WritingOptions.prettyPrinted) else {
//                                    print(serviceError)
//                                    completionHandler(.failure(serviceError))
//                                    return
//                                }
                           
//#if DEBUG
//                            let responseString = String(data: responseData, encoding: .utf8)
//                            print(responseString)
//
//#endif
                                guard let responseOjb = try? JSONDecoder().decode(M.self, from: responseData)  else {
                                    print(serviceError)
                                    completionHandler(.failure(serviceError))
                                    return
                                }
//                                print(responseOjb)
                                completionHandler(.success(responseOjb))
                            }

//                        }


                }


            }.resume()


    }


    }
    
}

//MARK -:

