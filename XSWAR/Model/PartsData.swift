// PartsData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let partsData = try PartsData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.partsDataTask(with: url) { partsData, response, error in
//     if let partsData = partsData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - PartsData
public class PartsData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [PartsList]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    public init(success: Bool?, message: String?, data: [PartsList]?) {
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: PartsData convenience initializers and mutators

public extension PartsData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PartsData.self, from: data)
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
        data: [PartsList]?? = nil
    ) -> PartsData {
        return PartsData(
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

// PartsList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let PartsList = try PartsList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.PartsListTask(with: url) { PartsList, response, error in
//     if let PartsList = PartsList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - PartsList
public class PartsList: Codable {
    public var partID: Int?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case partID = "part_id"
        case name = "name"
    }

    public init(partID: Int?, name: String?) {
        self.partID = partID
        self.name = name
    }
}

// MARK: PartsList convenience initializers and mutators

public extension PartsList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PartsList.self, from: data)
        self.init(partID: me.partID, name: me.name)
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
        name: String?? = nil
    ) -> PartsList {
        return PartsList(
            partID: partID ?? self.partID,
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

    func partsDataTask(with url: URL, completionHandler: @escaping (PartsData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
