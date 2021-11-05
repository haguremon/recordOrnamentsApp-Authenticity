//
//  AccountViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//


import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func didSelectMeunItem(_ viewController: AccountViewController, name: AccountMenu)
}

enum AccountMenu: String,CaseIterable{
    case name = "名前"
    case password = "パスワードをリセット"
    case deleteAccount = "アカウント削除"
    case exit = "戻る"
}

class AccountViewController: UIViewController {
    
    var user: User? {
        didSet{
            guard let user = user else { return }
            configure(user: user)
        }
    }
    
    let accountMenus: [AccountMenu] = AccountMenu.allCases
    
    
    weak var delegate: AccountViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var profileImage: UIImage?
    
    @IBOutlet weak var upDateButton: UIButton!
    
    @IBAction func upDateAccountButton(_ sender: Any) {
    
        DispatchQueue.main.async {
            self.profileImageButton.isEnabled = true
            self.profileImageImageview.image = UIImage(systemName: "camera.circle")
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    
    }
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
        navigationItem.leftBarButtonItem?.isEnabled = false
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapdismiss))
  
        
        profileImageButton.layer.cornerRadius = 45
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = 45
        profileImageButton.layer.borderWidth = 0.7
        profileImageButton.layer.borderColor = UIColor.systemBackground.cgColor
        profileImageButton.isEnabled = false
        upDateButton.layer.cornerRadius = 5
        upDateButton.layer.shadowRadius = 5
        upDateButton.layer.shadowOpacity = 1.0
        
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
           // self.navigationItem.leftBarButtonItem?.isEnabled = true

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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.endEditing(true)
    }
    
}




//MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        accountMenus.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.backgroundColor = #colorLiteral(red: 0.1358366907, green: 0.1817382276, blue: 0.3030198812, alpha: 1)
        cell.lable.text = accountMenus[indexPath.section].rawValue
        var content = cell.defaultContentConfiguration()
        content.text = accountMenus[indexPath.section].rawValue
        content.textProperties.alignment = .center
        content.textProperties.color = .white
        
        let selectionView = UIView()
        cell.selectedBackgroundView = selectionView
        
        switch accountMenus[indexPath.section] {
            
        case .name:
            
            guard let user = user else { return cell}
            cell.selectionStyle = .none
            cell.textField.textAlignment = .center
            cell.textField.backgroundColor = #colorLiteral(red: 0.3305901885, green: 0.4503111243, blue: 0.7627663016, alpha: 1)
            cell.textField.text = user.name
            cell.textField.isEnabled = true
            cell.delegat = self
            cell.layer.cornerRadius = 15
            return cell
            
        case .password:
            
            selectionView.backgroundColor = UIColor.blue
            cell.layer.cornerRadius = 10
            content.textProperties.color = #colorLiteral(red: 0, green: 0.7300020456, blue: 0.8954316974, alpha: 1)
            cell.contentConfiguration = content
            return cell
            
        case .deleteAccount:
            
            selectionView.backgroundColor = #colorLiteral(red: 0.982794106, green: 0.4097733498, blue: 0.4362072051, alpha: 1)
            cell.layer.cornerRadius = 5
            content.textProperties.color = .red
            content.textProperties.font = UIFont.systemFont(ofSize: 14)
            cell.contentConfiguration = content
            return cell
        case .exit:
            selectionView.backgroundColor = .gray
            cell.layer.cornerRadius = 15
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectItem = accountMenus[indexPath.section]
        //ここでの通知をViewControllernに伝えてその内容をViewControllerでやる
        delegate?.didSelectMeunItem(self, name: selectItem)
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch accountMenus[indexPath.section] {
            
        case .name:
            return 80
        case .password:
            return 40
        case .deleteAccount:
            return 35
        case .exit:
           return 40
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch accountMenus[indexPath.section] {
        case .name:
            return nil
        case .password, .deleteAccount, .exit:
            return indexPath
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
extension AccountViewController: TableViewCellDelegat{
    func cell(_ cell: TableViewCell) {
        
        navigationItem.leftBarButtonItem?.isEnabled = true

    }
}
