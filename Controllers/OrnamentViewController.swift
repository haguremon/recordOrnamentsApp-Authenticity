//
//  OrnamentViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/06.
//

import UIKit
import SideMenu
import FirebaseAuth

final class OrnamentViewController: UIViewController {
    
    // MARK: - プロパティ等
    var user: User?
    
    private var post: Post? { didSet { collectionView.reloadData() } }
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
            
            if inSearchMode == true {
                updateSearchResults(for: searchController)
            }
        }
        
    }
    
    private var filteredPosts = [Post]()
    
    @IBOutlet private var collectionView: UICollectionView!
    let collectionViewLayout = CollectionViewLayout()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar {
        searchController.searchBar
    }
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let coverView: UIView = {
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        let mainFrame = CGRect(x: 0, y: 0, width: mainBoundSize.width, height: mainBoundSize.height)
        let view = UIView()
        view.frame = mainFrame
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    private var menu: SideMenuNavigationController?
    
    //MARK: - ライフサイクル等
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        collectionView.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setStatusBarBackgroundColor(#colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1))
        configureSearchController()
        configureSideMenu()
        configureCollectionView()
        fetchPosts()
        fetchUser()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(habdleRefresh), for: .valueChanged)
        refresher.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0)
        refresher.tintColor = .black
        collectionView.refreshControl = refresher
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoader(false)
        checkIfUserEmailVerified()
    }
    
    //MARK: - API
    private func checkIfUserEmailVerified() {
        guard  Auth.auth().currentUser != nil else { return }
        Auth.auth().currentUser?.reload(completion: { error in
            guard error == nil else { return self.showErrorIfNeeded(error) }
            
            if Auth.auth().currentUser?.isEmailVerified == true {
                return
            } else if Auth.auth().currentUser?.isEmailVerified == false {
                let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [ weak self ] _ in
                    self?.openLoginViewController(message: "確認用メールを確認してください", email: self?.user?.email ??  "")
                }))
                
                self.present(alert, animated: true)
            }
            
        })
        
    }
    
    
    private func fetchUser() {
        UserService.fetchUser { result in
            
            switch result {
            case .success(let user):
                self.user = user
            case  .failure(_):
                self.showMessage(withTitle: "エラーが発生しました", message: "再ログインしてください", handler: nil)
            }
        }
        
    }
    
    
    private func fetchPosts() {
        guard post == nil else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        PostService.fetchPosts(forUser: uid) { result in
            
            switch result {
            case .success(let posts):
                self.posts = posts
                self.collectionView.refreshControl?.endRefreshing()
            case  .failure(_):
                self.showMessage(withTitle: "エラーが発生しました", message: "再ログインしてください", handler: nil)
            }

            
            
        }
        
    }
    
    //MARK: - メソッド等
    @objc func habdleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    
    private func configureSideMenu() {
        let sideMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as? SideMenuViewController
        
        sideMenuViewController?.delegate = self
        sideMenuViewController?.user = self.user
        menu = SideMenuNavigationController(rootViewController: sideMenuViewController!)
        menu?.leftSide = true
        menu?.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func openLoginViewController(message: String,email: String) {
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.message = message
        loginViewController.email = email
        present(loginViewController, animated: false)
    }
    
    
    @IBAction func OpenUploadPostControllerButton(_ sender: UIButton) {
        handleOpenUploadPostController()
    }
    
    
    @objc private func handleOpenUploadPostController() {
        let controller = UploadPostController()
        controller.delegate = self
        controller.currentUser = user
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleOpenSideMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    //MARK: - UI等
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .black
        searchBar.searchTextField.lupeImageView?.tintColor = .black
        searchBar.searchTextField.font = UIFont(name: "American Typewriter", size: 18)
        searchBar.placeholder = "登録した名前で検索できるよ"
        searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    
    private func configureNavigation() {
        navigationItem.title = "お　き　も　の"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.925465405, green: 0.9490913749, blue: 0.9807662368, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleOpenUploadPostController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.squares.leading"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(handleOpenSideMenu))
    }
    
    
}


//MARK: -UploadPostControllerDelegate
extension OrnamentViewController: UploadPostControllerDelegate{
    
    
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        controller.navigationController?.popViewController(animated: true)
        self.habdleRefresh()
    }
    
    
}


// MARK: - DetailsViewControllerDelegate
extension OrnamentViewController: DetailsViewControllerDelegate {
    
    
    func controllerDidFinishEditingPost(_ controller: UIViewController) {
        controller.navigationController?.popToRootViewController(animated: true)
        self.habdleRefresh()
    }
    
    
    func controllerDidFinishdeletePost(_ controller: DetailsViewController) {
        controller.navigationController?.popViewController(animated: true)
        self.habdleRefresh()
    }
    
    
}


