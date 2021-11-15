//
//  DetailsViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/06.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func controllerDidFinishdeletePost(_ controller: DetailsViewController)
    func controllerDidFinishEditingPost(_ controller: UIViewController)

}


class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    var user: User?
    
    var post: Post? { didSet { configurepost(post: post) } }
   
    weak var delegate: DetailsViewControllerDelegate?
    
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
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .systemGray
        iv.layer.masksToBounds = true
        iv.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        iv.layer.borderWidth = 1
        return iv
    }()
    private let shadowView: UIView = {
    
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        return view
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
        DispatchQueue.main.async {
            self.deleteButton.showAnimation(true)
        }
       
        let alert = UIAlertController(title: "削除", message: "データは復元されません", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "削除する", style: .default, handler: { [ weak self ] _ in
           
            DispatchQueue.main.async {
                self?.deletePost()
            }
            self?.delegate?.controllerDidFinishdeletePost(self!)
        
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    private func deletePost() {
        
        PostService.deletePost(self, withPostId: post!.postId)
        
    }
    
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("編集", for: .normal)
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        button.backgroundColor = .blue
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        
        return button
    }()
    

    func showEditModeMessage() {
        let alert = UIAlertController(title: "編集", message: "編集画面に変更しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [ weak self ] _ in
           
                self?.editingMode()
        
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    private lazy var imagenameTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "名前"
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.text = ""
        tv.isEditable = false
        tv.isSelectable = false
        tv.placeholderShouldCenter = true
        tv.layer.masksToBounds = false
        
        tv.layer.borderWidth = 1
        tv.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        tv.layer.shadowColor = UIColor.black.cgColor
        tv.layer.shadowOpacity = 0.8
        tv.layer.shadowRadius = 8.0
        tv.layer.shadowOffset = .zero
        
        return tv
    }()
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "メモ"
        tv.layer.borderWidth = 1
        tv.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.textColor = .black
        tv.text = ""
        tv.backgroundColor = .white
        tv.isEditable = false
        tv.isSelectable = false
        tv.placeholderShouldCenter = false
 
        return tv
    }()
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "パスワード"
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "メモ"
        label.backgroundColor = .clear
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
    
    // MARK: - Lifecycle
    
    init(user: User, post: Post){
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
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
        
        configureNavigation()
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
        DispatchQueue.main.async {
            self.editButton.showAnimation(true)
        }
        
        showEditModeMessage()
        
       
    }
   
    
    
    @objc func editingMode() {
       
        let editViewController = EditViewController(user: self.user!, post: self.post!)
        editViewController.delegate = self
        navigationController?.pushViewController(editViewController, animated: true)
    
    }
    private func configureNavigation() {
        
        navigationItem.title = "詳細"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editingMode))
        navigationItem.rightBarButtonItem?.tintColor = .blue
        
        
    }
       
    
    
    // MARK: - Helpers
    func configureUI(){
        
        setStatusBarBackgroundColor(#colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  
       
        view.addSubview(imagenameTextView)
        imagenameTextView.setDimensions(height: view.bounds.height / 13, width: view.bounds.width / 1.08)
        imagenameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2)
        imagenameTextView.centerX(inView: view)
        
        view.addSubview(imagenameCharacterCountLabel)
        imagenameCharacterCountLabel.anchor(bottom: imagenameTextView.bottomAnchor, right: imagenameTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
       // view.addSubview(photoImageView)
        view.addSubview(shadowView)
        shadowView.setDimensions(height: view.bounds.width / 1.5, width: view.bounds.width / 1.08)
        shadowView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 2)
        shadowView.centerX(inView: view)
        shadowView.addSubview(photoImageView)
        photoImageView.setDimensions(height: view.bounds.width / 1.5, width: view.bounds.width / 1.08)
        photoImageView.anchor(top: imagenameTextView.bottomAnchor, paddingTop: 2)
        photoImageView.centerX(inView: view)
        
       
        photoImageView.layer.cornerRadius = 10
       
        let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            verticalStackView.alignment = .fill
            verticalStackView.spacing = 1
            view.addSubview(verticalStackView)
       
        verticalStackView.anchor(top: photoImageView.bottomAnchor,
                                 paddingTop: 2)
        verticalStackView.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [passwordLabel, checkButton])
        //縦の関係
    
        stack.axis = .horizontal

        stack.spacing = 2

        checkButton.bounds.size.width = checkButton.intrinsicContentSize.width
        passwordLabel.bounds.size.width = passwordLabel.intrinsicContentSize.width

        stack.alignment = .fill
        
        verticalStackView.addArrangedSubview(stack)
        verticalStackView.addArrangedSubview(memoLabel)

        view.addSubview(captionTextView)
        captionTextView.setDimensions(height: view.bounds.height / 6, width: view.bounds.width / 1.08)
        captionTextView.anchor(top: verticalStackView.bottomAnchor, paddingTop: 2)
        captionTextView.centerX(inView: view)
       
        view.addSubview(captionCharacterCountLabel)
        captionCharacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
                
        let stack2 = UIStackView(arrangedSubviews: [editButton, deleteButton])
        //縦の関係
    
        stack2.axis = .horizontal

        stack2.spacing = 30
        //これでstack内でのサイズがcheckButton.bounds.size.widthと同じになるらしい
        deleteButton.bounds.size.width = deleteButton.intrinsicContentSize.width
        editButton.bounds.size.width = editButton.intrinsicContentSize.width
        //二つが左寄りに
        stack2.alignment = .fill
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
        
       
    
    }
}
//MARK: - EditViewControllerDelegate

extension DetailsViewController: EditViewControllerDelegate {
    
    func controllerDidFinishUploadingPost(_ controller: EditViewController) {
        
        self.delegate?.controllerDidFinishEditingPost(controller)
    
    }
    
}
