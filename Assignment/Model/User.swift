//
//  User.swift
//  Assignment
//
//  Created by Himanshu Sonker on 05/02/21.
//

import Foundation

struct Users: Codable {
    let users: [User]
}

struct User: Codable {
    let id: Int
    let name, username, email: String
    let address: Address?
    let phone, website: String?
    let company: Company?
    var isFav: Bool?
}

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo?
}

struct Geo: Codable {
    let lat, lng: String
}

struct Company: Codable {
    let name, catchPhrase, bs: String
}
