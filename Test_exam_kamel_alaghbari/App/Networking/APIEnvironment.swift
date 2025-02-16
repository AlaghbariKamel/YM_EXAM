//
//  APIEnvironment.swift
//  CleanArchitecture
//
//  Created by richa on 15/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation
enum APIEnvironment {
    case development
    case staging
    case production
    
    func baseURL () -> String {
        return "https://\(domain())/"
    }
    
    func domain() -> String {
        switch self {
        case .development, .production, .staging:
            return  "mdev.yemensoft.net:473/OnyxDeliveryService/Service.svc"
//            return "jsonplaceholder.typicode.com"
        
        }
    }
    
    func subdomain() -> String {
        switch self {
        case .development, .production, .staging:
            return "api"
        }
    }
    
    func route() -> String {
        return "/api/v1"
    }
}
