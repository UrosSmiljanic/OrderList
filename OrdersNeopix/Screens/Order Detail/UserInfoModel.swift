//
//  UserInfo.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 24/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let data: [DatumUser]
    let meta: MetaUser
}

struct DatumUser: Codable {
    let id: Int
    let name: String
    let logo: String
    let phone, email, caption: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let postCode: Int
    let city: String
}

struct MetaUser: Codable {
    let hasMore: Bool
}

// MARK: Convenience initializers and mutators

extension UserInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: [DatumUser]? = nil,
        meta: MetaUser? = nil
        ) -> UserInfo {
        return UserInfo(
            data: data ?? self.data,
            meta: meta ?? self.meta
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension DatumUser {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DatumUser.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        name: String? = nil,
        logo: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        caption: String? = nil,
        address: Address? = nil
        ) -> DatumUser {
        return DatumUser(
            id: id ?? self.id,
            name: name ?? self.name,
            logo: logo ?? self.logo,
            phone: phone ?? self.phone,
            email: email ?? self.email,
            caption: caption ?? self.caption,
            address: address ?? self.address
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Address {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Address.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        street: String? = nil,
        postCode: Int? = nil,
        city: String? = nil
        ) -> Address {
        return Address(
            street: street ?? self.street,
            postCode: postCode ?? self.postCode,
            city: city ?? self.city
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension MetaUser {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MetaUser.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        hasMore: Bool? = nil
        ) -> MetaUser {
        return MetaUser(
            hasMore: hasMore ?? self.hasMore
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
