//
//  LoginResponse.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//



// MARK: - Welcome
struct LoginResponse: Codable {
    let data: LoginData
    let result: ResultResponse

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case result = "Result"
    }
}

// MARK: - DataClass
struct LoginData: Codable {
    let deliveryName: String

    enum CodingKeys: String, CodingKey {
        case deliveryName = "DeliveryName"
    }
}
