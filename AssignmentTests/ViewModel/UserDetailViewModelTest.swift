//
//  UserDetailViewModelTest.swift
//  AssignmentTests
//
//  Created by Himanshu Sonker on 16/02/21.
//

import XCTest
@testable import Assignment

class UserDetailViewModelTest: XCTestCase {

    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_ViewModel_isFavourite_statusChangedAfterClick() {
        let address = Address(street: "street", suite: "suite", city: "city", zipcode: "zipcode", geo: nil)
        let company = Company(name: "name", catchPhrase: "catchPhrase", bs: "bs")
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: "1234567890", website: "website", company: company, isFav: false)
        let sut = UserDetailViewModel(user: user)
        
        let favouriteStatus = sut.user.isFav
        let expect = XCTestExpectation(description: "Favourite status updated")
        
        sut.markFavourite = { () in
            XCTAssertNotEqual(favouriteStatus, sut.isFavourite)
            expect.fulfill()
        }
        
        //change state
        sut.markFavouriteOption()
        
        wait(for: [expect], timeout: 1.0)
        
    }


}
