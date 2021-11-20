//
//  EditViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/01.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: EditViewController)
}

final class EditViewController: UIViewController {
    
    // MARK: - プロパティ等
    var user: User?
    
    var post: Post? { didSet { configurepost(post: post) } }
    
    weak var delegate: EditViewControllerDelegate?
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray
        iv.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        iv.layer.borderWidth = 1
        return iv
    }()
    
    private lazy var checkButton: CheckBox = {
        let button = CheckBox()
        button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("削除", for: .normal)
        button.addTarget(self, action: #selector(removePost), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        return button
    }()
    
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
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を変更する"
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.delegate = self
        tv.text = ""
        tv.keyboardType = .default
        tv.placeholderShouldCenter = true
        tv.returnKeyType = .done
        return tv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモを変更する"
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.text = ""
        tv.delegate = self
        tv.keyboardType = .default
        tv.placeholderShouldCenter = false
        tv.returnKeyType = .done
        return tv
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "パスワードを設定する"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "メモ"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let captionCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/300"
        return label
    }()
    
    private let imagenameCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/15"
        return label
    }()
    
    private let password: UILabel = {
        let label = UILabel()
        label.isEnabled = true
        return label
    }()
    
    // MARK: - ライフサイクル
    init(user: User, post: Post){
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
        print(post.postId)
        imagenameTextView.placeholderLabel.isHidden = true
        captionTextView.placeholderLabel.isHidden = true
        DispatchQueue.main.async {
            self.configurepost(post: post)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(#colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1))
        configureNavigation()
        configureUI()
        imagenameTextView.delegate = self
        captionTextView.delegate = self
        
    }
    
    // MARK: - メソッド等
    private func configurepost(post: Post?) {
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
    
    
    @objc func setPassword() {
        
        if checkButton.isChecked {
            editViewshowMessage(withTitle: "パスワード", message: "保存した写真に非表示になり、置き場所でパスワードが要求されます")
        }
        
    }
    
    
    @objc func removePost() {
        
        DispatchQueue.main.async {
            self.deleteButton.showSuccessAnimation(true)
        }
        let alert = UIAlertController(title: "削除", message: "データは復元されません", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "削除する", style: .default, handler: { [ weak self ] _ in
            
            DispatchQueue.main.async {
                self?.deletePost()
            }
            
            self?.delegate?.controllerDidFinishUploadingPost(self!)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    private func deletePost() {
        PostService.deletePost(withPostId: post!.postId)
    }
    
    
    @objc func didTapCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func upDatePost() {
        imagenameTextView.resignFirstResponder()
        captionTextView.resignFirstResponder()
        
        self.showLoader(true)
        editButton.showSuccessAnimation(true)
        
        let imagename = imagenameTextView.text
        let caption = captionTextView.text
        let setPassword = checkButton.isChecked
        let password = password.text
        
        guard let post = post else {
            self.showLoader(false)
            self.showMessage(withTitle: "エラー", message: "編集できません", handler: nil)
            return
        }
        
        let updatePost = Submissions(caption: caption, imagename: imagename,password: password,isSetPassword: setPassword)
        PostService.updatePost(ownerUid: post, updatepost: updatePost) { post in
            DispatchQueue.main.async {
                self.post = post
            }
            
            self.showLoader(false)
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    
    
    @objc func didTapDone() {
        upDatePost()
    }
    
    // MARK: - UI等
    func configureUI(){
        view.backgroundColor = .white
        
        imagenameTextView.layer.borderWidth = 1
        imagenameTextView.layer.borderColor = UIColor.gray.cgColor
        captionTextView.layer.borderWidth = 1
        captionTextView.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 12, width: view.bounds.width / 1.08)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2)
        imagenameTextView.centerX(inView: view)
        
        view.addSubview(imagenameCharacterCountLabel)
        imagenameCharacterCountLabel.anchor(bottom: imagenameTextView.bottomAnchor, right: imagenameTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: view.bounds.height / 3, width: view.bounds.width / 1.05)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 2)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 1
        view.addSubview(verticalStackView)
        
        verticalStackView.anchor(top: photoImageView.bottomAnchor,
                                 paddingTop: 0)
        verticalStackView.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [passwordLabel, checkButton])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .fill
        
        checkButton.bounds.size.width = checkButton.intrinsicContentSize.width
        passwordLabel.bounds.size.width = passwordLabel.intrinsicContentSize.width
        
        verticalStackView.addArrangedSubview(stack)
        verticalStackView.addArrangedSubview(memoLabel)
        
        view.addSubview(captionTextView)
        captionTextView.setDimensions(height: view.bounds.height / 6, width: view.bounds.width / 1.08)
        captionTextView.anchor(top: verticalStackView.bottomAnchor, paddingTop: 2)
        captionTextView.centerX(inView: view)
        
        view.addSubview(captionCharacterCountLabel)
        captionCharacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        let stack2 = UIStackView(arrangedSubviews: [editButton, deleteButton])
        stack2.axis = .horizontal
        stack2.spacing = 30
        stack2.alignment = .fill
        
        deleteButton.bounds.size.width = deleteButton.intrinsicContentSize.width
        editButton.bounds.size.width = editButton.intrinsicContentSize.width
        
        view.addSubview(stack2)
        stack2.anchor(top: captionTextView.bottomAnchor,
                      paddingTop: 7)
        stack2.centerX(inView: view)
        
        deleteButton.setDimensions(height: view.bounds.height / 15, width: view.bounds.width / 3)
        editButton.setDimensions(height: view.bounds.height / 15, width: view.bounds.width / 3)
        deleteButton.layer.cornerRadius = view.bounds.width / 18
        editButton.layer.cornerRadius = view.bounds.width / 18
        
        imagenameTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 26)
        imagenameTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 26)
        captionTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        captionTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 40)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func configureNavigation() {
        navigationItem.title = "編集"
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    }
    
    
}


//MARK: - キーボード周り
extension EditViewController {
    
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        
        if captionTextView.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -144)
                self.view.transform = transform
            })
        }
        
    }
    
    
    @objc func hidekeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    
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


//MARK: - ダイアログ周り
extension EditViewController {
    
    
    func editViewshowMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "パスワードつける", style: .default, handler: { [ weak self ] _ in
            DispatchQueue.main.async {
                self?.message(withTitle: "パスワード", message: "パスワードを入力してください")
            }
            
            self?.checkButton.isChecked = true
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { [ weak self ] _ in
            DispatchQueue.main.async {
                self?.checkButton.isChecked = false
            }
        }))
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
    }
    
    
    func message(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            
            textField.textContentType = .newPassword
            textField.isSecureTextEntry = true
            textField.placeholder = "パスワード"
            
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
        
        DispatchQueue.main.async {
            self.present(
                alert,
                animated: true)
        }
    }
    
    
}


// MARK: - UITextViewDelegate
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

