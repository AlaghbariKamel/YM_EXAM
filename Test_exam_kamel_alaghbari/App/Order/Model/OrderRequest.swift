//
//  OrderRequest.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//



import Foundation

// MARK: - OrderReuests
struct OrderReuest: Codable {
    let value: OrderValue

    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}

// MARK: - Value
struct OrderValue: Codable {
    let pDlvryNo, pLangNo, pBillSrl, pPrcssdFlg: String

    enum CodingKeys: String, CodingKey {
        case pDlvryNo = "P_DLVRY_NO"
        case pLangNo = "P_LANG_NO"
        case pBillSrl = "P_BILL_SRL"
        case pPrcssdFlg = "P_PRCSSD_FLG"
    }
}



enum DeliveryStatusType: String {
    
    case new = "0"
    case delivered = "1"
    case partialReturn = "2"
    case fullReturn = "3"

    var description: String {
        switch self {
        case .new:
            return "New"
        case .delivered:
            return "Delivered"
        case .partialReturn:
            return "مردود جزئي"
        case .fullReturn:
            return "Returned"
        }
    }
}
