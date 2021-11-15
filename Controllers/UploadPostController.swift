//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
   
    //    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    var currentUser: User?

    var selectedImage: UIImage? {
        didSet{ photoImageView.image = selectedImage }
    }
 
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("写真を追加する", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.bounds.size.width = 15
        button.bounds.size.height = 55
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        return button
    }()
    
    
    @objc func addPhoto() {
        
        addPhotoButton.showAnimation(true)
        showMessage1(withTitle: "写真", message: "写真を追加しますか？")
 
        
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
    
    
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を付ける"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.text = ""
        tv.delegate = self
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .next
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモをする"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.text = ""
        tv.delegate = self
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .done
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/300"
        return label
    }()
    
    private let characterCountLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/15"
        return label
    }()
    private lazy var checkButton: CheckBox = {
        let button = CheckBox()
        button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.isChecked = false
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .clear
        return button
    }()
    
    @objc func setPassword() {
        
        if checkButton.isChecked {
        
        showMessage2(withTitle: "パスワード", message: "保存した写真に非表示になり、保管場所でパスワードが要求されます")
        } else {
            
            print(checkButton.isChecked)
        
        }

    }
    
    func showMessage2(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "パスワードつける", style: .default, handler: { [ weak self ] _ in
         
            self?.message(withTitle: "パスワード", message: "パスワードを入力してください")
            
            DispatchQueue.main.async {
                self?.checkButton.isChecked = true
            }
            
          
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { [ weak self ] _ in
            DispatchQueue.main.async {
                self?.checkButton.isChecked = false
            }
     
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "パスワードを設定する"
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    private let password: UILabel = {
        let label = UILabel()
        label.isEnabled = true
        return label
    }()
    
    
    //    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
        setStatusBarBackgroundColor(#colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1))
    }
    
    // MARK: - Actions
    @objc func didTapCancel(){
        self.delegate?.controllerDidFinishUploadingPost(self)
    }
    private func uploadPost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        
        guard let imagename = imagenameTextView.text else { return }
        guard let image = selectedImage else { return showMessage(withTitle: "写真", message: "写真がありません") }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        let password = password.text
        let setPassword = checkButton.isChecked
      
        showLoader(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        PostService.uploadPost(caption: caption, image: image, imagename: imagename, setpassword: setPassword, password: password, user: user) { (error) in
         
            self.showLoader(false)
            self.networkCheck()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
            if let error = error {
                self.showErrorIfNeeded(error)
                return
            }
            print("成功やで")
            self.delegate?.controllerDidFinishUploadingPost(self)

        }
    }
    @objc func didTapDone() {
       
        uploadPost()
    }
   
    //    // MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .white
        imagenameTextView.layer.borderWidth = 1
        imagenameTextView.layer.borderColor = UIColor.gray.cgColor
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 13, width: view.bounds.width / 1.08)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2)
        imagenameTextView.centerX(inView: view)
        view.addSubview(characterCountLabel2)
        characterCountLabel2.anchor(bottom: imagenameTextView.bottomAnchor, right: view.rightAnchor,paddingBottom: 0, paddingRight: 14)
        view.addSubview(photoImageView)
        
        photoImageView.setDimensions(height: view.bounds.width / 1.5, width: view.bounds.width / 1.08)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 5)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        
        let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            verticalStackView.alignment = .fill
            verticalStackView.spacing = 10
            view.addSubview(verticalStackView)
       
        verticalStackView.anchor(top: photoImageView.bottomAnchor,
                                 paddingTop: 0)
        verticalStackView.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [passwordLabel, checkButton])
        //縦の関係
        stack.axis = .horizontal
        stack.spacing = 1
        checkButton.bounds.size.width = checkButton.intrinsicContentSize.width
        passwordLabel.bounds.size.width = passwordLabel.intrinsicContentSize.width
        //二つが左寄りに
        stack.alignment = .fill
        
        verticalStackView.addArrangedSubview(addPhotoButton)
        verticalStackView.addArrangedSubview(stack)
        
        view.addSubview(captionTextView)

        captionTextView.setDimensions(height: view.bounds.height / 5.5, width: view.bounds.width / 1.08)
        captionTextView.anchor(top: verticalStackView.bottomAnchor, paddingTop: 2)
        captionTextView.centerX(inView: view)
        
        
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
       
        
        
        imagenameTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 26)
        imagenameTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 26)
        captionTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        captionTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    private func configureNavigation() {
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1)
        navigationItem.title = "保管"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem?.tintColor = .blue
        
    }
}


extension UploadPostController {
    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        if captionTextView.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -185)
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
    
    
    func checkMaxLength(_ textView: UITextView){
        
        switch textView {
        case imagenameTextView:
            if (textView.text.count) > 15 {
                textView.deleteBackward()
            }
        case captionTextView:

            if (textView.text.count) > 300 {
    
                textView.deleteBackward()
            }
            
        default:
            break
            
        }
    
    }
    
}


// MARK: - UITextFieldDelegate
//textViewの文字のカウントを認知することができる
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case imagenameTextView:
            checkMaxLength(textView)
            let count = textView.text.count
            characterCountLabel2.text = "\(count)/15"
        
        case captionTextView:
            checkMaxLength(textView)
            let count = textView.text.count
            characterCountLabel.text = "\(count)/300"
     
        default:
            break
            
        }
        
     
    }
    //UITextFieldDelegateを使ってユーザーの入力を認知する
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == imagenameTextView {
            //nameEmailTextFieldでリターンが押された時にpasswordTextFieldのキーボードを開く
            imagenameTextView.resignFirstResponder()
            captionTextView.becomeFirstResponder()
            
        } else if textField ==  captionTextView {
            //textFieldが押されたらログインボタンが起動する
            uploadPost()
            
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            imagenameTextView.resignFirstResponder() //キーボードを閉じる
            captionTextView.resignFirstResponder()
            
            return false
        }
        return true
    }
}

extension UploadPostController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
       
        self.selectedImage = selectedImage
        
        //self.selectedImage?.size = CGSize(width: <#T##Int#>, height: <#T##Int#>)
        //self.selectedImage.co
        //photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.borderColor = UIColor.gray.cgColor
        photoImageView.layer.borderWidth = 2
        photoImageView.image = self.selectedImage
        self.dismiss(animated: true, completion: nil)

    }

    
}
extension UploadPostController {
    
    func message(withTitle title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.setNeedsFocusUpdate()
               alert.addTextField(configurationHandler: {(textField) -> Void in
                   //textField.delegate = self
                   textField.textContentType = .emailAddress
                   textField.isSecureTextEntry = true
               })
               //追加ボタン
               alert.addAction(
                   UIAlertAction(
                       title: "入力完了",
                       style: .default,
                       handler: { _ in
                           guard let textFieldText = alert.textFields?.first?.text else { return }
                           self.password.text = textFieldText
                        
                       })
               )
        
            //キャンセルボタン
               alert.addAction(
               UIAlertAction(
                   title: "キャンセル",
                   style: .cancel,
                   handler: { [ weak self ] _ in
                       DispatchQueue.main.async {
                           self?.checkButton.isChecked = false
                       }
                   })
            )
               //アラートが表示されるごとにprint
               self.present(
               alert,
               animated: true)
        
    }
    
    
    
    
}
