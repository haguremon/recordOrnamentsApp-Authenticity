//
//  NewRegistrationsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/04.
//

import UIKit
import Lottie


class NewRegistrationViewController: UIViewController {
    @IBOutlet private var animationView: UIView!
    
    @IBOutlet weak var profileImageButton: UIButton!
   
    private var selectedImage: UIImage? = UIImage(systemName: "person.circle.fill")
   
    @IBOutlet private var emailTextField: UITextField!
   
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var userNameTextField: UITextField!
    
    @IBOutlet private var registerButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var label: UILabel!
   
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        print("tap")
        handleAuthToFirebase()
    }
    
    @IBAction func tappedDismisButton(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.password = passwordTextField.text
        loginViewController.email = emailTextField.text
        present(loginViewController, animated: true, completion: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        movingBackground()
        congigureButtton()
        messageLabel.isHidden = true
   
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        print("tap")
        
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

    private func handleAuthToFirebase() {
        registerButton.isEnabled = false
        guard let email = emailTextField.text, !email.isEmpty else { return showMessage(withTitle: "エラー", message: "適切なメールアドレスを入力してください") }
        guard let password = passwordTextField.text, password.count >= 8 else { return showMessage(withTitle: "短いです", message: "8文字以上入力してください") }
              let name = userNameTextField.text ?? ""
        let authCredential = AuthCredentials(email: email, password: password, name: name, profileImage: selectedImage)

        AuthService.registerUser(self,withCredential: authCredential) { (error) in
            if let error = error {
                self.showErrorIfNeeded(error)
                self.registerButton.isEnabled = true
                return
            }
                self.showMessage(withTitle: "認証", message: "入力したメールアドレス宛に確認メールを送信しました")
        
                self.showErrorIfNeeded(error)
            DispatchQueue.main.async {
                self.messageLabel.isHidden = false
                self.label.isHidden = true
                self.messageLabel.text = "認証後ログインしてください"
            }
            
        }
        
    }

    private func configureUI() {
 
    }
    private func  congigureButtton() {
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        userNameTextField.keyboardType = .namePhonePad
        
        registerButton.isEnabled = false
        registerButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        registerButton.layer.shadowColor = UIColor.gray.cgColor
        registerButton.layer.cornerRadius = 20
        registerButton.layer.shadowRadius = 5
        registerButton.layer.shadowOpacity = 1.0
        registerButton.backgroundColor = UIColor(r: 180, g: 255, b: 211)
        
        
        
        profileImageButton.layer.cornerRadius = 45
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.imageView?.layer.cornerRadius = 45
        profileImageButton.layer.borderWidth = 0.7
        profileImageButton.layer.borderColor = UIColor.systemBackground.cgColor
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
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

//  MARK: -UIImagePickerControllerDelegate
extension NewRegistrationViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        self.selectedImage = selectedImage
        
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 2
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            self.dismiss(animated: true, completion: nil)
    }

    
}
extension NewRegistrationViewController :UITextFieldDelegate { //可読性の向上ｗ
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
       let emailIsEmpty = emailTextField.text?.isEmpty ?? true
       let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
       let usernameIsEmpty = userNameTextField.text?.isEmpty ?? true
       if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
           registerButton.isEnabled = false
           registerButton.backgroundColor = UIColor(r: 180, g: 255, b: 221)
       } else {
           registerButton.isEnabled = true
          registerButton.backgroundColor = UIColor(r: 0, g: 255, b: 150)
       }
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
