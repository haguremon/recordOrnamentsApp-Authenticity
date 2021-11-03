//
//  AccountViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//


import UIKit


enum AccountMenu: String,CaseIterable{
    case name = "名前"
    case mailaddress = "メールアドレス"
    case space = ""
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
   }
    private func configureUI() {
        navigationItem.title = "アカウント"
        
        view.backgroundColor = .systemBackground
        //navigationController?.navigationBar.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(didTapdismiss))
 
        profileImageButton.layer.cornerRadius = 45
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = 45
        profileImageButton.layer.borderWidth = 0.7
        profileImageButton.layer.borderColor = UIColor.systemBackground.cgColor
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
        print("\(user.profileImageUrl)")
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.lable.text = accountMenus[indexPath.row].rawValue
        cell.textLabel?.tintColor = .secondaryLabel
        cell.textField.isHidden = false
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0...1:
            cell.lable.textColor = .label
            return cell
        case 2...3:
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor.red
            cell.selectedBackgroundView = selectionView
            cell.textLabel?.text = accountMenus[indexPath.row].rawValue
            cell.textLabel?.textAlignment = .center
            cell.lable.isHidden = true
            cell.textField.isHidden = true
            cell.selectionStyle = .default
            return cell
        
        default:
            return cell
        }
        
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
       
        case 0...1:
            return 80
        
        case 2:
           return 2
        
        case 3:
            return 25
        
        default:
            return 20
        
        }
        
        
    }
}
