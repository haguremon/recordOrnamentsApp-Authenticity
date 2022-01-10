//
//  NewRegistrationsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/04.
//

import UIKit
import Lottie


final class NewRegistrationViewController: UIViewController {
    
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
        configureButtton()
        configureTextField()
        messageLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - メソッド等
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        handleAuthToFirebase()
    }
    
    
    @IBAction func tappedDismiss(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.email = emailTextField.text
        
        present(loginViewController, animated: true)
    }
    
    
    @IBAction func setprofileImageButton(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        showMessage1(withTitle: "写真", message: "プロフィール画像を追加しますか？")
    }
    
    
    func showMessage1(withTitle title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "カメラで撮影", style: .default, handler: { [ weak self ] _ in
            self?.setCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "写真を選択", style: .default, handler: { [ weak self ] _ in
            self?.setAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    
    private func setCamera() {
        let camera = UIImagePickerController.SourceType.camera
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(camera) {
            picker.sourceType = camera
            picker.delegate = self
            picker.allowsEditing = true
            
            self.showPermissionMessage()
            
            present(picker, animated: true)
            
        } else {
            
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true)
        }
        
    }
    
    
    private func setAlbum(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    
    private func handleAuthToFirebase() {
        registerButton.isEnabled = false
        registerButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemRed
            registerButton.showSuccessAnimation(false)
            return showMessage(withTitle: "エラー", message: "適切なメールアドレスを入力してください")
        }
        guard let password = passwordTextField.text, password.count >= 6 else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemRed
            registerButton.showSuccessAnimation(false)
            return showMessage(withTitle: "短いです", message: "6文字以上入力してください")
        }
        
        let name = userNameTextField.text ?? ""
        
        let authCredential = AuthCredentials(email: email, password: password, name: name, profileImage: selectedImage)
        AuthService.registerUser(self, button: registerButton,withCredential: authCredential) { (error) in
            self.showLoader(true)
            self.showMessage(withTitle: "認証", message: "入力したメールアドレス宛に確認メールを送信しました") { [ weak self ] _ in
                self?.showLoader(false)
                self?.registerButton.backgroundColor = .systemRed
                self?.registerButton.isEnabled = true
                
                let loginViewController = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                loginViewController.email = self?.emailTextField.text
                loginViewController.message = "確認メールを認証してください"
                self?.present(loginViewController, animated: true)
            }
        }
        
    }
    
    
    // MARK: - UI等
    private func configureButtton() {
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
    
    
    private func configureTextField() {
        
        emailTextField.keyboardType = .emailAddress
        userNameTextField.keyboardType = .default
        
        passwordTextField.placeholder = "6文字以上"
        
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
                                                      width: 5,
                                                      height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: .init(x: 0,
                                                         y: 0,
                                                         width: 5,
                                                         height: 0))
        userNameTextField.leftViewMode = .always
        userNameTextField.leftView = UIView(frame: .init(x: 0,
                                                         y: 0,
                                                         width: 5,
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
        
        self.dismiss(animated: true)
    }
    
    
}


//  MARK: - UITextFieldDelegate
extension NewRegistrationViewController: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = userNameTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemRed
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
            handleAuthToFirebase()
        }
        
        return true
    }
    
    
}


//MARK: - キーボード周り
extension NewRegistrationViewController {
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if userNameTextField.isFirstResponder {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            
        }
        
    }

    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