//MARK: -UICollectionViewDelegate, UICollectionViewDataSource
extension OrnamentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func  configureCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayout.ornamentCollectionViewLayout(collectionView: collectionView)
        collectionView.register(OrnamentCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.layer.cornerRadius = 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch inSearchMode {
        case true:
            return filteredPosts.count
        case false:
            return  post == nil ? posts.count : 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OrnamentCollectionViewCell
        
        switch inSearchMode {
        case true:
            cell.setup(image: URL(string: filteredPosts[indexPath.row].imageUrl), imagename: filteredPosts[indexPath.row].imagename, setPassword: filteredPosts[indexPath.row].isSetPassword)
        case false:
            
            if let post = post {
                cell.setup(image: URL(string: post.imageUrl) , imagename: post.imagename,setPassword: post.isSetPassword)
            } else {
                cell.setup(image: URL(string: posts[indexPath.row].imageUrl), imagename: posts[indexPath.row].imagename, setPassword: posts[indexPath.row].isSetPassword)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = inSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
        guard let user = user else { return }
        
        if post.isSetPassword {
            showDialog(user: user, post: post)
        }
        
        openDetailsViewController(user: user, post: post)
        
    }
    
    private func showDialog(user: User, post: Post) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.title = "パスワード"
        alert.message = "パスワードを入力してください"
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            
            textField.textContentType = .emailAddress
            textField.isSecureTextEntry = true
            textField.placeholder = "パスワード"
        })
        
        alert.addAction(
            UIAlertAction(
                title: "入力完了",
                style: .default,
                handler: { [ weak self ] _ in
                    if alert.textFields?.first?.text == post.password {
                        self?.openDetailsViewController(user: user, post:post)
                    } else {
                        
                        self?.showMessage(withTitle: "パスワード", message: "パスワードが違います")
                    }
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "パスワードを忘れた場合",
                style: .default,
                handler: { [ weak self ] _ in
                    
                    self?.resetMessage(withuser: user, withpsot: post)
                    
                }))
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel
            )
        )
        self.present(
            alert,
            animated: true)
        
    }
    
    
    private func openDetailsViewController(user: User, post: Post) {
        let detailsViewController = DetailsViewController(user: user, post: post)
        detailsViewController.delegate = self
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    
    fileprivate func extractedFunc(_ indexPath: IndexPath, _ header1: HeaderCollectionReusableView) -> UICollectionReusableView {
        return header1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "header",
                                                                     for: indexPath) as! HeaderCollectionReusableView
        
        header.headerLabel.text = " 置き場所 "
        
        return extractedFunc(indexPath, header)
    }
    
    
}


//MARK: -SideMenuNavigationControllerDelegate
extension OrnamentViewController: SideMenuNavigationControllerDelegate {
    
    
    private func makeSettings() -> SideMenuSettings {
        var settings = SideMenuSettings()
        settings.menuWidth = view.bounds.width / 1.5
        settings.presentationStyle = .menuSlideIn
        settings.presentationStyle.onTopShadowOpacity = 1.0
        settings.statusBarEndAlpha = 0
        
        return settings
    }
    
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        navigationController?.view.addSubview(coverView)
    }
    
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        coverView.removeFromSuperview()
    }
    
    
}


//MARK: - SideMenuViewControllerDelegate
extension OrnamentViewController: SideMenuViewControllerDelegate {
    
    
    func didSelectMeunItem(name: SideMenuItem) {
        menu?.dismiss(animated: false, completion:nil)
        
        switch name {
        case .useGuide:
            DispatchQueue.main.async {
                let vc = DescriptionViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            
        case .account:
            DispatchQueue.main.async {
                let accoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
                accoutViewController.modalPresentationStyle = .fullScreen
                let  sideMenuViewController = self.menu?.viewControllers.first as! SideMenuViewController
                accoutViewController.delegate = sideMenuViewController as AccountViewControllerDelegate
                accoutViewController.user = sideMenuViewController.user
                let transition = CATransition()
                transition.duration = 0.2
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.navigationController?.pushViewController(accoutViewController, animated: false)
            }
            
        case .signOut:
            
            do {
                try Auth.auth().signOut()
                openLoginViewController(message: "ログアウトされました", email: "")
            } catch  {
                self.showErrorIfNeeded(error)
            }
            
        case .contact:
            if let url = URL(string: "https://itunes.apple.com/jp/app/id1094591345?mt=8&action=write-review") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}


// MARK: - UISearchResultsUpdating
extension OrnamentViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredPosts = posts.filter({$0.imagename.contains(searchText)})
        self.collectionView.reloadData()
    }
    
    
}


// MARK: - UISearchBarDelegate
extension OrnamentViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = false
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.isHidden = false
    }
    
    
}


extension OrnamentViewController {
    
    
    func resetMessage(withuser user: User,withpsot post: Post){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "パスワードをリセット"
        alert.message = "ログイン時のメールアドレスを入力してください"
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            
            textField.textContentType = .emailAddress
            textField.placeholder = "メールアドレス"
        })
        
        alert.addAction(
            UIAlertAction(
                title: "入力完了",
                style: .default,
                handler: { [ weak self ] _ in
                    if alert.textFields?.first?.text == user.email {
                        let resuetdate = ResetData(password: nil, isSetPassword: false)
                        PostService.resetPasswordPost(ownerUid: post, updatepost: resuetdate)
                        self?.showMessage(withTitle: "パスワード", message: "パスワードがリセットされたました",handler: { [ weak self ] _ in
                            
                                DispatchQueue.main.async {
                                    self?.fetchPosts()
                                }
                        })
                        
                    } else {
                        
                        self?.showMessage(withTitle: "メールアドレス", message: "メールアドレスが違います")
                    }
                    
                    
                })
        )
        
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel)
        )
        self.present(
            alert,
            animated: true)
        
    }
    
    
}
