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

final class UploadPostController: UIViewController {
   
   // MARK: - プロパティ等
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
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を付ける"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.text = ""
        tv.delegate = self
        tv.placeholderShouldCenter = false
        tv.keyboardType = .default
        tv.returnKeyType = .done
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
        tv.keyboardType = .default
        tv.returnKeyType = .done
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/300"
        return label
    }()
    
    private let characterCountLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/15"
        return label
    }()
    
    private lazy var checkButton: CheckBox = {
        let button = CheckBox()
        button.addTarget(self, action: #selector(habdleSetPassword), for: .touchUpInside)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.isChecked = false
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .clear
        return button
    }()
    
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("保存する", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.showSuccessAnimation(true)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        return button
    }()
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
        setStatusBarBackgroundColor(#colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1))
    }
    
    // MARK: - メソッド等
    @objc func addPhoto() {
        addPhotoButton.showSuccessAnimation(true)
        showMessage1(withTitle: "写真", message: "写真を追加しますか？")
    }
    
    
    @objc func habdleSetPassword() {
        
        if checkButton.isChecked {
        showMessage2(withTitle: "パスワード", message: "保存した写真は非表示になり、置き場所でパスワードが要求されます")
        }
        
    }
    
    
    @objc func didTapCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func uploadPost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        
        let imagename = imagenameTextView.text ?? ""
        guard let image = selectedImage else { return showMessage(withTitle: "写真", message: "写真がありません") }
        let caption = captionTextView.text ?? ""
        guard let user = currentUser else { return showMessage(withTitle: "エラー", message: "エラーが発生しました", handler: nil) }
        let password = password.text
        let setPassword = checkButton.isChecked
        
        showLoader(true)
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        PostService.uploadPost(caption: caption, image: image, imagename: imagename, setpassword: setPassword, password: password, user: user) { (error) in
            self.showLoader(false)
    
            
            if let error = error {
                self.showLoader(false)
                self.showMessage(withTitle: "エラー", message: "\(error.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.saveButton.isEnabled = true
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    
   
    @objc func didTapDone() {
        saveButton.showSuccessAnimation(true)
        uploadPost()
    }
   
    // MARK: - UI等
    func configureUI(){
        view.backgroundColor = .white
        imagenameTextView.layer.borderWidth = 1
        imagenameTextView.layer.borderColor = UIColor.gray.cgColor
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 14, width: view.bounds.width / 1.08)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2)
        imagenameTextView.centerX(inView: view)
        
        view.addSubview(characterCountLabel2)
        characterCountLabel2.anchor(bottom: imagenameTextView.bottomAnchor, right: imagenameTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: view.bounds.height / 3, width: view.bounds.width / 1.15)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 5)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
      
        view.addSubview(addPhotoButton)
        addPhotoButton.setDimensions(height: view.bounds.height / 19.5, width: view.bounds.width / 2.5 )
        addPhotoButton.anchor(top: photoImageView.bottomAnchor,
                                 paddingTop: 1)
        addPhotoButton.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [passwordLabel, checkButton])
            stack.axis = .horizontal
            stack.spacing = 5
            stack.alignment = .fill
        
        view.addSubview(stack)
        stack.setWidth(view.bounds.width / 2)
        stack.anchor(top: addPhotoButton.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor,
                     paddingTop: 5,paddingRight: view.bounds.width / 4.7)
        
        view.addSubview(captionTextView)
        captionTextView.setDimensions(height: view.bounds.height / 5.5, width: view.bounds.width / 1.08)
        captionTextView.anchor(top: stack.bottomAnchor, paddingTop: 2)
        captionTextView.centerX(inView: view)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        view.addSubview(saveButton)
        saveButton.setDimensions(height: view.bounds.height / 19.5, width: view.bounds.width / 2.5 )
        saveButton.anchor(top: captionTextView.bottomAnchor,
                                 paddingTop:10)
        saveButton.centerX(inView: view)
        
        imagenameTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 27)
        imagenameTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 27)
        captionTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        captionTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    private func configureNavigation() {
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1)
        navigationItem.title = "保管"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem?.tintColor = .blue
    }
    
    
}

//MARK: - Dialog等
extension UploadPostController {
    
    
    func showMessage1(withTitle title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "カメラで撮影", style: .default, handler: { [ weak self ] _ in
            self?.setCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "写真を選択", style: .default, handler: { [ weak self ] _ in
            self?.setAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    
    func message(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.setNeedsFocusUpdate()
               alert.addTextField(configurationHandler: {(textField) -> Void in
    
                   textField.textContentType = .emailAddress
                   textField.isSecureTextEntry = true
               })
              
               alert.addAction(
                   UIAlertAction(
                       title: "入力完了",
                       style: .default,
                       handler: { _ in
                           guard let textFieldText = alert.textFields?.first?.text else { return }
                           self.password.text = textFieldText
                        
                       })
               )
        
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
               self.present(
               alert,
               animated: true)
        
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
        
        present(alert, animated: true)
    }
    
    
}


//MARK: - キーボード周り
extension UploadPostController {
    

    @objc func keyboardWillShow(notification: NSNotification) {
        
        if captionTextView.isFirstResponder {
            
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


// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    
    
    
    func checkMaxLength(_ textView: UITextView) {
        
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
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        switch textView {
        case imagenameTextView:
            imagenameTextView.resignFirstResponder()
        case captionTextView:
         
            captionTextView.resignFirstResponder()
        default:
            break
            
        }
        
    
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let textViewLines = existingLines + newLines
    
        switch textView {
        case imagenameTextView:
            if text == "\n" {
                imagenameTextView.resignFirstResponder()
                
                return false
            }
        case captionTextView:
            if newLines.count == 2 && existingLines.last == "" && textViewLines.last == "" {
                captionTextView.resignFirstResponder()
                
                return false
            }
        default:
            break
            
        }
        
        return true
    }
    
    
}


//MARK: -UIImagePickerControllerDelegate - カメラ周り
extension UploadPostController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    private func setCamera() {
        let camera = UIImagePickerController.SourceType.camera
        let picker = UIImagePickerController()
       
        if UIImagePickerController.isSourceTypeAvailable(camera) {
           picker.sourceType = camera
           picker.delegate = self
           picker.allowsEditing = true
           
            self.showPermissionMessage()
          
            present(picker, animated: true)
       }
    
        
    }
    
   
    private func setAlbum() {
         let picker = UIImagePickerController()
             picker.delegate = self
             picker.allowsEditing = true

             present(picker, animated: true)
         }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(selectedImage,self,nil,nil)
        }
        
        self.selectedImage = selectedImage
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.borderColor = UIColor.gray.cgColor
        photoImageView.layer.borderWidth = 2
        photoImageView.image = self.selectedImage
        addPhotoButton.setTitle("写真を変更する", for: .normal)
        self.dismiss(animated: true)
    }
   
   
}

