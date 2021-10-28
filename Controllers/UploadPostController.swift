//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-13.
//

import UIKit
import PhotosUI

//ここで委任する
protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}
//画面を選択したらここに移動して　メモ等をfirebaseに保存する
class UploadPostController: UIViewController {
    //
    //    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    var currentUser: User?
    //
    //
    var selectedImage: UIImage? {
        didSet{ photoImageView.image = selectedImage }
    }
    //
    //
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
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
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        return button
    }()
    
    
    @objc func addPhoto() {
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        //configuration.selection = .default
        
       // configuration.preferredAssetRepresentationMode = .automatic
        
        configuration.filter = .any(of: [.images, .livePhotos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        //navigationController?.pushViewController(picker, animated: true)
        present(picker, animated: true)
        
    }
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を付ける"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        //tv.delegate = self
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .next
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモをする"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        //tv.delegate = self
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
    
    
    //    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
        
    }
    
    // MARK: - Actions
    @objc func didTapCancel(){
        self.delegate?.controllerDidFinishUploadingPost(self)
    }
    private func uploadPost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        guard let imagename = imagenameTextView.text else { return }
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        //ここでインジケーターが発動する
        showLoader(true)
        navigationItem.leftBarButtonItem?.isEnabled = false
        //
        PostService.uploadPost(caption: caption, image: image, imagename: imagename, user: user) { (error) in
            //uploadできたらインジケーターが終わる
            self.showLoader(false)
           
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
            if let error = error {
                print("DEBUG: Failed to upload post \(error.localizedDescription)")
                return
            }
            print("成功やで")
            //ポストが成功した時の処理 tabバーもホームに移動したいのでプロトコルを使って委任する
            self.delegate?.controllerDidFinishUploadingPost(self)
            //     self.dismiss(animated: true, completion: nil)
            //            self.tabBarController?.selectedIndex = 0
            //delegateに値が入ってるのでcontrollerDidFinishUploadingPost()を使うことができる
            //rightBarButtonItemが押された時にcontrollerDidFinishUploadingPostが発動する
            // self.seni()
        }
    }
    @objc func didTapDone() {
       
        uploadPost()
    }
    //
    //    // MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .systemBackground
        imagenameTextView.layer.borderWidth = 1
        imagenameTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        navigationItem.title = "保管"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapDone))
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 11, width: view.bounds.width)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        imagenameTextView.centerX(inView: view)
        view.addSubview(characterCountLabel2)
        characterCountLabel2.anchor(bottom: imagenameTextView.bottomAnchor, right: view.rightAnchor,paddingBottom: 0, paddingRight: 14)
        view.addSubview(photoImageView)
        
        
        photoImageView.setDimensions(height: view.bounds.height / 3, width: view.bounds.width)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(addPhotoButton)
        //addPhotoButton.setDimensions(height: 55, width: 100)
        addPhotoButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 80, paddingRight: 80, height: 55)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 100)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,paddingBottom: 0, paddingRight: 14)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}
extension UploadPostController {
    
    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        if captionTextView.isFirstResponder {
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
    //
    
    
    
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


extension UploadPostController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = results.first?.itemProvider else { return }
        selectedImage.canLoadObject(ofClass: UIImage.self)
        selectedImage.loadObject(ofClass: UIImage.self) { image, error in
            
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    
                    self.selectedImage = image
                    
                    
                }
                
                
            }
        }
        
        
        
        
    }
    
    
    
}
