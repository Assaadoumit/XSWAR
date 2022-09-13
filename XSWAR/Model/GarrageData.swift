// GarrageData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let garrageData = try GarrageData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.garrageDataTask(with: url) { garrageData, response, error in
//     if let garrageData = garrageData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - GarrageData
public class GarrageData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [GarrageList]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    public init(success: Bool?, message: String?, data: [GarrageList]?) {
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: GarrageData convenience initializers and mutators

public extension GarrageData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(GarrageData.self, from: data)
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
        data: [GarrageList]?? = nil
    ) -> GarrageData {
        return GarrageData(
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

// GarrageList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let GarrageList = try GarrageList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.GarrageListTask(with: url) { GarrageList, response, error in
//     if let GarrageList = GarrageList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - GarrageList
public class GarrageList: Codable {
    public var serviceID: Int?
    public var serviceCategoryID: Int?
    public var name: String?
    public var nameAr: String?
    public var image: String?
    public var phoneNumber: String?
    public var services: String?
    public var location: String?
    public var area: String?
    public var latitude: String?
    public var longitude: String?

    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
        case serviceCategoryID = "service_category_id"
        case name = "name"
        case nameAr = "name_ar"
        case image = "image"
        case phoneNumber = "phone_number"
        case services = "services"
        case location = "location"
        case area = "area"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    public init(serviceID: Int?, serviceCategoryID: Int?, name: String?, nameAr: String?, image: String?, phoneNumber: String?, services: String?, location: String?, area: String?, latitude: String?, longitude: String?) {
        self.serviceID = serviceID
        self.serviceCategoryID = serviceCategoryID
        self.name = name
        self.nameAr = nameAr
        self.image = image
        self.phoneNumber = phoneNumber
        self.services = services
        self.location = location
        self.area = area
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: GarrageList convenience initializers and mutators

public extension GarrageList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(GarrageList.self, from: data)
        self.init(serviceID: me.serviceID, serviceCategoryID: me.serviceCategoryID, name: me.name, nameAr: me.nameAr, image: me.image, phoneNumber: me.phoneNumber, services: me.services, location: me.location, area: me.area, latitude: me.latitude, longitude: me.longitude)
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
        serviceCategoryID: Int?? = nil,
        name: String?? = nil,
        nameAr: String?? = nil,
        image: String?? = nil,
        phoneNumber: String?? = nil,
        services: String?? = nil,
        location: String?? = nil,
        area: String?? = nil,
        latitude: String?? = nil,
        longitude: String?? = nil
    ) -> GarrageList {
        return GarrageList(
            serviceID: serviceID ?? self.serviceID,
            serviceCategoryID: serviceCategoryID ?? self.serviceCategoryID,
            name: name ?? self.name,
            nameAr: nameAr ?? self.nameAr,
            image: image ?? self.image,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            services: services ?? self.services,
            location: location ?? self.location,
            area: area ?? self.area,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude
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

    func garrageDataTask(with url: URL, completionHandler: @escaping (GarrageData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

