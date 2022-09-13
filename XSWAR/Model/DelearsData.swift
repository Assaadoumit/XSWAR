// DelearsData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let delearsData = try DelearsData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.delearsDataTask(with: url) { delearsData, response, error in
//     if let delearsData = delearsData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - DelearsData
public class DelearsData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [DealerList]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    public init(success: Bool?, message: String?, data: [DealerList]?) {
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: DelearsData convenience initializers and mutators

public extension DelearsData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DelearsData.self, from: data)
        self.init(success: me.success, message: me.message, data: me.data)
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
        data: [DealerList]?? = nil
    ) -> DelearsData {
        return DelearsData(
            success: success ?? self.success,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// DealerList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let DealerList = try DealerList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.DealerListTask(with: url) { DealerList, response, error in
//     if let DealerList = DealerList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - DealerList
public class DealerList: Codable {
    public var partID: Int?
    public var dealerID: Int?
    public var name: String?
    public var image: String?
    public var price: Double?
    public var DealerListDescription: String?
    public var dealer: Dealer?

    enum CodingKeys: String, CodingKey {
        case partID = "part_id"
        case dealerID = "dealer_id"
        case name = "name"
        case image = "image"
        case price = "price"
        case DealerListDescription = "description"
        case dealer = "dealer"
    }

    public init(partID: Int?, dealerID: Int?, name: String?, image: String?, price: Double?, DealerListDescription: String?, dealer: Dealer?) {
        self.partID = partID
        self.dealerID = dealerID
        self.name = name
        self.image = image
        self.price = price
        self.DealerListDescription = DealerListDescription
        self.dealer = dealer
    }
}

// MARK: DealerList convenience initializers and mutators

public extension DealerList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DealerList.self, from: data)
        self.init(partID: me.partID, dealerID: me.dealerID, name: me.name, image: me.image, price: me.price, DealerListDescription: me.DealerListDescription, dealer: me.dealer)
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
        partID: Int?? = nil,
        dealerID: Int?? = nil,
        name: String?? = nil,
        image: String?? = nil,
        price: Double?? = nil,
        DealerListDescription: String?? = nil,
        dealer: Dealer?? = nil
    ) -> DealerList {
        return DealerList(
            partID: partID ?? self.partID,
            dealerID: dealerID ?? self.dealerID,
            name: name ?? self.name,
            image: image ?? self.image,
            price: price ?? self.price,
            DealerListDescription: DealerListDescription ?? self.DealerListDescription,
            dealer: dealer ?? self.dealer
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// Dealer.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dealer = try Dealer(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.dealerTask(with: url) { dealer, response, error in
//     if let dealer = dealer {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Dealer
public class Dealer: Codable {
    public var userID: Int?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name = "name"
    }

    public init(userID: Int?, name: String?) {
        self.userID = userID
        self.name = name
    }
}

// MARK: Dealer convenience initializers and mutators

public extension Dealer {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Dealer.self, from: data)
        self.init(userID: me.userID, name: me.name)
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
        userID: Int?? = nil,
        name: String?? = nil
    ) -> Dealer {
        return Dealer(
            userID: userID ?? self.userID,
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

public extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func delearsDataTask(with url: URL, completionHandler: @escaping (DelearsData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
