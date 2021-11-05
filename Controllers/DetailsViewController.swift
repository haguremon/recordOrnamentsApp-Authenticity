//
//  DetailsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/06.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    var user: User?
    
    var post: Post? { didSet { configurepost(post: post) } }
   
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
        button.addTarget(self, action: #selector(setPassword), for: .touchUpInside)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.bounds.size.width = 15
        button.bounds.size.height = 30
        button.backgroundColor = .clear
        return button
    }()
    
    @objc func setPassword() {
        
        DispatchQueue.main.async {
            self.showEditModeMessage()
            self.checkButton.isChecked = self.post!.isSetPassword
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
        let alert = UIAlertController(title: "削除", message: "データは復元されません", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "削除する", style: .default, handler: { [ weak self ] _ in
           
            DispatchQueue.main.async {
                self?.deletePost()
            }
            self?.didTapClose()
        
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: false, completion: nil)
        
        
    }
    
    private func deletePost() {
        
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
    

    func showEditModeMessage() {
        let alert = UIAlertController(title: "編集", message: "編集モードに変更しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "編集モードにする", style: .default, handler: { [ weak self ] _ in
           
                self?.editingMode()
        
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: false, completion: nil)
    }
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前を変更する"
        tv.textColor = .label
        tv.text = ""
        tv.isEditable = false
        tv.isSelectable = false
        tv.placeholderShouldCenter = true
        tv.returnKeyType = .next
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモを変更する"
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.textColor = .label
        tv.text = ""
        tv.isEditable = false
        tv.isSelectable = false
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
    
    // MARK: - Lifecycle
    
    init(user: User, post: Post){
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
        //guard let post = post else { return }
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
   
        configureUI()
          showLoader(true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showLoader(false)
    }
    
    
    // MARK: - Actions
    
    
    @objc func didTapClose(){
        navigationController?.popViewController(animated: true)

    }
    
    
    @objc func didTapDone() {

        showEditModeMessage()
        
       
    }
   
    
    
    @objc func editingMode() {
       
        let editViewController = EditViewController(user: self.user!, post: self.post!)
        
        navigationController?.pushViewController(editViewController, animated: false)
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editingMode))
        
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

        
    }
}
