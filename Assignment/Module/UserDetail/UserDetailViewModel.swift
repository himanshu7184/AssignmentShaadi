//
//  UserDetailViewModel.swift
//  Assignment
//
//  Created by Himanshu Sonker on 07/02/21.
//

import Foundation

class UserDetailViewModel {
    
    let user: User
    var markFavourite: (()->())?
    
    var isFavourite: Bool = false {
        didSet {
            self.markFavourite?()
        }
    }
    
    init(user: User) {
        self.user = user
        isFavourite = self.user.isFav ?? false
    }
    
    func markFavouriteOption () {
        isFavourite = !isFavourite
    }
}
