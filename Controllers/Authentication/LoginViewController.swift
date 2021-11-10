//
//  ViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/03.
// 

import UIKit
import Lottie

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet private var animationView: UIView!
    
    
    @IBOutlet  weak var emailTextField: UITextField!
    var email: String? = ""
   
    @IBOutlet  weak var passwordTextField: UITextField!
    var password: String? = ""
    
    @IBOutlet private var loginButton: UIButton!
    var isLogged: Bool? = false
    
    @IBOutlet private var SignupPageButton: UIButton!
    
    
    @IBOutlet private var messageLabel: UILabel!
    var message: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        movingBackground()
        messageLabel.isHidden = true
        congigureButtton()
        congigureTextField()
   
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.text = email
        passwordTextField.text = password
        messageLabel.isHidden = false
        messageLabel.text = message
        loginButton.isEnabled = isLogged!
    }
    
        
    private func  congigureButtton() {
      
        loginButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        loginButton.isEnabled = false
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.cornerRadius = 20
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 1.0
        loginButton.backgroundColor = #colorLiteral(red: 0.053540878, green: 0.01193358283, blue: 0.9903386235, alpha: 0.1031146523)
        
        
        SignupPageButton.layer.shadowOffset = CGSize(width: 1, height: 1 )
        SignupPageButton.isEnabled = true
        SignupPageButton.layer.shadowColor = UIColor.gray.cgColor
        SignupPageButton.layer.cornerRadius = 20
        SignupPageButton.layer.shadowRadius = 5
        SignupPageButton.layer.shadowOpacity = 1.0
        SignupPageButton.backgroundColor = #colorLiteral(red: 0.9498600364, green: 0.03114925325, blue: 0.1434316933, alpha: 1)
        

        
    }
    private func congigureTextField() {
        
        emailTextField.keyboardType = .emailAddress
        
     
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        emailTextField.returnKeyType = .continue
        passwordTextField.returnKeyType = .done
        
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
    
    @IBAction func loginButton(_ sender: UIButton) {
        handleLogin(sender)
        
        
    }
    
    private func handleLogin(_ sender: UIButton?) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text, password.count >= 8 else { return showMessage(withTitle: "パスワード", message: "パスワードが8文字以下です", handler: nil) }
        
        AuthService.logUserIn(withEmail: email, password: password) { [ weak self ] result, error in
            if let error = error {
                sender?.showAnimation(false)
                self?.showErrorIfNeeded(error)
                return
            }
            sender?.showAnimation(true)
            let ornamentViewController = self?.storyboard?.instantiateViewController(identifier: "OrnamentViewController") as! OrnamentViewController
            let navVC = UINavigationController(rootViewController: ornamentViewController)
            navVC.modalPresentationStyle = .fullScreen
       self?.present(navVC, animated: true, completion: nil)
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
                                   self?.messageLabel.text = "リセット用のメールを送りました!"
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func goSignupPage(_ sender: UIButton) {
        sender.showAnimation(true)
       
        presentToRegistrationViewController()
    }
    
    
    
    private func presentToRegistrationViewController() {
        let newRegistrationViewController = storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
        newRegistrationViewController.modalPresentationStyle = .fullScreen
        
        present(newRegistrationViewController, animated: true, completion: nil)
        
    }
    
    private func presentToOrnamentViewController() {
        let newRegistrationViewController = storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
        newRegistrationViewController.modalPresentationStyle = .fullScreen
        
        present(newRegistrationViewController, animated: true, completion: nil)
      
        
    }
   
    
    
    @IBAction private func exit(segue: UIStoryboardSegue) {
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.053540878, green: 0.01193358283, blue: 0.9903386235, alpha: 0.1972785596)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.053540878, green: 0.01193358283, blue: 0.9903386235, alpha: 1)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            //nameEmailTextFieldでリターンが押された時にpasswordTextFieldのキーボードを開く
            passwordTextField.becomeFirstResponder()
        
        } else if textField ==  passwordTextField {
            //textFieldが押されたらログインボタンが起動する
            handleLogin(nil)
        }
        
        return true
    }
    
}
