// BrandListData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let brandListData = try BrandListData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.brandListDataTask(with: url) { brandListData, response, error in
//     if let brandListData = brandListData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - BrandListData
public class BrandListData: Codable {
    public var success: Bool?
    public var message: String?
    public var brands: [Brand]?
    public var models: [MakingYear]?
    public var makingYears: [MakingYear]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case brands = "brands"
        case models = "models"
        case makingYears = "making_years"
    }

    public init(success: Bool?, message: String?, brands: [Brand]?, models: [MakingYear]?, makingYears: [MakingYear]?) {
        self.success = success
        self.message = message
        self.brands = brands
        self.models = models
        self.makingYears = makingYears
    }
}

// MARK: BrandListData convenience initializers and mutators

public extension BrandListData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(BrandListData.self, from: data)
        self.init(success: me.success, message: me.message, brands: me.brands, models: me.models, makingYears: me.makingYears)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        success: Bool?? = nil,
        message: String?? = nil,
        brands: [Brand]?? = nil,
        models: [MakingYear]?? = nil,
        makingYears: [MakingYear]?? = nil
    ) -> BrandListData {
        return BrandListData(
            success: success ?? self.success,
            message: message ?? self.message,
            brands: brands ?? self.brands,
            models: models ?? self.models,
            makingYears: makingYears ?? self.makingYears
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// Brand.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let brand = try Brand(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.brandTask(with: url) { brand, response, error in
//     if let brand = brand {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Brand
public class Brand: Codable {
    public var brandID: Int?
    public var name: String?
    public var image: String?

    enum CodingKeys: String, CodingKey {
        case brandID = "brand_id"
        case name = "name"
        case image = "image"
    }

    public init(brandID: Int?, name: String?, image: String?) {
        self.brandID = brandID
        self.name = name
        self.image = image
    }
}

// MARK: Brand convenience initializers and mutators

public extension Brand {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Brand.self, from: data)
        self.init(brandID: me.brandID, name: me.name, image: me.image)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        brandID: Int?? = nil,
        name: String?? = nil,
        image: String?? = nil
    ) -> Brand {
        return Brand(
            brandID: brandID ?? self.brandID,
            name: name ?? self.name,
            image: image ?? self.image
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MakingYear.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let makingYear = try MakingYear(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.makingYearTask(with: url) { makingYear, response, error in
//     if let makingYear = makingYear {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - MakingYear
public class MakingYear: Codable {
    public var id: Int?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: MakingYear convenience initializers and mutators

public extension MakingYear {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MakingYear.self, from: data)
        self.init(id: me.id, name: me.name)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        name: String?? = nil
    ) -> MakingYear {
        return MakingYear(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - URLSession response handlers

public extension URLSession
{
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func brandListDataTask(with url: URL, completionHandler: @escaping (BrandListData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
