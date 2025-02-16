//
//  ServiceError.swift
//  CleanArchitecture
//
//  Created by Kamel Alaghbari on 05/02/2025.
//  Copyright © 2025 harsivo. All rights reserved.
//

import Foundation
struct ServiceError: Error,Codable {
    let httpStatus: Int
    let message: String
}

