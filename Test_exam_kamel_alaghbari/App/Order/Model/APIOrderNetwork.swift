//
//  APIOrderNetwork.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


enum APIOrderNetwork {


    case getDeliveryBillsItems([String:Any])
    
}
 
extension APIOrderNetwork:TargetType
{
    
 
    var path: String {
        switch self {
   
        case  .getDeliveryBillsItems:
            return "GetDeliveryBillsItems"
 
         
        }
        
    }
    
    var method: HTTPMethod {
       
            return .post
       
    }
    
    var taskPostData: TaskPostData {
        switch self {
   
        case .getDeliveryBillsItems(let dic) :
            return .requestParameters(parameters : dic)
        }
    }
    
    var taskURLQueryParameter: TaskURLQueryParameter {
        switch self {
 
        case .getDeliveryBillsItems(let dic) :
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



protocol APIOrderProtocol {
    
 
    func getOrders(completion: @escaping(Result<DeliveryBillsItems?,ServiceError>) -> Void)

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
 



