//
//  AccountViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//


import UIKit


enum AccountMenu: String,CaseIterable{
    case name = "名前"
    case mailaddress = "メールアドレス変更"
    case password = "パスワードをリセット"
    case deleteAccount = "アカウント削除"
}

class AccountViewController: UIViewController {
    
     var user: User? {
         didSet{
             guard let user = user else { return }
             configure(user: user)
         }
     }
    
    let accountMenus: [AccountMenu] = AccountMenu.allCases
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var profileImageButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    private var profileImage: UIImage?
    
    private var profileImageImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
           
    }
    
    // MARK: - Helpers
    private func configureTableView() {
       tableView.dataSource = self
       tableView.delegate = self
       tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
       tableView.isScrollEnabled = false
       tableView.scrollsToTop = false
       tableView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
   }
    private func configureUI() {
        navigationItem.title = "アカウント"
        
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        //navigationController?.navigationBar.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(didTapdismiss))
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        profileImageButton.layer.cornerRadius = 45
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = 45
        profileImageButton.layer.borderWidth = 0.7
        profileImageButton.layer.borderColor = UIColor.systemBackground.cgColor
        profileImageButton.isEnabled = false
        // Horizontal 拡大
        profileImageButton.contentHorizontalAlignment = .fill
//                // Vertical 拡大
        
        profileImageButton.contentVerticalAlignment = .fill
        DispatchQueue.main.async {
            
            self.profileImageButton.imageView?.addSubview(self.profileImageImageview)
            self.profileImageImageview.setDimensions(
                                                height: self.profileImageButton.frame.height,
                                                width: self.profileImageButton.frame.width
                                            )
        }
        
        
    }
    
    @IBAction func tappedChangePhoto(_ sender: UIButton) {
        print("tappedChangePhoto")
    
    }
    
    private func configure(user: User) {
        profileImageImageview.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
    }
    
    @objc func didTapdismiss() {
        let transition = CATransition()
           transition.duration = 0.2
           transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromRight
           view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.popToRootViewController(animated: false)
    }
    
}




//MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        accountMenus.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        default:
            return 1
        }
        //accountMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.textField.backgroundColor = #colorLiteral(red: 0.3305901885, green: 0.4503111243, blue: 0.7627663016, alpha: 1)
        cell.lable.text = accountMenus[indexPath.section].rawValue
        cell.textLabel?.text = accountMenus[indexPath.section].rawValue
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = #colorLiteral(red: 0.1358366907, green: 0.1817382276, blue: 0.3030198812, alpha: 1)
        
        let selectionView = UIView()
        switch accountMenus[indexPath.section] {
            
        case .name:
            if let user = user {
                cell.textLabel?.isHidden = true
                cell.lable.isHidden = false
                cell.selectionStyle = .none
                cell.textField.textAlignment = .center
                cell.textField.isHidden = false
                cell.textField.text = user.name
                cell.layer.cornerRadius = 15
            }
            return cell
        
        case .mailaddress, .password:
            selectionView.backgroundColor = UIColor.blue
            cell.selectedBackgroundView = selectionView
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.7300020456, blue: 0.8954316974, alpha: 1)
            cell.layer.cornerRadius = 10
            return cell
        case .deleteAccount:
            
            selectionView.backgroundColor = #colorLiteral(red: 0.982794106, green: 0.4097733498, blue: 0.4362072051, alpha: 1)
            cell.selectedBackgroundView = selectionView
            cell.textLabel?.textColor = .red
            cell.layer.cornerRadius = 5
            return cell
        }
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch accountMenus[indexPath.section] {
            
        case .name:
            return 80
        case .mailaddress, .password:
            return 40
        case .deleteAccount:
            return 25
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7.5
    }
    
}
