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
    
    
    @IBOutlet  private var emailTextField: UITextField!
    
    @IBOutlet  private var passwordTextField: UITextField!
    
    @IBOutlet private var loginButton: UIButton!
    
    @IBOutlet private var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movingBackground()
        messageLabel.isHidden = true
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoader(false)
    }
        
    @IBAction func descriptionScreenButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ModalSegue", sender: nil)
        
    }
    private func  congigureButtton() {
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.keyboardType = .emailAddress
        
        loginButton.isEnabled = false
        
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.cornerRadius = 10
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 1.0
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
        handleLogin()
        
        
    }
    private func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { [ weak self ] result, error in
            if let error = error {
                self?.showErrorIfNeeded(error)
                return
            }
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
                                   self?.showMessage(withTitle: "エラー", message: "もう一度入力してください")
                                   print("\(error.localizedDescription)")
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
    
    
    
    @IBAction func loginGuestButton(_ sender: Any) {
        //消した時に保存さされないと警告を出す
        presentToOrnamentViewController()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func goSignupPage(_ sender: UIButton) {
       
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
            //loginButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 221)
        } else {
            loginButton.isEnabled = true
           // loginButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 150)
        }
    }
    
    
}
extension LoginViewController {
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
       
        let message =  AuthService.errorMessage(of: error)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

