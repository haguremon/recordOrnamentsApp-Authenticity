//
//  DetailsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/06.
//

import UIKit

class DetailsViewController: UIViewController {
    //
    //    // MARK: - Properties
    
    var user: User?
    var post: Post? {
        
        didSet {
            
            guard let post = post else { return }
            print(post.imagename)
            //configurepost(post: post)
            
 }
         
    }
    private func configurepost(post: Post?){
        
        imagenameTextView.placeholderLabel.isHidden = true
        captionTextView.placeholderLabel.isHidden = true

        guard let post = post else { return }

        
        photoImageView.sd_setImage(with: URL(string: post.imageUrl), completed: nil)
        imagenameTextView.text = post.imagename
        captionTextView.text = post.caption
        
    }
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
    
    private lazy var checkButton: CheckBox = {
        let button = CheckBox()
        //button.setTitle("写真を追加する", for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
       // button.backgroundColor = .clear
        button.layer.shadowColor = UIColor.gray.cgColor
        button.isChecked = false
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        return button
    }()
    
    
    @objc func addPhoto() {
        
        if checkButton.isChecked {
        showMessage1(withTitle: "パスワード", message: "保管画面でログイン時のパスワードが要求されます")
        } else {
     
        
        }
       
 
        
    }
    func showMessage1(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "パスワードつける", style: .default, handler: { [ weak self ] _ in
            self?.checkButton.isChecked = true
            self?.post?.isSetPassword = true
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { [ weak self ] _ in
            self?.checkButton.isChecked = false
            self?.post?.isSetPassword = false
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を変更する"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        tv.delegate = self
        tv.placeholderShouldCenter = true
        //tv.placeholderShouldCentral = true
        tv.returnKeyType = .next
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモを変更する"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        //tv.delegate = self
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .done
        return tv
    }()
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "パスワードを設定する？"
        label.backgroundColor = .red
        label.textAlignment = .center
        return label
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("1")
        showLoader(false)
    }
    
    init(user: User, post: Post){
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
    
        guard let post = post else { return }
        
        DispatchQueue.main.async {
            self.configurepost(post: post)
        }
          showLoader(true)
    }
    
    // MARK: - Actions
    @objc func didTapCancel(){
        self.navigationController?.popViewController(animated: true)

    }
    private func upDatePost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        
        guard let imagename = imagenameTextView.text else { return }
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = user else { return }
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
            self.dismiss(animated: true, completion: nil)
            //     self.dismiss(animated: true, completion: nil)
            //            self.tabBarController?.selectedIndex = 0
            //delegateに値が入ってるのでcontrollerDidFinishUploadingPost()を使うことができる
            //rightBarButtonItemが押された時にcontrollerDidFinishUploadingPostが発動する
            // self.seni()
        }
    }
    @objc func didTapDone() {
       
        upDatePost()
    }
    //
    //    // MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .systemBackground
        imagenameTextView.layer.borderWidth = 1
        imagenameTextView.layer.borderColor = UIColor.gray.cgColor
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.gray.cgColor
        navigationItem.title = "詳細"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "変更する", style: .done, target: nil, action: #selector(didTapDone))
        
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 12, width: view.bounds.width / 1.25)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        imagenameTextView.centerX(inView: view)
        
        view.addSubview(characterCountLabel2)
        characterCountLabel2.anchor(bottom: imagenameTextView.bottomAnchor, right: imagenameTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        view.addSubview(photoImageView)
        
        
        photoImageView.setDimensions(height: view.bounds.height / 3, width: view.bounds.width)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        //checkButton.setDimensions(height: 50, width: 13)
        let stack = UIStackView(arrangedSubviews: [passwordLabel, checkButton])
        //縦の関係
    
        stack.axis = .horizontal
        //stack.distribution = .equalSpacing
        stack.spacing = 0
        //これでstack内でのサイズがcheckButton.bounds.size.widthと同じになるらしい
        checkButton.bounds.size.width = checkButton.intrinsicContentSize.width
        passwordLabel.bounds.size.width = passwordLabel.intrinsicContentSize.width
        //二つが左寄りに
        stack.alignment = .fill
        stack.backgroundColor = .gray
        view.addSubview(stack)
        //stack.setDimensions(height: 55, width: 250)
       
        stack.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 60, paddingRight: 60)
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 100)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}
extension DetailsViewController {
    
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
extension DetailsViewController: UITextViewDelegate {
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
            upDatePost()
            
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
