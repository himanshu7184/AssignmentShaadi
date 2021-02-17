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
    
    func test_cell_view_model() {
        //Given Users
        let address = Address(street: "street", suite: "suite", city: "city", zipcode: "zipcode", geo: nil)
        let company = Company(name: "name", catchPhrase: "catchPhrase", bs: "bs")
        let user = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: "1234567890", website: "website", company: company, isFav: false)
        let userWithoutPhone = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: nil, website: "website", company: company, isFav: false)
        let userWithoutWebsite = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: "1234567890", website: nil, company: company, isFav: false)
        let userWithoutCompany = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: "1234567890", website: "website", company: nil, isFav: false)
        let userWithoutFav = User(id: 1, name: "Name", username: "username", email: "email", address: address, phone: "1234567890", website: "website", company: company, isFav: nil)
        
        let cellViewModel = sut.createCellViewModel(user: user)
        let cellViewModelWithoutPhone = sut.createCellViewModel(user: userWithoutPhone)
        let cellViewModelWithoutWebsite = sut.createCellViewModel(user: userWithoutWebsite)
        let cellViewModelWithoutCompany = sut.createCellViewModel(user: userWithoutCompany)
        let cellViewModelWithoutFav = sut.createCellViewModel(user: userWithoutFav)
        
        //Assert the correctness of display information
        XCTAssertEqual(user.name, cellViewModel.name)
        XCTAssertEqual(user.phone, cellViewModel.phone)
        XCTAssertEqual(user.website, cellViewModel.website)
        XCTAssertEqual(user.company?.name, cellViewModel.companyName)
        XCTAssertEqual(user.isFav, cellViewModel.isFav)
        
        XCTAssertEqual(cellViewModel.name, user.name)
        XCTAssertEqual(cellViewModel.phone, user.phone)
        XCTAssertEqual(cellViewModel.website, user.website)
        XCTAssertEqual(cellViewModel.companyName, user.company?.name)
        XCTAssertEqual(cellViewModel.isFav, user.isFav)
        
        XCTAssertEqual(cellViewModelWithoutPhone.phone, "")
        XCTAssertEqual(cellViewModelWithoutWebsite.website, "")
        XCTAssertEqual(cellViewModelWithoutCompany.companyName, "")
        //XCTAssertEqual(cellViewModelWithoutFav.isFav, false)
        XCTAssertFalse(cellViewModelWithoutFav.isFav)
    }
    
    func test_numberOfCellViewModels_isEqualTo_numberOfUser() {
        let users = StubGenerator().stubUsers()
        mockAPIService.completeUsers = users
        
        let expect = XCTestExpectation(description: "Reload triggered")
        
        sut.reloadTableViewClosure = { [weak sut] () in
            XCTAssertEqual(sut!.numberOfCells, users.count)
            expect.fulfill()
        }
        
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        wait(for: [expect], timeout: 1.0)
        //waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func test_viewModel_isLoading_statusChangedAfterFetch() {
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
            print("called")
        }
        
        //Fetching state
        sut.initFetch()
        
        XCTAssertTrue(loadingStatus)
        
        //When finished fetching
        mockAPIService.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_cellViewModel_at_indexPath() {
        mockAPIService.completeUsers = StubGenerator().stubUsers()
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let userCellViewModel = sut.getCellViewModel(at: indexPath)
        
        let testUser = mockAPIService.completeUsers[indexPath.row]
        
        //Assert
        XCTAssertEqual(userCellViewModel.name, testUser.name)
    }
    
    func test_getUser_at_indexPath() {
        mockAPIService.completeUsers = StubGenerator().stubUsers()
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        let vmUser = sut.getUser(at: indexPath)
        
        let testUser = mockAPIService.completeUsers[indexPath.row]
        
        //Assert
        XCTAssertEqual(vmUser.email, testUser.email)
    }
    
    func test_updateUser_favReversed() {
        mockAPIService.completeUsers = StubGenerator().stubUsers()
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let vmUser = sut.getUser(at: indexPath)
        
        let isFav = vmUser.isFav ?? false
        sut.updateUser(userId: vmUser.id, isfav: !isFav)
        
        let updatedVmUser = sut.getUser(at: indexPath)
        
        XCTAssertNotEqual(isFav, updatedVmUser.isFav)
    }
}

class MockApiService: APIServiceProtocol {
    
    var isFetchUserList = false
    
    var completeUsers: [User] = [User]()
    var completeClosure: ((Bool, [User], APIError?) -> ())!
    
    func fetchUserList(complete: @escaping (Bool, [User]?, APIError?) -> ()) {
        isFetchUserList = true
        completeClosure = complete
    }
    
    func fetchSuccess() {
        completeClosure( true, completeUsers, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completeUsers, error )
    }
    
}

class StubGenerator {
    func stubUsers() -> [User] {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "UnitTestData", ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let userObject = try! JSONDecoder().decode(Array<User>.self, from: data)
        return userObject
        
    }
}
