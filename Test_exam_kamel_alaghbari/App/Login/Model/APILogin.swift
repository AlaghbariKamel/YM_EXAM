//
//  APILogin.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

class APILogin : APILoginProtocol
{
    let baseAPi = BaseAPI<APILoginNetworking>()
    func login(completion: @escaping (Result<LoginResponse?, ServiceError>) -> Void) {
        baseAPi.fetchData(target: .login(dicValueData), responseClass: LoginResponse.self) { (reslut) in
            completion(reslut)
        }
    }
    
    var dicValueData: [String : Any] = [:]
    
    var dicValueURLQueryParameter: [String : Any] = [:]
    
    
    
}
