// ServiceCategoryData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let serviceCategoryData = try ServiceCategoryData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.serviceCategoryDataTask(with: url) { serviceCategoryData, response, error in
//     if let serviceCategoryData = serviceCategoryData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - ServiceCategoryData
public class ServiceCategoryData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [ServiceCatList]?
    public var areas: [Area]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
        case areas = "areas"
    }

    public init(success: Bool?, message: String?, data: [ServiceCatList]?, areas: [Area]?) {
        self.success = success
        self.message = message
        self.data = data
        self.areas = areas
    }
}

// MARK: ServiceCategoryData convenience initializers and mutators

public extension ServiceCategoryData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceCategoryData.self, from: data)
        self.init(success: me.success, message: me.message, data: me.data, areas: me.areas)
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
        data: [ServiceCatList]?? = nil,
        areas: [Area]?? = nil
    ) -> ServiceCategoryData {
        return ServiceCategoryData(
            success: success ?? self.success,
            message: message ?? self.message,
            data: data ?? self.data,
            areas: areas ?? self.areas
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// Area.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let area = try Area(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.areaTask(with: url) { area, response, error in
//     if let area = area {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Area
public class Area: Codable {
    public var serviceID: Int?
    public var area: String?

    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
        case area = "area"
    }

    public init(serviceID: Int?, area: String?) {
        self.serviceID = serviceID
        self.area = area
    }
}

// MARK: Area convenience initializers and mutators

public extension Area {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Area.self, from: data)
        self.init(serviceID: me.serviceID, area: me.area)
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
        serviceID: Int?? = nil,
        area: String?? = nil
    ) -> Area {
        return Area(
            serviceID: serviceID ?? self.serviceID,
            area: area ?? self.area
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// ServiceCatList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ServiceCatList = try ServiceCatList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.ServiceCatListTask(with: url) { ServiceCatList, response, error in
//     if let ServiceCatList = ServiceCatList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - ServiceCatList
public class ServiceCatList: Codable {
    public var serviceCategoryID: Int?
    public var name: String?
    public var nameAr: String?
    public var image: String?

    enum CodingKeys: String, CodingKey {
        case serviceCategoryID = "service_category_id"
        case name = "name"
        case nameAr = "name_ar"
        case image = "image"
    }

    public init(serviceCategoryID: Int?, name: String?, nameAr: String?, image: String?) {
        self.serviceCategoryID = serviceCategoryID
        self.name = name
        self.nameAr = nameAr
        self.image = image
    }
}

// MARK: ServiceCatList convenience initializers and mutators

public extension ServiceCatList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceCatList.self, from: data)
        self.init(serviceCategoryID: me.serviceCategoryID, name: me.name, nameAr: me.nameAr, image: me.image)
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
        serviceCategoryID: Int?? = nil,
        name: String?? = nil,
        nameAr: String?? = nil,
        image: String?? = nil
    ) -> ServiceCatList {
        return ServiceCatList(
            serviceCategoryID: serviceCategoryID ?? self.serviceCategoryID,
            name: name ?? self.name,
            nameAr: nameAr ?? self.nameAr,
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

    func serviceCategoryDataTask(with url: URL, completionHandler: @escaping (ServiceCategoryData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
