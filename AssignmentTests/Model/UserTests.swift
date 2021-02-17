//
//  UserTests.swift
//  AssignmentTests
//
//  Created by Himanshu Sonker on 17/02/21.
//

import XCTest
@testable import Assignment

class UserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func test_init_user () {
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: nil, phone: nil, website: nil, company: nil, isFav: nil)
        XCTAssertEqual(user.id, 1, "Should set id")
        XCTAssertEqual(user.name, "Name", "Should set name")
        XCTAssertEqual(user.username, "username", "Should set username")
        XCTAssertEqual(user.email, "email", "Should set email")
    }
    
    func test_init_user_whenGivenAddress () {
        let address = Address(street: "street", suite: "suite", city: "city", zipcode: "zipcode", geo: nil)
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: nil, website: nil, company: nil, isFav: nil)
        
        XCTAssertEqual(user.address?.street, address.street)
    }
    
    func test_init_user_whenGivenPhone () {
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: nil, phone: "1234567890", website: nil, company: nil, isFav: nil)
        
        XCTAssertEqual(user.phone, "1234567890")
    }
    
    func test_init_user_whenGivenWebsite () {
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: nil, phone: nil, website: "website", company: nil, isFav: nil)
        
        XCTAssertEqual(user.website, "website")
    }
    
    func test_init_user_whenGivenCompany () {
        let company = Company(name: "name", catchPhrase: "catchPhrase", bs: "bs")
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: nil, phone: nil, website: nil, company: company, isFav: nil)
        
        XCTAssertEqual(user.company?.name, company.name)
    }
    
    func test_init_user_whenGivenFav () {
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: nil, phone: nil, website: nil, company: nil, isFav: true)
        
        XCTAssertTrue(user.isFav!)
    }
    
    //Address
    func test_init_address_setsGeo() {
        let geo = Geo(lat: "1", lng: "2")
        let address = Address(street: "", suite: "", city: "", zipcode: "", geo: geo)
        
        XCTAssertEqual(address.geo?.lat, geo.lat)
        XCTAssertEqual(address.geo?.lng, geo.lng)
    }
    
    func test_init_address_setsStreet() {
        let address = Address(street: "street", suite: "suite", city: "city", zipcode: "zipcode", geo: nil)
        
        XCTAssertEqual(address.street, "street")
        XCTAssertEqual(address.suite, "suite")
        XCTAssertEqual(address.city, "city")
        XCTAssertEqual(address.zipcode, "zipcode")
    }
    
    //Company
    func test_init_company() {
        let company = Company(name: "name", catchPhrase: "catchPhrase", bs: "bs")
        
        XCTAssertEqual(company.name, "name")
        XCTAssertEqual(company.catchPhrase, "catchPhrase")
        XCTAssertEqual(company.bs, "bs")
    }

}
