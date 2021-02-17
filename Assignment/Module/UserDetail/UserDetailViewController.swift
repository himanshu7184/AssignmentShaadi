//
//  UserDetailViewController.swift
//  Assignment
//
//  Created by Himanshu Sonker on 06/02/21.
//

import UIKit

protocol UserDetailDelegte: class {
    func onUserFavourite(userId: Int, isFav: Bool)
}

class UserDetailViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var labelCatchPh: UILabel!
    @IBOutlet weak var labelBS: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelWebsite: UILabel!
    @IBOutlet weak var labelStreet: UILabel!
    @IBOutlet weak var labelSuite: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    
    weak var userDetailDelegate: UserDetailDelegte?
    var viewModel: UserDetailViewModel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserDetailViewModel(user: user)
        initView()
        initVM()
        updateData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            userDetailDelegate?.onUserFavourite(userId: user.id, isFav: viewModel.isFavourite)
            userDetailDelegate = nil
        }
    }
    
    
    
    func initView() {
        let isfav = user.isFav ?? false
        let imgName = isfav ? "red" : "gray"
        let img = UIImage(named: imgName)!.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: img,
                                          style: UIBarButtonItem.Style.plain,
                                              target: self,
                                              action: #selector(self.rightNavBarItemAction))
        navigationItem.rightBarButtonItem = rightButton

    }
    
    func initVM() {
        
        
        viewModel.markFavourite = { [weak self] () in
            DispatchQueue.main.async {
                let isfav = self?.viewModel.isFavourite ?? false
                
                let imgName = isfav ? "red" : "gray"
                
                let img = UIImage(named: imgName)!.withRenderingMode(.alwaysOriginal)
                let rightButton = UIBarButtonItem(image: img,
                                                  style: UIBarButtonItem.Style.plain,
                                                      target: self,
                                                      action: #selector(self!.rightNavBarItemAction))
                self!.navigationItem.rightBarButtonItem = rightButton
            }
        }
       

    }
    
    private func updateData() {
        if let user = user {
            labelName.text = user.name
            labelUserName.text = user.username
            
            labelCompanyName.text = user.company?.name
            labelCatchPh.text = user.company?.catchPhrase
            labelBS.text = user.company?.bs
            
            labelPhone.text = user.phone
            labelWebsite.text = user.website
            
            labelStreet.text = user.address?.street
            labelSuite.text = user.address?.suite
            labelCity.text = user.address?.city
        }
    }
    
    @objc func rightNavBarItemAction() {
        viewModel.markFavouriteOption()
    }
    
}
