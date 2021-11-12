//
//  SideMenuViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/24.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol SideMenuViewControllerDelegate: AnyObject {
    func didSelectMeunItem(name: SideMenuItem)
}


enum SideMenuItem: String,CaseIterable{
    case useGuide = "使い方ガイド"
    case account = "アカウント"
    case signOut = "ログイン画面に戻る"
    case contact = "問い合わせ"
}


class SideMenuViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var updateImageView: UIImageView?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    var user: User? {

        didSet {
            guard let user = user else {
                return
            }
            configure(user: user)
           
        }


    }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    let sideMenuItems: [SideMenuItem] = SideMenuItem.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImageView = imageView
        
        configureTableView()
        imageView.layer.cornerRadius = 45
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        imageView.contentMode = .scaleToFill
        tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        usernameLabel.tintColor = .white
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeIndicatorView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.inactiveIndicatorView()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUser()
    }
    
    private func activeIndicatorView(){
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = false
        activityIndicatorView.style = .large
        activityIndicatorView.tintColor = .white
    }
    private func inactiveIndicatorView(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
 
    }
    
    
     private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = false
    }
    private func fetchUser() {
        //コールバックを使ってProfileControllerのプロパティに代入する
        UserService.fetchUser { user in
            self.user = user
        }
        DispatchQueue.main.async {
           
        }
       
        
    }

    private func configure(user: User) {

        imageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        usernameLabel.text = user.name

    }

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        cell.textLabel?.text = sideMenuItems[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //デリゲートを使ってやり取りする
        tableView.deselectRow(at: indexPath, animated: true)
        let selectItem = sideMenuItems[indexPath.row]
        //ここでの通知をViewControllernに伝えてその内容をViewControllerでやる
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
