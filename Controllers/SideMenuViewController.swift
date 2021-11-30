//
//  SideMenuViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/24.
//

import UIKit
import SDWebImage

protocol SideMenuViewControllerDelegate: AnyObject {
    func didSelectMeunItem(name: SideMenuItem)
}

enum SideMenuItem: String,CaseIterable{
    case useGuide = "使い方ガイド"
    case account = "アカウント設定"
    case signOut = "ログアウト"
    case contact = "問い合わせ"
}

final class SideMenuViewController: UIViewController {
    
    // MARK: - プロパティ類
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    private var updateImageView: UIImageView?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configure(user: user)
        }
    }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    private let sideMenuItems: [SideMenuItem] = SideMenuItem.allCases
    
    //MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        fetchUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activeIndicatorView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.inactiveIndicatorView()
        }
    }
    
    
    //MARK: - API
    func fetchUser() {
        UserService.fetchUser { result in
            
            switch result {
            case .success(let user):
                self.user = user
            case  .failure(_):
                self.showMessage(withTitle: "エラーが発生しました", message: "再ログインしてください", handler: nil)
            }
        }
        
    }
    
    //MARK: - メソッド類
    private func activeIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.tintColor = .black
    }
    
    
    private func inactiveIndicatorView() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = false
    }
    
    
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = false
    }
    
    
    private func configure(user: User) {
        imageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        usernameLabel.text = user.name
    }
    
    //MARK: - UI等
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        updateImageView = imageView
        navigationController?.navigationBar.isHidden = true
        imageView.layer.cornerRadius = view.bounds.width / 8.25
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        imageView.contentMode = .scaleToFill
        
        usernameLabel.font = UIFont.boldSystemFont(ofSize: imageView.bounds.height / 7)
        usernameLabel.tintColor = .white
    }
    
    
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenuItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: cell.bounds.height / 3.5)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.textLabel?.text = sideMenuItems[indexPath.row].rawValue
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        imageView.bounds.height / 1.5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectItem = sideMenuItems[indexPath.row]
        
        delegate?.didSelectMeunItem(name: selectItem)
    }
    
    
}


//MARK: - AccountViewControllerDelegate
extension SideMenuViewController: AccountViewControllerDelegate {
    
    
    func didSelectMeunItem(_ viewController: AccountViewController, name: AccountMenu) {
        viewController.delegate = self
    }
    
    
    func controllerDidFinishUpDateUser() {
        self.fetchUser()
    }
    
    
}
