//
//  ResponseHandler+Extension.swift
//  CleanArchitecture
//
//  Created by richa on 16/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation
// MARK: Response Handler - parse default



extension ResponseHandler {
    func defaultParseResponse<T: Codable>(data: Data, response: HTTPURLResponse) throws -> T {
        let jsonDecoder = JSONDecoder()
        do {
            let body = try jsonDecoder.decode(T.self, from: data)
            if response.statusCode == 200 ||  response.statusCode == 201 {
                return body
            } else {
                throw ServiceError(httpStatus: response.statusCode, message: "Unknown Error")
            }
        } catch  {
            throw ServiceError(httpStatus: response.statusCode, message: error.localizedDescription)
        }
        
    }
}


