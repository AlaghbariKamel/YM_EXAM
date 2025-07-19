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

final class OrderViewModel {
    
    
    var database: DbResult?
    var notificationToken: NotificationToken? = nil
    
   private var orderResults: Results<OrderEntity>?
//   private var loadedData: [OrderEntity] = []
      
    init()
    {
        
        database = DbResult.shared
        loadData()
    }
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var orderModelSubject = PublishSubject<Int>()
    
    var orderModelObservable: Observable<Int> {
        return orderModelSubject
    }
     
    
    var messageError = PublishSubject<String>()
    var messageErrorModelObservable: Observable<String> {
        return messageError
    }
    
    private func loadData() {
        orderResults = database?.getOrders()
        observeChanges()
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
                
                if(database!.getOrderCount() == 0)
                {
                    let orders = OrderMapper.map(model.data.deliveryBills)
                    database!.addOrders(orders)
//                    updateCachingTabel(list: model.data.deliveryBills)
                }
                orderModelSubject.onNext(model.data.deliveryBills.count)
                
            case .failure(let error):
                
                let errorMessage = "\(error.httpStatus) : \(error.message.replacingOccurrences(of: "URLSessionTask failed with error:", with: ""))"
                
                self.messageError.onNext(errorMessage)
                
                
                
            }
        }
        
    }
    
    func getNewOrderList()->[DeliveryBillDB] {
        return database!.getNewOrders()
    }
    
    func getOrderCount()-> Int {
        return database!.getOrderCount()
    }
    
    
    func getOtherOrderList(orderStatus: String = "0")->[DeliveryBillDB] {
        return database!.getOtherStatusOrders(orderStatus: orderStatus)
    }
    
    
 

    deinit {
        notificationToken?.invalidate()
    }
    
    private func observeChanges() {
        notificationToken = orderResults?.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial(let results):
                
                
                self.orderModelSubject.onNext(results.count)
                
                
            case .update(let results, _, _, _):
                
                self.orderModelSubject.onNext(results.count)
                
            case .error(let error):
                print("❌ Realm error: \(error.localizedDescription)")
            }
        }
     
        
         

    }
                 
}
