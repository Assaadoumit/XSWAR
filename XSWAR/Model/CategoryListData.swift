// CategoryListData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categoryListData = try CategoryListData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.categoryListDataTask(with: url) { categoryListData, response, error in
//     if let categoryListData = categoryListData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - CategoryListData
public class CategoryListData: Codable {
    public var success: Bool?
    public var message: String?
    public var data: [CategoryList]?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    public init(success: Bool?, message: String?, data: [CategoryList]?) {
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: CategoryListData convenience initializers and mutators

public extension CategoryListData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CategoryListData.self, from: data)
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
        data: [CategoryList]?? = nil
    ) -> CategoryListData {
        return CategoryListData(
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

// CategoryList.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let CategoryList = try CategoryList(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.CategoryListTask(with: url) { CategoryList, response, error in
//     if let CategoryList = CategoryList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - CategoryList
public class CategoryList: Codable {
    public var categoryID: Int?
    public var name: String?
    public var nameAr: String?
    public var image: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case name = "name"
        case nameAr = "name_ar"
        case image = "image"
    }

    public init(categoryID: Int?, name: String?, nameAr: String?, image: String?) {
        self.categoryID = categoryID
        self.name = name
        self.nameAr = nameAr
        self.image = image
    }
}

// MARK: CategoryList convenience initializers and mutators

public extension CategoryList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CategoryList.self, from: data)
        self.init(categoryID: me.categoryID, name: me.name, nameAr: me.nameAr, image: me.image)
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
        categoryID: Int?? = nil,
        name: String?? = nil,
        nameAr: String?? = nil,
        image: String?? = nil
    ) -> CategoryList {
        return CategoryList(
            categoryID: categoryID ?? self.categoryID,
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

    func categoryListDataTask(with url: URL, completionHandler: @escaping (CategoryListData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
