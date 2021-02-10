//
//  ViewController.swift
//  Assignment
//
//  Created by Himanshu Sonker on 03/02/21.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    
    
    func initView() {
        self.navigationItem.title = "Users"
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableView.automaticDimension
        tabelView.tableFooterView = UIView()
        tabelView.separatorStyle = .none
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
       
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tabelView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tabelView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tabelView.reloadData()
            }
        }
        
        viewModel.initFetch()

    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCellIdentifire", for: indexPath) as? UserTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.userListCellViewModel = cellVM
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController
        vc?.user = viewModel.getUser(at: indexPath)
        vc?.userDetailDelegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

extension UserListViewController: UserDetailDelegte {
    func onUserFavourite(userId: Int, isFav: Bool) {
        viewModel.updateUser(userId: userId, isfav: isFav)
    }
    
    
}



class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelCompName: UILabel!
    @IBOutlet weak var labelWebsite: UILabel!
    @IBOutlet weak var imageFavUser: UIImageView!
    
    var userListCellViewModel : UserListCellViewModel? {
        didSet {
            labelName.text = userListCellViewModel?.name
            labelPhone.text = userListCellViewModel?.phone
            labelCompName.text = userListCellViewModel?.companyName
            labelWebsite.text = userListCellViewModel?.website
            let isFav = userListCellViewModel?.isFav ?? false
            let imgName = isFav ? "red" : "grey"
            imageFavUser.image = UIImage(named: imgName)
            
        }
    }
    
}



