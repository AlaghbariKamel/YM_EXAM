//
//  DbResult.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//
import RealmSwift
class DbResult  {
    static let shared:DbResult = DbResult()
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    var realm: Realm?
    
    private init() {
        
        
        do {
            // Initialize Realm safely with error handling
            realm = try Realm(configuration: config)
        } catch {
            print("Failed to open Realm database: \(error)")
            realm = nil
        }
    }
    
    
     
    
    func deleteCache() {
        guard let realm = realm else { return } // Ensure `realm` is not nil

        do {
            try realm.write {
                // Delete all objects from the realm
                realm.deleteAll()
            }
        } catch {
            print("Error deleting all objects from Realm: \(error)")
        }
    }
    
    
    func getOrderCount() -> Int {
        guard let realm = realm else { return 0 } // Ensure `realm` is not nil
        return realm.objects(OrderEntity.self).count
    }
 
    
    func getOrders() -> [DeliveryBillDB]
    {
        guard let realm = realm else {
            print("Realm is not initialized.")
            return []
        }

        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self)
        for item in list {
            orders.append(DeliveryBillDB(  billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    func getNewOrders() -> [DeliveryBillDB]
    {
        guard let realm = realm else {
            print("Realm is not initialized.")
            return []
        }

        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self).filter({$0.OrderStatus == "0"})
        for item in list {
            orders.append(DeliveryBillDB(  billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    
    func getOtherStatusOrders(orderStatus: String = "0") -> [DeliveryBillDB]
    {
        guard let realm = realm else {
            print("Realm is not initialized.")
            return []
        }

        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self).filter("OrderStatus != %@ AND OrderStatus != ''", orderStatus, true)
        for item in list {
            orders.append(DeliveryBillDB(  billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    
    
}




struct DeliveryBillDB: Codable {
    let  billSrl, billDate: String?
    let  billAmt: String?
    let dlvryStatusFlg: String?
}
