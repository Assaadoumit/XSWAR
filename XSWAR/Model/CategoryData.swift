//
//  CategoryData.swift
//  XSWAR
//
//  Created by Jigar Kanani on 01/12/21.
//

//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let success: Bool
    let message: String
    let grades: [Grade]
    let sizes: [String]
}

// MARK: - Grade
struct Grade: Codable {
    let oilCategoryID: Int
    let grade: String

    enum CodingKeys: String, CodingKey {
        case oilCategoryID = "oil_category_id"
        case grade
    }
}
