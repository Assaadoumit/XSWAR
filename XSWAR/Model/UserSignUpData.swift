// UserSignUpData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userSignUpData = try UserSignUpData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.userSignUpDataTask(with: url) { userSignUpData, response, error in
//     if let userSignUpData = userSignUpData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - UserSignUpData
public class UserSignUpData: Codable {
    public var success: Bool?
    public var message: String?
    public var token: String?
    public var data: UserData?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case token = "token"
        case data = "data"
    }

    public init(success: Bool?, message: String?, token: String?, data: UserData?) {
        self.success = success
        self.message = message
        self.token = token
        self.data = data
    }
}

// MARK: UserSignUpData convenience initializers and mutators

public extension UserSignUpData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserSignUpData.self, from: data)
        self.init(success: me.success, message: me.message, token: me.token, data: me.data)
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
        token: String?? = nil,
        data: UserData?? = nil
    ) -> UserSignUpData {
        return UserSignUpData(
            success: success ?? self.success,
            message: message ?? self.message,
            token: token ?? self.token,
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

// UserData.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let UserData = try UserData(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.UserDataTask(with: url) { UserData, response, error in
//     if let UserData = UserData {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - UserData
public class UserData: Codable {
    public var userID: Int?
    public var userUniqueID: String?
    public var name: String?
    public var email: String?
    public var mobile: String?
    public var profilePic: String?
    public var role: Int?
    public var deviceType: Int?
    public var fcmToken: String?
    public var postalCode: String?
    public var deliveryAddress: String?
    public var mobileVerified: Int?
    public var emailVerified: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userUniqueID = "user_unique_id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case profilePic = "profile_pic"
        case role = "role"
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case postalCode = "postal_code"
        case deliveryAddress = "delivery_address"
        case mobileVerified = "mobile_verified"
        case emailVerified = "email_verified"
    }

    public init(userID: Int?, userUniqueID: String?, name: String?, email: String?, mobile: String?, profilePic: String?, role: Int?, deviceType: Int?, fcmToken: String?, postalCode: String?, deliveryAddress: String?, mobileVerified: Int?, emailVerified: Int?) {
        self.userID = userID
        self.userUniqueID = userUniqueID
        self.name = name
        self.email = email
        self.mobile = mobile
        self.profilePic = profilePic
        self.role = role
        self.deviceType = deviceType
        self.fcmToken = fcmToken
        self.postalCode = postalCode
        self.deliveryAddress = deliveryAddress
        self.mobileVerified = mobileVerified
        self.emailVerified = emailVerified
    }
}

// MARK: UserData convenience initializers and mutators

public extension UserData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserData.self, from: data)
        self.init(userID: me.userID, userUniqueID: me.userUniqueID, name: me.name, email: me.email, mobile: me.mobile, profilePic: me.profilePic, role: me.role, deviceType: me.deviceType, fcmToken: me.fcmToken, postalCode: me.postalCode, deliveryAddress: me.deliveryAddress, mobileVerified: me.mobileVerified, emailVerified: me.emailVerified)
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
        userUniqueID: String?? = nil,
        name: String?? = nil,
        email: String?? = nil,
        mobile: String?? = nil,
        profilePic: String?? = nil,
        role: Int?? = nil,
        deviceType: Int?? = nil,
        fcmToken: String?? = nil,
        postalCode: String?? = nil,
        deliveryAddress: String?? = nil,
        mobileVerified: Int?? = nil,
        emailVerified: Int?? = nil
    ) -> UserData {
        return UserData(
            userID: userID ?? self.userID,
            userUniqueID: userUniqueID ?? self.userUniqueID,
            name: name ?? self.name,
            email: email ?? self.email,
            mobile: mobile ?? self.mobile,
            profilePic: profilePic ?? self.profilePic,
            role: role ?? self.role,
            deviceType: deviceType ?? self.deviceType,
            fcmToken: fcmToken ?? self.fcmToken,
            postalCode: postalCode ?? self.postalCode,
            deliveryAddress: deliveryAddress ?? self.deliveryAddress,
            mobileVerified: mobileVerified ?? self.mobileVerified,
            emailVerified: emailVerified ?? self.emailVerified
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

    func userSignUpDataTask(with url: URL, completionHandler: @escaping (UserSignUpData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

