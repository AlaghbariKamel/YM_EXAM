//
//  OrderEntity.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


import RealmSwift
// MARK: - DataList
final class OrderEntity: Object {
    
    @objc dynamic var OrderId: Int = 0
    @objc dynamic var OrderStatus: String?
    @objc dynamic var OrdeTotalPrice:String?
    @objc dynamic var OrderDate: String?
    
    override static func indexedProperties() -> [String] {
            return ["OrderId"] // Index the 'Id' property for faster querying
        }
    
    
   
}
