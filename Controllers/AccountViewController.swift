//
//  AccountViewController1.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/13.
//

import UIKit
import FirebaseAuth


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
    
    let collectionViewLayout = CollectionViewLayout()
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    private var updateprofileImage: UIImage?
    
    private var updatename: String?
    private var profileImageUrl: String?
    
    
    @IBOutlet weak var upDateButton: UIButton!
    
    @IBAction func upDateAccountButton(_ sender: UIButton) {
        sender.showAnimation(true)
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
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.collectionViewLayout = collectionViewLayout.accountCollectionViewLayout(profileImageButton.bounds.width)
        
        collectionView.isScrollEnabled = false
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    private func configureUI() {
        messageLabel.isHidden = true
        navigationItem.title = "アカウント"
        setStatusBarBackgroundColor(#colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149))
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //navigationController?.navigationBar.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(didTappedismiss))
        navigationItem.rightBarButtonItem?.tintColor = .green
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didtappedSave))
        navigationItem.leftBarButtonItem?.tintColor = .blue
        
        profileImageButton.layer.cornerRadius = view.bounds.width / 7
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = view.bounds.width / 7
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        profileImageButton.isEnabled = false
        profileImageButton.contentHorizontalAlignment = .fill
//                // Vertical 拡大
        profileImageButton.contentVerticalAlignment = .fill
        
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
        navigationController?.popToRootViewController(animated: false)
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
    private func showRemoveDialog() {
        let alert = UIAlertController(title: "削除", message: "データは復元されません", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "削除する", style: .default, handler: { [ weak self ] _ in
            self?.deleteAccount()
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    private func deleteAccount(){
        
        Auth.auth().currentUser?.delete {  (error) in

            if error == nil {
                self.presentToViewController()
            } else {
                
                self.showErrorIfNeeded(error)
            }
        }
        
        
    }
}




//MARK: - UITableViewDelegate
extension AccountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        accountMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AccountCollectionViewCell
      
        cell.clipsToBounds = true
        cell.textField.text = accountMenus[indexPath.section].rawValue
        
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: cell.bounds.height / 2.7)
        
        cell.textField.font = UIFont.boldSystemFont(ofSize: cell.bounds.height / 2.25)

        cell.accountMenuLabel.font = UIFont.boldSystemFont(ofSize: cell.bounds.height / 2.5)

        
        switch accountMenus[indexPath.section] {
            
        case .name:
            
            guard let user = user else { return cell}
            cell.isSelected = false
            cell.nameLabel.isHidden = false
            cell.textField.isHidden = false
            cell.accountMenuLabel.isHidden = true
            cell.textField.textAlignment = .center
            cell.textField.backgroundColor = #colorLiteral(red: 0.3305901885, green: 0.4503111243, blue: 0.7627663016, alpha: 1)
            cell.nameLabel.text = " ニックネーム "
            cell.textField.text = user.name
            cell.textField.isEnabled = true
            cell.delegat = self
            cell.layer.cornerRadius = cell.bounds.height / 4
            cell.contentView.layer.cornerRadius = cell.bounds.height / 4
            return cell
            
        case .password:
            

            cell.layer.cornerRadius = cell.bounds.height / 2.5
            cell.accountMenuLabel.text = accountMenus[indexPath.section].rawValue
            cell.accountMenuLabel.tintColor = #colorLiteral(red: 0, green: 0.7300020456, blue: 0.8954316974, alpha: 1)
            cell.accountMenuLabel.textColor = #colorLiteral(red: 0, green: 0.7300020456, blue: 0.8954316974, alpha: 1)
            return cell
            
        case .deleteAccount:
           
            cell.layer.cornerRadius = cell.bounds.height / 3
            cell.accountMenuLabel.text = accountMenus[indexPath.section].rawValue
            cell.accountMenuLabel.tintColor = .red
            cell.accountMenuLabel.textColor = .red
            cell.accountMenuLabel.font = UIFont.systemFont(ofSize: cell.bounds.height / 2.5)
            return cell
        case .exit:
            cell.accountMenuLabel.text = accountMenus[indexPath.section].rawValue
            cell.layer.cornerRadius = cell.bounds.height / 2.5
            cell.accountMenuLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch accountMenus[indexPath.section] {
            
        case .name:
            print("")
        case .password:
            resetPasswordMessege(self)
        case .deleteAccount:
            showRemoveDialog()
        case .exit:
            didTappedismiss()
        }
    
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




extension AccountViewController: AccountCollectionViewCellDelegat{
    func textFieldShouldReturnCell(_ cell: AccountCollectionViewCell) -> Bool {
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
    
    func cell(_ cell: AccountCollectionViewCell){
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
extension AccountViewController {
   
    private func presentToViewController() {
        
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: false, completion: nil)
        
    }
    
    func resetPasswordMessege(_ accountViewController: AccountViewController) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
           alert.view.setNeedsLayout()
           alert.title = "パスワードリセット"
           alert.message = "ログイン時のメールアドレスを入力してください"

           alert.addTextField(configurationHandler: {(textField) -> Void in

               textField.textContentType = .emailAddress
               textField.placeholder = "メールアドレス"
           })
           //追加ボタン
           alert.addAction(
               UIAlertAction(
                   title: "入力完了",
                   style: .default,
                   handler: { [ weak self ] _ in
                       guard let email =  alert.textFields?.first?.text else {
                           self?.showMessage(withTitle: "エラー", message: "適切なメールアドレスが入力されていません")
                          
                           return
                           
                       }
                       AuthService.resetPassword(withEmail: email) { error in
                           
                           if let error = error {
                               self?.showErrorIfNeeded(error)
                               return
                           }
                           
                           DispatchQueue.main.async {
                               accountViewController.messageLabel.isHidden = false
                               accountViewController.messageLabel.text = "リセット用のメールを送りました!"
                               
                               
                           }
                           
                           
                       }
                           
                       
                   })
           )
    
        //キャンセルボタン
           alert.addAction(
           UIAlertAction(
               title: "キャンセル",
               style: .cancel
           )
           )
           //アラートが表示されるごとにprint
           self.present(
           alert,
           animated: true,
           completion: {
               print("アラートが表示された")
           })
    

    }


    
    
}
