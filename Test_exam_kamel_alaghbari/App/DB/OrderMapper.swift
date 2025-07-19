//
//  OrderMapper.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 19/07/2025.
//
import RealmSwift
import Foundation
 
final class OrderMapper {
    
   static func map(_ items: [DeliveryBill]?) -> [OrderEntity] {
       
       guard let items else { return [] }
       let orderObjcts = items.map { item -> OrderEntity in
           
           
           let dataTable = OrderEntity()
          
           dataTable.OrderId = Int(item.billSrl ?? "0") ?? 0
           dataTable.OrderStatus = item.dlvryStatusFlg ?? ""
           dataTable.OrdeTotalPrice = item.billAmt ?? ""
           dataTable.OrderDate = item.billDate  ?? ""
           
           
           return dataTable
       }
       return orderObjcts
   }
    
    
    static func map(_ items: [OrderEntity]?) -> [DeliveryBillDB] {
        
        guard let items else { return [] }
        let deliveryBillObjcts = items.map { item -> DeliveryBillDB in
            
            
            let deliveryBill = DeliveryBillDB( billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus)
            
            
            return deliveryBill
        }
        return deliveryBillObjcts
    }
    
    
   
    
    
}
