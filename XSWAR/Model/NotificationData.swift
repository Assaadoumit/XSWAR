// NotificationData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notificationData = try NotificationData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.notificationDataTask(with: url) { notificationData, response, error in
//     if let notificationData = notificationData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - NotificationData
public class NotificationData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [NotificationList]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    public init(success: Bool?, message: String?, data: [NotificationList]?) {
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: NotificationData convenience initializers and mutators

public extension NotificationData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(NotificationData.self, from: data)
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
        data: [NotificationList]?? = nil
    ) -> NotificationData {
        return NotificationData(
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

// NotificationList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let NotificationList = try NotificationList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.NotificationListTask(with: url) { NotificationList, response, error in
//     if let NotificationList = NotificationList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - NotificationList
public class NotificationList: Codable {
    public var requestID: Int?
    public var dealerID: Int?
    public var userID: Int?
    public var partID: Int?
    public var brandID: Int?
    public var partMakingYear: String?
    public var model: String?
    public var descriptionByUser: String?
    public var attachedFileByUser: String?
    public var deliveryAddress: String?
    public var descriptionByDealer: String?
    public var price: Int?
    public var attachedFileByDealer: String?
    public var guarantee: String?
    public var dealerStatus: String?
    public var userStatus: String?
    public var partType: String?
    public var partName: String?
    public var isRead: Int?
    public var requestText: String?
    public var dealer: Dealer?
    public var brand: Brand?
    public var part: Part?

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case dealerID = "dealer_id"
        case userID = "user_id"
        case partID = "part_id"
        case brandID = "brand_id"
        case partMakingYear = "part_making_year"
        case model = "model"
        case descriptionByUser = "description_by_user"
        case attachedFileByUser = "attached_file_by_user"
        case deliveryAddress = "delivery_address"
        case descriptionByDealer = "description_by_dealer"
        case price = "price"
        case attachedFileByDealer = "attached_file_by_dealer"
        case guarantee = "guarantee"
        case dealerStatus = "dealer_status"
        case userStatus = "user_status"
        case partType = "part_type"
        case partName = "part_name"
        case isRead = "is_read"
        case requestText = "request_text"
        case dealer = "dealer"
        case brand = "brand"
        case part = "part"
    }

    public init(requestID: Int?, dealerID: Int?, userID: Int?, partID: Int?, brandID: Int?, partMakingYear: String?, model: String?, descriptionByUser: String?, attachedFileByUser: String?, deliveryAddress: String?, descriptionByDealer: String?, price: Int?, attachedFileByDealer: String?, guarantee: String?, dealerStatus: String?, userStatus: String?, partType: String?, partName: String?, isRead: Int?, requestText: String?, dealer: Dealer?, brand: Brand?, part: Part?) {
        self.requestID = requestID
        self.dealerID = dealerID
        self.userID = userID
        self.partID = partID
        self.brandID = brandID
        self.partMakingYear = partMakingYear
        self.model = model
        self.descriptionByUser = descriptionByUser
        self.attachedFileByUser = attachedFileByUser
        self.deliveryAddress = deliveryAddress
        self.descriptionByDealer = descriptionByDealer
        self.price = price
        self.attachedFileByDealer = attachedFileByDealer
        self.guarantee = guarantee
        self.dealerStatus = dealerStatus
        self.userStatus = userStatus
        self.partType = partType
        self.partName = partName
        self.isRead = isRead
        self.requestText = requestText
        self.dealer = dealer
        self.brand = brand
        self.part = part
    }
}

// MARK: NotificationList convenience initializers and mutators

public extension NotificationList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(NotificationList.self, from: data)
        self.init(requestID: me.requestID, dealerID: me.dealerID, userID: me.userID, partID: me.partID, brandID: me.brandID, partMakingYear: me.partMakingYear, model: me.model, descriptionByUser: me.descriptionByUser, attachedFileByUser: me.attachedFileByUser, deliveryAddress: me.deliveryAddress, descriptionByDealer: me.descriptionByDealer, price: me.price, attachedFileByDealer: me.attachedFileByDealer, guarantee: me.guarantee, dealerStatus: me.dealerStatus, userStatus: me.userStatus, partType: me.partType, partName: me.partName, isRead: me.isRead, requestText: me.requestText, dealer: me.dealer, brand: me.brand, part: me.part)
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
        requestID: Int?? = nil,
        dealerID: Int?? = nil,
        userID: Int?? = nil,
        partID: Int?? = nil,
        brandID: Int?? = nil,
        partMakingYear: String?? = nil,
        model: String?? = nil,
        descriptionByUser: String?? = nil,
        attachedFileByUser: String?? = nil,
        deliveryAddress: String?? = nil,
        descriptionByDealer: String?? = nil,
        price: Int?? = nil,
        attachedFileByDealer: String?? = nil,
        guarantee: String?? = nil,
        dealerStatus: String?? = nil,
        userStatus: String?? = nil,
        partType: String?? = nil,
        partName: String?? = nil,
        isRead: Int?? = nil,
        requestText: String?? = nil,
        dealer: Dealer?? = nil,
        brand: Brand?? = nil,
        part: Part?? = nil
    ) -> NotificationList {
        return NotificationList(
            requestID: requestID ?? self.requestID,
            dealerID: dealerID ?? self.dealerID,
            userID: userID ?? self.userID,
            partID: partID ?? self.partID,
            brandID: brandID ?? self.brandID,
            partMakingYear: partMakingYear ?? self.partMakingYear,
            model: model ?? self.model,
            descriptionByUser: descriptionByUser ?? self.descriptionByUser,
            attachedFileByUser: attachedFileByUser ?? self.attachedFileByUser,
            deliveryAddress: deliveryAddress ?? self.deliveryAddress,
            descriptionByDealer: descriptionByDealer ?? self.descriptionByDealer,
            price: price ?? self.price,
            attachedFileByDealer: attachedFileByDealer ?? self.attachedFileByDealer,
            guarantee: guarantee ?? self.guarantee,
            dealerStatus: dealerStatus ?? self.dealerStatus,
            userStatus: userStatus ?? self.userStatus,
            partType: partType ?? self.partType,
            partName: partName ?? self.partName,
            isRead: isRead ?? self.isRead,
            requestText: requestText ?? self.requestText,
            dealer: dealer ?? self.dealer,
            brand: brand ?? self.brand,
            part: part ?? self.part
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// Part.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let part = try Part(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.partTask(with: url) { part, response, error in
//     if let part = part {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Part
public class Part: Codable {
    public var partID: Int?
    public var name: String?
    public var partDescription: String?
    public var price: Int?
    public var image: String?

    enum CodingKeys: String, CodingKey {
        case partID = "part_id"
        case name = "name"
        case partDescription = "description"
        case price = "price"
        case image = "image"
    }

    public init(partID: Int?, name: String?, partDescription: String?, price: Int?, image: String?) {
        self.partID = partID
        self.name = name
        self.partDescription = partDescription
        self.price = price
        self.image = image
    }
}

// MARK: Part convenience initializers and mutators

public extension Part {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Part.self, from: data)
        self.init(partID: me.partID, name: me.name, partDescription: me.partDescription, price: me.price, image: me.image)
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
        name: String?? = nil,
        partDescription: String?? = nil,
        price: Int?? = nil,
        image: String?? = nil
    ) -> Part {
        return Part(
            partID: partID ?? self.partID,
            name: name ?? self.name,
            partDescription: partDescription ?? self.partDescription,
            price: price ?? self.price,
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

    func notificationDataTask(with url: URL, completionHandler: @escaping (NotificationData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


