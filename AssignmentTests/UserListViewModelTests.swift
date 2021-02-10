//
//  UserListViewModelTests.swift
//  AssignmentTests
//
//  Created by Himanshu Sonker on 10/02/21.
//

import XCTest
@testable import Assignment

class UserListViewModelTests: XCTestCase {
    
    var sut: UserListViewModel!
    var mockAPIService: MockApiService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockAPIService = MockApiService()
        sut = UserListViewModel(apiService: mockAPIService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetch_user() {
        // Given
        mockAPIService.completeUsers = [User]()

        // When
        sut.initFetch()
    
        // Assert
        XCTAssert(mockAPIService!.isFetchUserList)
    }
    
    func test_fetch_user_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.dataNotFound
        
        // When
        sut.initFetch()
        
        mockAPIService.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockApiService: APIServiceProtocol {
    func fetchUserList(complete: @escaping (Bool, [User]?, APIError?) -> ()) {
        isFetchUserList = true
        completeClosure = complete
    }
    
    
    var isFetchUserList = false
    
    var completeUsers: [User] = [User]()
    var completeClosure: ((Bool, [User], APIError?) -> ())!
    
    
    func fetchSuccess() {
        completeClosure( true, completeUsers, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completeUsers, error )
    }
    
}
