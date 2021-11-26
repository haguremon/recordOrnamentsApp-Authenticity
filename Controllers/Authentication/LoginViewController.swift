//
//  ViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/03.
// 

import UIKit
import Lottie

final class LoginViewController: UIViewController {
    
    // MARK: - プロパティ等
    @IBOutlet private var animationView: UIView!
    
    @IBOutlet  weak var emailTextField: UITextField!
    var email: String? = ""
    
    @IBOutlet  weak var passwordTextField: UITextField!
    
    @IBOutlet private var loginButton: UIButton!
    
    @IBOutlet private var SignupPageButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    var message: String? = ""
    
    @IBOutlet private var appNameLabel: UILabel!
    
    
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        movingBackground()
        messageLabel.isHidden = true
        messageLabel.adjustsFontSizeToFitWidth = true
        congigureButtton()
        congigureTextField()
        appNameLabel.font = UIFont.systemFont(ofSize: view.bounds.height / 11, weight: .bold)
        print("viewDidLoad")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.text = email
        messageLabel.text = message
        
        if message  != "" {
            messageLabel.isHidden = false
        }
    }
    
    // MARK: - メソッド等
    @IBAction func loginButton(_ sender: UIButton) {
        handleLogin(sender)
    }
    
    
    private func handleLogin(_ sender: UIButton?) {
        sender?.isEnabled = false
        sender?.showSuccessAnimation(true)
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty else {
            sender?.isEnabled = true
            return showMessage(withTitle: "エラー", message: "適切なメールアドレスを入力してください")
        }
        guard let password = passwordTextField.text, password.count >= 6 else {
            sender?.isEnabled = true
            return showMessage(withTitle: "短いです", message: "6文字以上入力してください")
        }
        
        AuthService.logUserIn(withEmail: email, password: password) { [ weak self ] _, error in
            if let error = error {
                sender?.showSuccessAnimation(false)
                sender?.isEnabled = true
                self?.showErrorIfNeeded(error)
                return
            }
            
            sender?.isEnabled = false
            let ornamentViewController = self?.storyboard?.instantiateViewController(identifier: "OrnamentViewController") as! OrnamentViewController
            let navVC = UINavigationController(rootViewController: ornamentViewController)
            navVC.modalPresentationStyle = .fullScreen
            
            self?.present(navVC, animated: true)
        }
        
    }
    
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        messageLabel.isHidden = false
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "パスワードリセット"
        alert.message = "ログイン時のメールアドレスを入力してください"
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
            textField.textContentType = .emailAddress
            textField.placeholder = "パスワード"
        })
        
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
                            self?.messageLabel.text = "リセット用のメールを送りました!"
                        }
                        
                    }
                    
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel
            )
        )
        
        self.present(
            alert,
            animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func openSignupPage(_ sender: UIButton) {
        sender.showSuccessAnimation(true)
        openRegistrationViewController()
    }
    
    
    private func openRegistrationViewController() {
        let newRegistrationViewController = storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
        newRegistrationViewController.modalPresentationStyle = .fullScreen
        
        present(newRegistrationViewController, animated: true)
    }
    
    
    private func openOrnamentViewController() {
        let newRegistrationViewController = storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
        newRegistrationViewController.modalPresentationStyle = .fullScreen
        
        present(newRegistrationViewController, animated: true)
    }
    
    // MARK: - UI等
    private func  congigureButtton() {
        loginButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        loginButton.isEnabled = false
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.cornerRadius = 20
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 1.0
        loginButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        SignupPageButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        SignupPageButton.isEnabled = true
        SignupPageButton.layer.shadowColor = UIColor.gray.cgColor
        SignupPageButton.layer.cornerRadius = 20
        SignupPageButton.layer.shadowRadius = 5
        SignupPageButton.layer.shadowOpacity = 1.0
        SignupPageButton.backgroundColor = .systemRed
    }
    
    
    private func congigureTextField() {
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.placeholder = "6文字以上"
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        emailTextField.returnKeyType = .continue
        passwordTextField.returnKeyType = .done
        
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    private func movingBackground() {
        let background = AnimationView(name: "background2")
        background.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 10)
        background.center = self.view.center
        background.loopMode = .autoReverse
        background.contentMode = .scaleAspectFit
        background.animationSpeed = 0.7
        animationView.addSubview(background)
        background.play()
    }
    
    
}


//  MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField ==  passwordTextField {
            handleLogin(nil)
        }
        
        return true
    }
    
    
}
