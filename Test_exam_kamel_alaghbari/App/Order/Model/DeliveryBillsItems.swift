//
//  DeliveryBillsItems.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deliveryBillsItems = try? JSONDecoder().decode(DeliveryBillsItems.self, from: jsonData)

//   {
//"BILL_TYPE": "1",
//"BILL_NO": "3",
//"BILL_SRL": "210526001000023",
//"BILL_DATE": "26/05/2021",
//"BILL_TIME": "14:22:44",
//"BILL_AMT": "5714.285714285712",
//"TAX_AMT": "285.7142857142856",
//"DLVRY_AMT": "1200",
//"MOBILE_NO": "+201155500475",
//"CSTMR_NM": "Mohamed Farouk",
//"RGN_NM": "منطقة الزبيري",
//"CSTMR_BUILD_NO": "1",
//"CSTMR_FLOOR_NO": "2",
//"CSTMR_APRTMNT_NO": "55",
//"CSTMR_ADDRSS": "Alzubairi",
//"LATITUDE": "",
//"LONGITUDE": "",
//"DLVRY_STATUS_FLG": "2"
//},
import Foundation

// MARK: - DeliveryBillsItems
struct DeliveryBillsItems: Codable {
    let data: DeliveryData
    let result: ResultResponse

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case result = "Result"
    }
}

// MARK: - DataClass
struct DeliveryData: Codable {
    let deliveryBills: [DeliveryBill]

    enum CodingKeys: String, CodingKey {
        case deliveryBills = "DeliveryBills"
    }
}

// MARK: - DeliveryBill
struct DeliveryBill: Codable {
    let billType, billNo, billSrl, billDate: String?
    let billTime, billAmt, taxAmt, dlvryAmt: String?
    let mobileNo, cstmrNm: String?
    let rgnNm: String?
    let cstmrBuildNo, cstmrFloorNo, cstmrAprtmntNo: String?
    let cstmrAddrss: String?
    let latitude: String?
    let longitude: String?
    let dlvryStatusFlg: String?

    enum CodingKeys: String, CodingKey {
        case billType = "BILL_TYPE"
        case billNo = "BILL_NO"
        case billSrl = "BILL_SRL"
        case billDate = "BILL_DATE"
        case billTime = "BILL_TIME"
        case billAmt = "BILL_AMT"
        case taxAmt = "TAX_AMT"
        case dlvryAmt = "DLVRY_AMT"
        case mobileNo = "MOBILE_NO"
        case cstmrNm = "CSTMR_NM"
        case rgnNm = "RGN_NM"
        case cstmrBuildNo = "CSTMR_BUILD_NO"
        case cstmrFloorNo = "CSTMR_FLOOR_NO"
        case cstmrAprtmntNo = "CSTMR_APRTMNT_NO"
        case cstmrAddrss = "CSTMR_ADDRSS"
        case latitude = "LATITUDE"
        case longitude = "LONGITUDE"
        case dlvryStatusFlg = "DLVRY_STATUS_FLG"
    }
}

 
 

// MARK: - Result
struct ResultResponse: Codable {
    let errNo: Int?
    let errMsg: String?

    enum CodingKeys: String, CodingKey {
        case errNo = "ErrNo"
        case errMsg = "ErrMsg"
    }
}
