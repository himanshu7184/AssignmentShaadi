//
//  UserListViewModel.swift
//  Assignment
//
//  Created by Himanshu Sonker on 05/02/21.
//

import Foundation

class UserListViewModel {
    
    let apiService: APIServiceProtocol
    private var users: [User] = [User]()

    private var cellViewModels: [UserListCellViewModel] = [UserListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }


    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchUserList { [weak self] (success, users, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedUsers(users: users ?? [])
            }
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> UserListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getUser( at indexPath: IndexPath ) -> User {
        return users[indexPath.row]
    }
    
    func updateUser(userId: Int, isfav: Bool) {
        let index = users.firstIndex{$0.id == userId}
        
        if let userIndex = index {
            var tempUser = users[userIndex]
            tempUser.isFav = isfav
            users[userIndex] = tempUser
            processFetchedUsers(users: users)
        }
        
    }
    
    
    func createCellViewModel( user: User ) -> UserListCellViewModel {
        
        let name = user.name
        let phone = user.phone ?? ""
        let website = user.website ?? ""
        let companyName = user.company?.name ?? ""
        let isFav = user.isFav ?? false
        
        
        return UserListCellViewModel(name: name, phone: phone, website: website, companyName: companyName, isFav: isFav)
        
    }
    
    private func processFetchedUsers( users: [User] ) {
        self.users = users
        var vms = [UserListCellViewModel]()
        for user in users {
            vms.append( createCellViewModel(user: user) )
        }
        self.cellViewModels = vms
    }
}


struct UserListCellViewModel {
    let name: String
    let phone: String?
    let website: String?
    let companyName: String?
    let isFav:Bool?
}
