// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dealerLoginData = try? newJSONDecoder().decode(DealerLoginData.self, from: jsonData)

import Foundation

// MARK: - DealerLoginData
public class DealerLoginData: Codable {
    public var success: Bool?
    public var message: String?
    public var token: String?
    public var data: DLoginData?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case token
        case data
    }

    public init(success: Bool?, message: String?, token: String?, data: DLoginData?) {
        self.success = success
        self.message = message
        self.token = token
        self.data = data
    }
}

// MARK: - DLoginData
public class DLoginData: Codable {
    public var userid: Int?
    public var userUniqueid: String?
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
    public var dealerType: String?

    enum CodingKeys: String, CodingKey {
        case userid
        case userUniqueid
        case name
        case email
        case mobile
        case profilePic
        case role
        case deviceType
        case fcmToken
        case postalCode
        case deliveryAddress
        case mobileVerified
        case emailVerified
        case dealerType
    }

    public init(userid: Int?, userUniqueid: String?, name: String?, email: String?, mobile: String?, profilePic: String?, role: Int?, deviceType: Int?, fcmToken: String?, postalCode: String?, deliveryAddress: String?, mobileVerified: Int?, emailVerified: Int?, dealerType: String?) {
        self.userid = userid
        self.userUniqueid = userUniqueid
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
        self.dealerType = dealerType
    }
}
