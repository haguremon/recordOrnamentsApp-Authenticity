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

final class DetailsViewController: UIViewController {
    
    // MARK: - プロパティ等
    weak var delegate: DetailsViewControllerDelegate?
    
    var user: User?
    
    var post: Post? { didSet { configurepost(post: post) } }
    
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
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        return view
    }()
    
    private lazy var checkButton: CheckBox = {
        let button = CheckBox()
        button.addTarget(self, action: #selector(handleCheckButtonTapped), for: .touchUpInside)
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
        button.backgroundColor = .systemRed
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.8
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("編集", for: .normal)
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.8
        return button
    }()
    
    private lazy var imagenameTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.backgroundColor = .white
        tf.text = ""
        tf.isEnabled = false
        tf.isSelected = false
        tf.textAlignment = .center
        tf.layer.masksToBounds = false
        tf.layer.borderWidth = 1
        tf.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOpacity = 0.3
        tf.layer.shadowRadius = 8.0
        tf.layer.shadowOffset = .zero
        return tf
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
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "作成日:"
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private let creationDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private let editDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        label.text = "変更日:"
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private let editDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    
    private let captionCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
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
    
    // MARK: - ライフサイクル
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
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
    
    // MARK: - メソッド等
    private func configurepost(post: Post?) {
        guard let post = post else { return }
        
        if post.caption == "" {
            captionTextView.placeholderLabel.isHidden = false
        }
        
        if let editDate = post.editDate {
            self.editDate.text =  dateFormatterForcreatedAt(date: editDate.dateValue())
            editDateLabel.isHidden = false
        }
        creationDate.text = dateFormatterForcreatedAt(date: post.creationDate.dateValue())
        
        photoImageView.sd_setImage(with: URL(string: post.imageUrl), completed: nil)
        imagenameTextField.text = post.imagename
        captionTextView.text = post.caption
        checkButton.isChecked = post.isSetPassword
        captionCharacterCountLabel.text = "\(captionTextView.text.count)/300"
        
    }
    
    
    @objc func handleCheckButtonTapped() {
        DispatchQueue.main.async {
            self.showEditModeMessage()
            self.checkButton.isChecked = self.post!.isSetPassword
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
            self?.delegate?.controllerDidFinishdeletePost(self!)
            
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    private func deletePost() {
        PostService.deletePost(withPostId: post!.postId)
    }
    
    
    private func showEditModeMessage() {
        let alert = UIAlertController(title: "編集", message: "編集画面に変更しますか？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [ weak self ] _ in
            self?.editingMode()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    @objc func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func didTapDone() {
        
        editButton.showSuccessAnimation(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.18) {
            self.editingMode()
        }
        
    }
    
    
    @objc func editingMode() {
            let editViewController = EditViewController(user: self.user!, post: self.post!)
            editViewController.delegate = self
            
            self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    
    private func configureNavigation() {
        navigationItem.title = "詳細"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editingMode))
        navigationItem.rightBarButtonItem?.tintColor = .blue
    }
    
    
    private func dateFormatterForcreatedAt(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd. MMM yyyy HH:mm:ss", options: 0, locale: .autoupdatingCurrent)//"yyyy年M月d日(EEEEE) HH時mm分"
        
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - UI等
    private func configureUI(){
        setStatusBarBackgroundColor(#colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(imagenameTextField)
        imagenameTextField.setDimensions(height: view.bounds.height / 15, width: view.bounds.width / 1.08)
        imagenameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2)
        imagenameTextField.centerX(inView: view)
        
        view.addSubview(shadowView)
        shadowView.setDimensions(height: view.bounds.height / 3.7, width: view.bounds.width / 1.08)
        shadowView.anchor(top: imagenameTextField.bottomAnchor, paddingTop: 2)
        shadowView.centerX(inView: view)
        
        shadowView.addSubview(photoImageView)
        photoImageView.setDimensions(height: view.bounds.height / 2.85, width: view.bounds.width / 1.08)
        photoImageView.anchor(top: imagenameTextField.bottomAnchor, paddingTop: 2)
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
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .fill
        
        checkButton.bounds.size.width = checkButton.intrinsicContentSize.width
        passwordLabel.bounds.size.width = passwordLabel.intrinsicContentSize.width
        
        verticalStackView.addArrangedSubview(stack)
        verticalStackView.addArrangedSubview(memoLabel)
        
        view.addSubview(captionTextView)
        captionTextView.setDimensions(height: view.bounds.height / 6.8, width: view.bounds.width / 1.08)
        captionTextView.anchor(top: verticalStackView.bottomAnchor, paddingTop: 2)
        captionTextView.centerX(inView: view)
        
        view.addSubview(captionCharacterCountLabel)
        captionCharacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: captionTextView.rightAnchor,paddingBottom: 0, paddingRight: 5)
        
        let buttonStack = UIStackView(arrangedSubviews: [editButton, deleteButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 30
        buttonStack.alignment = .fill
        
        deleteButton.bounds.size.width = deleteButton.intrinsicContentSize.width
        editButton.bounds.size.width = editButton.intrinsicContentSize.width
        
        view.addSubview(buttonStack)
        
        buttonStack.anchor(top: captionTextView.bottomAnchor,
                           paddingTop: 7)
        buttonStack.centerX(inView: view)
        
        deleteButton.setDimensions(height: view.bounds.height / 15, width: view.bounds.width / 3)
        editButton.setDimensions(height: view.bounds.height / 15, width: view.bounds.width / 3)
        deleteButton.layer.cornerRadius = view.bounds.width / 18
        editButton.layer.cornerRadius = view.bounds.width / 18
        
        let verticalStackView2 = UIStackView()
        verticalStackView2.axis = .vertical
        verticalStackView2.alignment = .fill
        verticalStackView2.spacing = 2
        
        view.addSubview(verticalStackView2)
        verticalStackView2.anchor(top: buttonStack.bottomAnchor,
                                  paddingTop: 10)
        verticalStackView2.centerX(inView: view)
        
        
        let creationDatestack = UIStackView(arrangedSubviews: [creationDateLabel, creationDate])
        creationDatestack.axis = .horizontal
        creationDatestack.spacing = 4
        creationDatestack.alignment = .fill
        
        creationDateLabel.bounds.size.width = creationDateLabel.intrinsicContentSize.width
        creationDate.bounds.size.width = creationDate.intrinsicContentSize.width
        
        let editDatestack = UIStackView(arrangedSubviews: [editDateLabel, editDate])
        editDatestack.axis = .horizontal
        editDatestack.spacing = 4
        editDatestack.alignment = .fill
        
        editDateLabel.bounds.size.width = editDateLabel.intrinsicContentSize.width
        editDate.bounds.size.width = editDate.intrinsicContentSize.width
        
        verticalStackView2.addArrangedSubview(creationDatestack)
        verticalStackView2.addArrangedSubview(editDatestack)
        
        
        
        imagenameTextField.font = UIFont.systemFont(ofSize: view.bounds.size.height / 28)
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.boldSystemFont(ofSize: view.bounds.size.height / 28),
            .foregroundColor : UIColor.lightGray
        ]
        imagenameTextField.attributedPlaceholder = NSAttributedString(string: "名 前", attributes: attributes)
        
        captionTextView.font = UIFont.systemFont(ofSize: view.bounds.size.height / 42)
        captionTextView.placeholderLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 42)
        captionCharacterCountLabel.font = UIFont.systemFont(ofSize: view.bounds.size.height / 43)
        
        passwordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 41)
        memoLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 41)
        
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 35)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 35)
        
        
        creationDateLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 39.5)
        creationDate.font = UIFont.systemFont(ofSize: view.bounds.size.height / 39.5)
        
        editDateLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.size.height / 40)
        editDate.font = UIFont.systemFont(ofSize: view.bounds.size.height / 39.8)
        
        
    }
    
    
}


//MARK: - EditViewControllerDelegate
extension DetailsViewController: EditViewControllerDelegate {
    
    
    func controllerDidFinishUploadingPost(_ controller: EditViewController) {
        self.delegate?.controllerDidFinishEditingPost(controller)
    }
    
    
}
