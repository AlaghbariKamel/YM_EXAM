//
//  APINetwork.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


enum APILoginNetworking {


    case login([String:Any])
    
}
 
extension APILoginNetworking:TargetType
{
    
 
    var path: String {
        switch self {
   
        case  .login:
            return "CheckDeliveryLogin"
 
         
        }
        
    }
    
    var method: HTTPMethod {
       
            return .post
       
    }
    
    var taskPostData: TaskPostData {
        switch self {
   
        case .login(let dic) :
            return .requestParameters(parameters : dic)
        }
    }
    
    var taskURLQueryParameter: TaskURLQueryParameter {
        switch self {
 
        case .login(let dic) :
            return .requestURLQueryParameters(parameters : dic)
        }
    }
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
            
        }
    }
    
    
}



protocol APILoginProtocol {
    
 
    func login(completion: @escaping(Result<LoginResponse?,ServiceError>) -> Void)

    var dicValueData:[String:Any]
    {
        get
        set

    }
    var dicValueURLQueryParameter:[String:Any]
    {
        get
        set

    }
}
 



