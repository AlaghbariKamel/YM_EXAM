//
//  OrderViewModel.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class OrderViewModel {
    
    
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var orderModelSubject = PublishSubject<DeliveryBillsItems?>()
    
    var orderModelObservable: Observable<DeliveryBillsItems?> {
        return orderModelSubject
    }
     
    
    var messageError = PublishSubject<String>()
    var messageErrorModelObservable: Observable<String> {
        return messageError
    }
    
    
    func getOrders(orderReuest:OrderReuest)
    {
        
        loadingBehavior.accept(true)
        
        
        let jsonData = try? orderReuest.jsonData()
        
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
        guard let dictionary = json as? [String : Any] else {
            return
        }
        
        var api:APIOrderProtocol = APIOrder()
        api.dicValueData = dictionary
        api.getOrders { [weak self] (reslut) in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            
            switch reslut
            {
                
            case .success(let resposne):
                
                guard let model = resposne else { return }
                
                orderModelSubject.onNext(model)
                if(DbResult.shared.getOrderCount() == 0)
                {
                    updateCachingTabel(list: model.data.deliveryBills)
                }
               
                
            case .failure(let error):
                
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
                
                
            }
        }
        
    }
    
    func getNewOrderList()->[DeliveryBillDB] {
        return DbResult.shared.getNewOrders()
    }
    
    func getOrderCount()-> Int {
        return DbResult.shared.getOrderCount()
    }
    
    
    func getOtherOrderList(orderStatus: String = "0")->[DeliveryBillDB] {
        return DbResult.shared.getOtherStatusOrders(orderStatus: orderStatus)
    }
    
    
    func updateCachingTabel( list: [DeliveryBill]?) {
        
        if let listData = list , listData.count > 0
        {
            
            let realm = try? Realm()
            for item in list ?? []
            {
    
                
                let dataTable = OrderEntity()
                dataTable.OrderId = Int(item.billSrl ?? "0") ?? 0
                dataTable.OrderStatus = item.dlvryStatusFlg ?? ""
                dataTable.OrdeTotalPrice = item.billAmt ?? ""
                dataTable.OrderDate = item.billDate  ?? ""
                
                do {
                    
                    try realm!.write { realm!.add(dataTable)}
                    
                }
                catch  { print("Error inistiallising new realm, \(error)") }
            }
        }
    }
                 
}
