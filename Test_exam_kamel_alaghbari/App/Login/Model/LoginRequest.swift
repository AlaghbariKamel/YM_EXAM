//
//  LoginRequest.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

struct LoginRequest: Codable {
    let value: LoginValue

    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}

// MARK: - Value
struct LoginValue: Codable {
    let pLangNo, pDlvryNo, pPsswrd: String

    enum CodingKeys: String, CodingKey {
        case pLangNo = "P_LANG_NO"
        case pDlvryNo = "P_DLVRY_NO"
        case pPsswrd = "P_PSSWRD"
    }
}
