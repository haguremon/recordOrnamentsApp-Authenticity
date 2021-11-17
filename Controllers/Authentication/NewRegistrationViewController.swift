//
//  NewRegistrationsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/04.
//

import UIKit
import Lottie


class NewRegistrationViewController: UIViewController {
    
    // MARK: - プロパティ等
    @IBOutlet private var animationView: UIView!
    
    @IBOutlet weak var profileImageButton: UIButton!
   
    private var selectedImage: UIImage? = UIImage(systemName: "person.circle.fill")
   
    @IBOutlet private var emailTextField: UITextField!
   
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var userNameTextField: UITextField!
    
    @IBOutlet private var registerButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var label: UILabel!

    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
       
        movingBackground()
        congigureButtton()
        congigureTextField()
        messageLabel.isHidden = true
   
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - メソッド等
     @IBAction func tappedRegisterButton(_ sender: UIButton) {
     
         handleAuthToFirebase(sender)
     }
     
     @IBAction func tappedDismiss(_ sender: Any) {
         let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
         loginViewController.modalPresentationStyle = .fullScreen
         loginViewController.email = emailTextField.text
         present(loginViewController, animated: true, completion: nil)
     
     }
     
    
    @IBAction func setprofileImageButton(_ sender: UIButton) {
        showMessage1(withTitle: "写真", message: "プロフィール画像を追加しますか？")
    
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
            self.permissionDialog()
            present(picker, animated: true, completion: nil)
            
       }  else {

            picker.delegate = self
            picker.allowsEditing = true

            present(picker, animated: true, completion: nil)
        }

    
    }
    
    private func setAlbum(){
         
         let picker = UIImagePickerController()
             picker.delegate = self
             picker.allowsEditing = true

             present(picker, animated: true, completion: nil)
         }

    private func handleAuthToFirebase(_ sender: UIButton?) {
        registerButton.isEnabled = false
        
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty else { return showMessage(withTitle: "エラー", message: "適切なメールアドレスを入力してください") }
        guard let password = passwordTextField.text, password.count >= 8 else { return showMessage(withTitle: "短いです", message: "8文字以上入力してください") }
              let name = userNameTextField.text ?? ""
        let authCredential = AuthCredentials(email: email, password: password, name: name, profileImage: selectedImage)

        AuthService.registerUser(self,withCredential: authCredential) { (error) in
            if let error = error {
                self.showErrorIfNeeded(error)
                self.registerButton.isEnabled = true
                sender?.showAnimation(false)
                return
            }
            self.showMessage(withTitle: "認証", message: "入力したメールアドレス宛に確認メールを送信しました") { [ weak self ] _ in
                sender?.showAnimation(true)
                DispatchQueue.main.async {
                   
                    let loginViewController = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                    loginViewController.modalPresentationStyle = .fullScreen
                    loginViewController.email = self?.emailTextField.text
                    loginViewController.message = "確認メールを認証してください"
                    self?.present(loginViewController, animated: true, completion: nil)
                    
                }
            }
                self.showErrorIfNeeded(error)
            DispatchQueue.main.async {
                self.messageLabel.isHidden = false
                self.label.isHidden = true
                self.messageLabel.text = "認証後ログインしてください"
            }
            
        }
        
    }

    
    // MARK: - UI等
    private func  congigureButtton() {
  
        registerButton.isEnabled = false
        registerButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        registerButton.layer.shadowColor = UIColor.gray.cgColor
        registerButton.layer.cornerRadius = 20
        registerButton.layer.shadowRadius = 5
        registerButton.layer.shadowOpacity = 1.0
        registerButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
        profileImageButton.layer.cornerRadius = view.bounds.width / 8.25
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = view.bounds.width / 8.25
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.green.cgColor
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        
        
    }
    
    private func congigureTextField() {
        
        emailTextField.keyboardType = .emailAddress
        userNameTextField.keyboardType = .default
        
        emailTextField.returnKeyType = .continue
        passwordTextField.returnKeyType = .continue
        userNameTextField.returnKeyType = .done
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        

        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))
        userNameTextField.leftViewMode = .always
        userNameTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))
        
       
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
    }
    
    
    
    
    private func movingBackground() {
        
        
        let background = AnimationView(name: "background2")
        background.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 10)
        background.center = view.center
        background.loopMode = .autoReverse
        background.contentMode = .scaleAspectFit
        background.animationSpeed = 0.7
        background.isUserInteractionEnabled = true
        animationView.addSubview(background)
        background.play()
        
        
    }

}

//  MARK: - UIImagePickerControllerDelegate
extension NewRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        self.selectedImage = selectedImage
        
        if picker.sourceType == .camera {
            
            UIImageWriteToSavedPhotosAlbum(selectedImage,self,nil,nil)
            
        }
        
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 2
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            self.dismiss(animated: true, completion: nil)
    }

    
}
//  MARK: - UITextFieldDelegate
extension NewRegistrationViewController: UITextFieldDelegate { //可読性の向上ｗ
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
       let emailIsEmpty = emailTextField.text?.isEmpty ?? true
       let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
       let usernameIsEmpty = userNameTextField.text?.isEmpty ?? true
       if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
           registerButton.isEnabled = false
           registerButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
       } else {
           registerButton.isEnabled = true
          registerButton.backgroundColor = #colorLiteral(red: 0.9498600364, green: 0.03114925325, blue: 0.1434316933, alpha: 1)
       }
   }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        
        } else if textField ==  passwordTextField {
           
            passwordTextField.resignFirstResponder()
            userNameTextField.becomeFirstResponder()

        } else {
            handleAuthToFirebase(nil)
        }
        
        return true
    }
    
    
    


}
extension NewRegistrationViewController {
    
    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        
        if userNameTextField.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -100)
                self.view.transform = transform
            })
        }
        
        if userNameTextField.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -150)
                self.view.transform = transform
            })
        }
    }
    
    @objc func hidekeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = .identity
        })
    }
    //画面をタップした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
