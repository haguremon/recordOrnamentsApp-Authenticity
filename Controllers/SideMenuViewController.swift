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
    case signOut = "最初の画面に戻る"
    case contact = "問い合わせ"
}


class SideMenuViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    var user: User? {

        didSet {
            guard let user = user else {
                return
            }
            
            configure(user: user)
            activityIndicatorView.hidesWhenStopped = true

        }


    }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    let sideMenuItems: [SideMenuItem] = SideMenuItem.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.offBlackOrWhite.cgColor
        activityIndicatorView.hidesWhenStopped = false
        activityIndicatorView.style = .large

    }
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicatorView.startAnimating()
        fetchUser()
    }
    private func fetchUser() {
        //コールバックを使ってProfileControllerのプロパティに代入する
        UserService.fetchUser { user in
            self.user = user
        }
        activityIndicatorView.stopAnimating()
    }

    private func configure(user: User) {

        imageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        usernameLabel.text = user.name

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
        print(selectItem)
        //ここでの通知をViewControllernに伝えてその内容をViewControllerでやる
        delegate?.didSelectMeunItem(name: selectItem)
        
        print("tap")
    }

}
