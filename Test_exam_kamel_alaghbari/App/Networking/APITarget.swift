//
//  APITarget.swift
//  CleanArchitecture
//
//  Created by Kamel Alaghbari on 05/02/2025.
//  Copyright © 2025 harsivo. All rights reserved.
//


enum TaskPostData {
    case requsetPlain
    case requestParameters(parameters: [String:Any])
}
enum TaskURLQueryParameter {
    case requsetPlain
    case requestURLQueryParameters(parameters: [String:Any])
}

protocol TargetType {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var taskPostData: TaskPostData {get}
    var taskURLQueryParameter: TaskURLQueryParameter {get}
    var headers: [String:String]? {get}
    
}

extension TargetType {
    var baseURL: String {  return APIPath.init().mainBaseURL}
    var headers: [String:String]?  {return [:] }
}
