//
//  APIPath.swift
//  CleanArchitecture
//
//  Created by richa on 15/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation


#if DEBUG
let environment = APIEnvironment.development
#else
let environment = APIEnvironment.production
#endif

let baseURL = environment.baseURL()

struct APIPath {
    var mainBaseURL: String { return baseURL }
    var getUsers: String { return "\(baseURL)/users"}
    var getPost: String { return "\(baseURL)/posts"}

}


