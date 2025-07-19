//
//  DbResult.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//
import RealmSwift
class DbResult  {
    
    
    static let shared = DbResult()
    
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    private init() {}
    
    private func getRealmInstance() -> Realm {
        if let realm = Thread.current.threadDictionary["realmInstance"] as? Realm {
            return realm
        }
        do {
            let realm = try Realm(configuration: config)
            Thread.current.threadDictionary["realmInstance"] = realm
            return realm
        } catch {
            fatalError("Failed to open Realm database: \(error)")
        }
    }
    
    
    
    
    
    func deleteCache() {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = self.getRealmInstance()
                do {
                    try realm.write {
                        // Delete all objects from the realm
                        realm.deleteAll()
                    }
                } catch {
                    print("Error deleting all objects from Realm: \(error)")
                }
            }
            
        }
    }
    
    func getOrderCount() -> Int {
        let realm = self.getRealmInstance() // Ensure `realm` is not nil
        return realm.objects(OrderEntity.self).count
    }
    
    func getOrders() -> Results<OrderEntity>?
    {
        let realm = self.getRealmInstance()
        
        
        let list = realm.objects(OrderEntity.self)
        return list
    }
    
    func getOrders() -> [DeliveryBillDB]
    {
        let realm = self.getRealmInstance()
        
        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self)
        for item in list {
            orders.append(DeliveryBillDB(billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    func getNewOrders() -> [DeliveryBillDB]
    {
        let realm = self.getRealmInstance()
        
        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self).filter({$0.OrderStatus == "0"})
        print(list.count)
        for item in list {
            orders.append(DeliveryBillDB( billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    
    func getOtherStatusOrders(orderStatus: String = "0") -> [DeliveryBillDB]
    {
        let realm = self.getRealmInstance()
        
        var orders: [DeliveryBillDB] = []
        // Use compactMap to filter out nil or empty values
        let list = realm.objects(OrderEntity.self).filter("OrderStatus != %@ AND OrderStatus != ''", orderStatus, true)
        for item in list {
            orders.append(DeliveryBillDB(  billSrl: String(item.OrderId), billDate: item.OrderDate, billAmt: item.OrdeTotalPrice, dlvryStatusFlg: item.OrderStatus) )
        }
        return orders
    }
    
    
    func addOrders(_ orders: [OrderEntity])
    {
        guard !orders.isEmpty else { return }
        
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = self.getRealmInstance()
                
                do {
                    try realm.write {
                        realm.add(orders, update: .modified)
                    }
                    print("✅ Orders added successfully in background")
                } catch {
                    print("❌ Error writing Orders to Realm: \(error)")
                }
            }
        }
    }
    
    
    
    
    
    
}



