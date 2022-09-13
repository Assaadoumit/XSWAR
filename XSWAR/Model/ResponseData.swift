// ResponseData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responseData = try ResponseData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.responseDataTask(with: url) { responseData, response, error in
//     if let responseData = responseData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - ResponseData
public class ResponseData: Codable {
    public var success: Bool?
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
    }

    public init(success: Bool?, message: String?) {
        self.success = success
        self.message = message
    }
}

// MARK: ResponseData convenience initializers and mutators

public extension ResponseData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ResponseData.self, from: data)
        self.init(success: me.success, message: me.message)
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
        message: String?? = nil
    ) -> ResponseData {
        return ResponseData(
            success: success ?? self.success,
            message: message ?? self.message
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

    func responseDataTask(with url: URL, completionHandler: @escaping (ResponseData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
