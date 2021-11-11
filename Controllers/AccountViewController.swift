//
//  AccountViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//


import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func didSelectMeunItem(_ viewController: AccountViewController, name: AccountMenu)
    func controllerDidFinishUpDateUser()
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
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    private var updateprofileImage: UIImage?
    
    private var updatename: String?
    private var profileImageUrl: String?
    
    
    @IBOutlet weak var upDateImageButton: UIButton!
    
    @IBAction func upDateAccountButton(_ sender: Any) {
       
        showMessage1(withTitle: "写真", message: "プロフィール画像を変更しますか？")
        
     
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
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    private func configureUI() {
        messageLabel.isHidden = true
        navigationItem.title = "アカウント"
        setStatusBarBackgroundColor(.white)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(didTappedismiss))
        navigationItem.rightBarButtonItem?.tintColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didtappedSave))
        navigationItem.leftBarButtonItem?.tintColor = .blue
       
        
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = profileImageButton.bounds.width / 2.25
        profileImageButton.imageView?.layer.borderWidth = 1
        profileImageButton.imageView?.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        profileImageButton.isEnabled = false
        profileImageButton.contentHorizontalAlignment = .fill
//                // Vertical 拡大
        profileImageButton.contentVerticalAlignment = .fill
        
        upDateImageButton.layer.cornerRadius = 5
        upDateImageButton.layer.shadowRadius = 5
        upDateImageButton.layer.shadowOpacity = 1.0
        
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
            
        
    }
    @objc public func dismissKeyboard() {
          view.endEditing(true)
      }
    
    private func configure(user: User) {
        profileImageImageview.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        updatename = user.name
        profileImageUrl = user.profileImageUrl
    }
    
    @objc func didTappedismiss() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
       
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func didtappedSave() {
        showLoader(true)
        navigationItem.leftBarButtonItem?.isEnabled = false
        if user!.name == updatename && updateprofileImage == nil {
            showLoader(false)
            navigationItem.leftBarButtonItem?.isEnabled = true
            return
        }
        
        let updateUser = UpdateUser(name: updatename, profileImage: updateprofileImage)
        
        UserService.updateUser(self, ownerUid: user!, updateUser: updateUser) { user in
            DispatchQueue.main.async {
                //self.user = user
                self.showLoader(false)
                self.navigationItem.leftBarButtonItem?.isEnabled = false
            }
            self.delegate?.controllerDidFinishUpDateUser()
        }
          
           
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
        cell.selectionStyle = .default
      
        var content = cell.defaultContentConfiguration()
        content.text = accountMenus[indexPath.section].rawValue
        content.textProperties.alignment = .center
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: cell.bounds.height / 3.5)
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
            cell.contentView.layer.cornerRadius = 15
            cell.layer.cornerRadius = 15
            return cell
            
        case .password:
            selectionView.backgroundColor = UIColor.blue
            cell.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
            content.textProperties.color = #colorLiteral(red: 0, green: 0.7300020456, blue: 0.8954316974, alpha: 1)
            cell.contentConfiguration = content
            return cell
            
        case .deleteAccount:
            
            selectionView.backgroundColor = #colorLiteral(red: 0.982794106, green: 0.4097733498, blue: 0.4362072051, alpha: 1)
            cell.layer.cornerRadius = 5
            cell.contentView.layer.cornerRadius = 5
            content.textProperties.color = .red
            content.textProperties.font = UIFont.systemFont(ofSize: 14)
            cell.contentConfiguration = content
            return cell
        case .exit:
            selectionView.backgroundColor = .gray
            cell.layer.cornerRadius = 15
            cell.contentView.layer.cornerRadius = 15
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectItem = accountMenus[indexPath.section]
       
        delegate?.didSelectMeunItem(self, name: selectItem)
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch accountMenus[indexPath.section] {
            
        case .name:
            return profileImageButton.bounds.height / 1.4
        case .password:
            return profileImageButton.bounds.height / 1.9
        case .deleteAccount:
            return profileImageButton.bounds.height / 2.5
        case .exit:
           return profileImageButton.bounds.height / 1.9
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
//
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return profileImageButton.bounds.height / 10
    }
    
}
//  MARK: -UIImagePickerControllerDelegate
extension AccountViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else {
                
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                return
                
            }
        self.updateprofileImage = selectedImage
        
        profileImageImageview.image = selectedImage
  
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
    func showMessage1(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "カメラで撮影", style: .default, handler: { [ weak self ] _ in
            self?.setCamera()
        }))
        alert.addAction(UIAlertAction(title: "写真を選択", style: .default, handler: { [ weak self ] _ in
            self?.setAlbum()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
   private func setCamera(){
    
        let camera = UIImagePickerController.SourceType.camera
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(camera) {
           
            picker.sourceType = camera
            picker.delegate = self
            picker.allowsEditing = true
    
            present(picker, animated: true, completion: nil)
            
       }  else {

            picker.delegate = self
            picker.allowsEditing = true

            present(picker, animated: true, completion: nil)
        }

    
    }
    
    private func setAlbum(){
         print("tap")
         
         let picker = UIImagePickerController()
             picker.delegate = self
             picker.allowsEditing = true

             present(picker, animated: true, completion: nil)
         }

    
}




extension AccountViewController: TableViewCellDelegat{
    func textFieldShouldReturnCell(_ cell: TableViewCell) -> Bool {
        if user?.name == cell.textField.text {
            updatename = cell.textField.text
            if updateprofileImage == nil {
            navigationItem.leftBarButtonItem?.isEnabled = false
            }
            return false
        } else {
            updatename = cell.textField.text
            navigationItem.leftBarButtonItem?.isEnabled = true
            return true
        }
       

    }
    
    func cell(_ cell: TableViewCell){
        cell.textField.isEnabled = true
        if user?.name == cell.textField.text {
            updatename = cell.textField.text
            if updateprofileImage == nil {
            navigationItem.leftBarButtonItem?.isEnabled = false
            }
        } else {
            updatename = cell.textField.text
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    
    }
}
