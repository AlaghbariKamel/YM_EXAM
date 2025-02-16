//
//  APIOrder.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

class APIOrder : APIOrderProtocol
{
    let baseAPi = BaseAPI<APIOrderNetwork>()
    func getOrders(completion: @escaping (Result<DeliveryBillsItems?, ServiceError>) -> Void) {
        baseAPi.fetchData(target: .getDeliveryBillsItems(dicValueData), responseClass: DeliveryBillsItems.self) { (reslut) in
            completion(reslut)
        }
    }
    
    var dicValueData: [String : Any] = [:]
    
    var dicValueURLQueryParameter: [String : Any] = [:]
    
    
    
}
