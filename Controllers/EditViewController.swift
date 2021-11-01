//
//  EditViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/01.
//

import UIKit

class EditViewController: UIViewController {
    //
    //    // MARK: - Properties
    
    var user: User?
    var post: Post? {
        
        didSet {
            
            //guard let post = post else { return }
            configurepost(post: post)
            print("4")
 }
         
    }
    private func configurepost(post: Post?){

        guard let post = post else { return }
        
        if post.imagename == "" {
        imagenameTextView.placeholderLabel.isHidden = false
        }
        if post.caption == "" {
            
            captionTextView.placeholderLabel.isHidden = false
            
        }
        
        photoImageView.sd_setImage(with: URL(string: post.imageUrl), completed: nil)
        imagenameTextView.text = post.imagename
        captionTextView.text = post.caption
        checkButton.isChecked = post.isSetPassword
        imagenameCharacterCountLabel.text = "\(imagenameTextView.text.count)/15"
        captionCharacterCountLabel.text = "\(captionTextView.text.count)/300"
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
        button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
       // button.backgroundColor = .clear
        button.layer.shadowColor = UIColor.gray.cgColor
        //button.isChecked = false
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .clear
        return button
    }()
    
    @objc func setPassword() {
        
        if checkButton.isChecked {
        showMessage1(withTitle: "パスワード", message: "保管画面でログイン時のパスワードが要求されます")
        } else {
     
        
        }
    }
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("削除", for: .normal)
        button.addTarget(self, action: #selector(remove), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        
        return button
    }()
    @objc func remove() {
        
        PostService.deletePost(withPostId: post!.postId)
        
    }
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("編集完了", for: .normal)
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        button.backgroundColor = .blue
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        
        return button
    }()
    
    
    
    
    func showMessage1(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "パスワードつける", style: .default, handler: { [ weak self ] _ in
            
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
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を変更する"
        tv.textColor = .label
        tv.delegate = self
        tv.text = ""
        tv.keyboardType = .default
        tv.placeholderShouldCenter = true
        //tv.placeholderShouldCentral = true
        tv.returnKeyType = .next
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモを変更する"
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.textColor = .label
        tv.text = ""
        tv.delegate = self
        tv.keyboardType = .default
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .done
        return tv
    }()
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "パスワードを設定する"
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        return label
    }()
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "メモ"
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        return label
    }()
    
    private let captionCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/300"
        return label
    }()
    
    private let imagenameCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/15"
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(user: User, post: Post){
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
        //guard let post = post else { return }
        print(post.postId)
        imagenameTextView.placeholderLabel.isHidden = true
        captionTextView.placeholderLabel.isHidden = true
        imagenameTextView.becomeFirstResponder()
        DispatchQueue.main.async {
            self.configurepost(post: post)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("2")
        print("\(view.bounds.size.height)")
        configureUI()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
        
    }
    
    // MARK: - Actions
    @objc func didTapCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    private func upDatePost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        
        guard let imagename = imagenameTextView.text else { return }
        guard let caption = captionTextView.text else { return }
        let password = checkButton.isChecked
        guard let post = post else { return }
        //ここでインジケーターが発動する

        let updatePost = Submissions(caption: caption, imagename: imagename,isSetPassword: password)
        
        PostService.updatePost(ownerUid: post, updatepost: updatePost) { post in
            DispatchQueue.main.async {
                
                self.post = post
    
            }
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        
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
        navigationItem.title = "編集モード"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 12, width: view.bounds.width / 1.08)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        imagenameTextView.centerX(inView: view)
        
        view.addSubview(imagenameCharacterCountLabel)
        imagenameCharacterCountLabel.anchor(bottom: imagenameTextView.bottomAnchor, right: imagenameTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        view.addSubview(photoImageView)
        
        
        photoImageView.setDimensions(height: view.bounds.height / 3, width: view.bounds.width)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
       
        let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            verticalStackView.alignment = .fill
            verticalStackView.spacing = 5
            view.addSubview(verticalStackView)
       
        verticalStackView.anchor(top: photoImageView.bottomAnchor,
                                 paddingTop: 15)
        verticalStackView.centerX(inView: view)
        
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
        
        verticalStackView.addArrangedSubview(stack)
        verticalStackView.addArrangedSubview(memoLabel)

        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: verticalStackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 5, paddingRight: 5, height: 100)
        
        view.addSubview(captionCharacterCountLabel)
        captionCharacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        imagenameTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 26)
        
        let stack2 = UIStackView(arrangedSubviews: [deleteButton, editButton])
        //縦の関係
    
        stack2.axis = .horizontal

        stack2.spacing = 15
        //これでstack内でのサイズがcheckButton.bounds.size.widthと同じになるらしい
        deleteButton.bounds.size.width = deleteButton.intrinsicContentSize.width
        editButton.bounds.size.width = editButton.intrinsicContentSize.width
        //二つが左寄りに
        stack2.alignment = .fill
        view.addSubview(stack2)
   
        stack2.anchor(top: captionTextView.bottomAnchor,
                                 paddingTop: 7)
        stack2.centerX(inView: view)
        deleteButton.setDimensions(height: view.bounds.height / 12, width: view.bounds.width / 3.5)
        editButton.setDimensions(height: view.bounds.height / 12, width: view.bounds.width / 3.5)
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2
        editButton.layer.cornerRadius = deleteButton.bounds.width / 2

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}
extension EditViewController {
    
    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        if captionTextView.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -250)
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
extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case imagenameTextView:
            checkMaxLength(textView)
            let count = textView.text.count
            imagenameCharacterCountLabel.text = "\(count)/15"
        
        case captionTextView:
            checkMaxLength(textView)
            let count = textView.text.count
            captionCharacterCountLabel.text = "\(count)/300"
     
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