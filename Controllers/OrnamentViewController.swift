//
//  OrnamentViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/06.
//

import UIKit
import SideMenu
import FirebaseAuth

class OrnamentViewController: UIViewController {
    
    var user: User?
    
    private var posts = [Post]() {
        didSet{
            collectionView.reloadData()
            if inSearchMode == true {
                updateSearchResults(for: searchController)
            }
        }
    }
    private var filteredPosts = [Post]()
    
    var post: Post?{
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet private var collectionView: UICollectionView!
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
    var menu: SideMenuNavigationController?
    
    let collectionViewLayout = CollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureNavigationBar()
        navigationController?.navigationBar.isTranslucent = true
        collectionView.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1)
        
        
        setStatusBarBackgroundColor(#colorLiteral(red: 0.790112555, green: 0.79740417, blue: 0.8156889081, alpha: 1))
        
       
        
        configureSearchController()
        setupSideMenu()
        setupCollectionView()
        fetchPosts()
        fetchUser()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(habdleRefresh), for: .valueChanged)
        refresher.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0)
        refresher.tintColor = .label
        collectionView.refreshControl = refresher
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader(true)
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoader(false)
//        if Auth.auth().currentUser != nil {
//            Auth.auth().currentUser?.reload(completion: { error in
//                if error == nil {
//                    if Auth.auth().currentUser?.isEmailVerified == true {
//
//                    } else if Auth.auth().currentUser?.isEmailVerified == false {
//                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [ weak self ] _ in
//                            let loginViewController = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
//                            loginViewController.modalPresentationStyle = .fullScreen
//                            loginViewController.message = "確認用メールを確認してください"
//                            loginViewController.email = self?.user?.email
//                            self?.present(loginViewController, animated: false, completion: nil)
//                        }))
//                        self.present(alert, animated: true)
//                    }
//                }
//            })
//        }
    }

 
    private func setupSideMenu() {
        let sideMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as? SideMenuViewController
        sideMenuViewController?.delegate = self
        sideMenuViewController?.user = self.user
        menu = SideMenuNavigationController(rootViewController: sideMenuViewController!)
        menu?.leftSide = true
        menu?.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
      
    }
    
    
    func checkIfUserIsLoggedIn() {
        // configurenavigationController()
        print("check1")
        if Auth.auth().currentUser == nil  {
            //ログイン中じゃない場合はLoginControllerに移動する
            
            
            DispatchQueue.main.async {
                self.presentToViewController()
            }
            
        }
        
    }
    private func fetchUser(){
        //コールバックを使ってProfileControllerのプロパティに代入する
        UserService.fetchUser { user in
            self.user = user
            
        }
        
    }
    private func fetchPosts() {
        guard post == nil else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        PostService.fetchPosts(self, forUser: uid) { (posts) in
            self.posts = posts
            //self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    

    //loginSegue
    private func presentToViewController() {
        
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: false, completion: nil)
        
    }
    
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.tintColor = .black
        searchBar.searchTextField.lupeImageView?.tintColor = .black

        
        searchBar.searchTextField.font = UIFont(name: "American Typewriter", size: 18)
        searchBar.placeholder = "登録した名前で検索できるよ"
        searchBar.delegate = self
        
//        searchController.searchBar.placeholder = "登録した名前で検索できるよ"
//        searchController.searchBar.tintColor = .black
//        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.7712653279, green: 0.76668185, blue: 0.7747893929, alpha: 0.520540149)
//        searchController.searchBar.layer.borderColor = UIColor.systemBlue.cgColor
       // searchController.searchBar.searchTextField.backgroundColor = .white
        //searchController.searchBar.delegate = self
        //hidesSearchBarWhenScrolling
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "お　き　も　の"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        //let image = UIImage(systemName: "plus.app")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapPostToButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.squares.leading"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(createSideMenuButton))
    }
    
    @objc private func didTapPostToButton() {
        
        let controller = UploadPostController()
        controller.delegate = self
        controller.currentUser = user
        navigationController?.pushViewController(controller, animated: true)
    
    }
    
    @objc func createSideMenuButton(_ sender: Any) {
        
        present(menu!, animated: true, completion: nil)
        
    }
    
    @IBAction func barItemReturn(segue: UIStoryboardSegue){
        
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





//MARK: -CollectionView
extension OrnamentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
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
        guard let user = user else {
            return
        }
        
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
                   //textField.delegate = self
                   textField.textContentType = .emailAddress
                   textField.isSecureTextEntry = true
                   textField.placeholder = "パスワード"
               })
               //追加ボタン
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
        // TODO: -パスワードを忘れた場合どうするか考える
        alert.addAction(
                    UIAlertAction(
                    title: "パスワードを忘れた場合",
                    style: .default,
                    handler: { [ weak self ] _ in
               
                        self?.resetMessage(withuser: user, withpsot: post)
          
                }))
            //キャンセルボタン
               alert.addAction(
               UIAlertAction(
                   title: "キャンセル",
                   style: .cancel
               )
               )
               //アラートが表示されるごとにprint
               self.present(
               alert,
               animated: true,
               completion: {
                   print("アラートが表示された")
               })
        
    }
    
    
    
    
   
    private func openDetailsViewController(user: User, post: Post){
        
        let detailsViewController = DetailsViewController(user: user, post: post)
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
      
    }
    
    //viewForSupplementaryをつけることができるヘッダーやフッターなので
    
    fileprivate func extractedFunc(_ indexPath: IndexPath, _ header1: HeaderCollectionReusableView) -> UICollectionReusableView {
    
            return header1
        }
                                   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "header",
                                                                     for: indexPath) as! HeaderCollectionReusableView
       
        header.headerLabel.text = " 保管場所 "
        
        return extractedFunc(indexPath, header)
    }
    
    @objc func habdleRefresh(){
        posts.removeAll()
    
        fetchPosts()
        
        }
                                   
    }
                                   
        //MARK: -SideMeun

extension OrnamentViewController: SideMenuNavigationControllerDelegate {
    
    private func makeSettings() -> SideMenuSettings {
        var settings = SideMenuSettings()
        settings.menuWidth = view.bounds.width / 1.5
        //動作を指定
        settings.presentationStyle = .menuSlideIn
        //メニューの陰影度
        settings.presentationStyle.onTopShadowOpacity = 1.0
        //ステータスバーの透明度
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
        //サイドメニューが閉じた時に移動する
        
        switch name {
            
        case .useGuide:
            DispatchQueue.main.async {
                let vc = DescriptionViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
           
            }
            
        case .account:
            DispatchQueue.main.async {
                let accoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
                accoutViewController.modalPresentationStyle = .fullScreen
                accoutViewController.delegate = self
                let  sideMenuViewController = self.menu?.viewControllers.first as! SideMenuViewController
                accoutViewController.delegate = sideMenuViewController as? AccountViewControllerDelegate
                accoutViewController.user = sideMenuViewController.user
                let transition = CATransition()
                   transition.duration = 0.2
                   transition.type = CATransitionType.push
                   transition.subtype = CATransitionSubtype.fromLeft
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.navigationController?.pushViewController(accoutViewController, animated: false)
            }
           
        case .signOut:
            print("log out")
            do {
                
                try Auth.auth().signOut()
                
                presentToViewController()
                
                
            } catch  {
                self.showErrorIfNeeded(error)
            }
            
        case .contact:
            view.backgroundColor = .green
        }
    }
    
}
//MARK: - AccountViewControllerDelegate

extension OrnamentViewController: AccountViewControllerDelegate {

    func controllerDidFinishUpDateUser(){
        //fetchUser()
    }
    
    func didSelectMeunItem(_ viewController: AccountViewController, name: AccountMenu) {
        
       print("tapedd")
        switch name {
        case .name:
            print("name")

        case .password:
            resetPasswordMessege(viewController)
            
        case .deleteAccount:
            Auth.auth().currentUser?.delete {  (error) in
                      // エラーが無ければ、ログイン画面へ戻る
                      if error == nil {
                          self.presentToViewController()
                      }else{
                          
                          self.showErrorIfNeeded(error)
                      }
                  }
            print("deleteAccount")
        case .exit:
            viewController.didTappedismiss()
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

extension OrnamentViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = false
        //tableView.isHidden = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.isHidden = false
       // tableView.isHidden = true
    }
}
extension OrnamentViewController {

func resetMessage(withuser user: User,withpsot post: Post){
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    alert.title = "パスワードをリセット"
    alert.message = "パスワードをリセットしますか？"
        
           alert.addTextField(configurationHandler: {(textField) -> Void in
               //textField.delegate = self
               textField.textContentType = .newPassword
               textField.placeholder = "パスワード"
           })
           //追加ボタン
           alert.addAction(
               UIAlertAction(
                   title: "入力完了",
                   style: .default,
                   handler: { [ weak self ] _ in
                       if alert.textFields?.first?.text == user.email {
                           let resuetdate = ResetData(password: nil, isSetPassword: false)
                           PostService.resetPasswordPost(self!, ownerUid: post, updatepost: resuetdate) { _ in
                
                           }
                           self?.showMessage(withTitle: "パスワード", message: "パスワードがリセットされたました",handler: { [ weak self ] _ in
                           
                               self?.dismiss(animated: true, completion: {
                                   DispatchQueue.main.async {
                                       self?.fetchPosts()
                                   }
                                  
                               })
                           })
                           
                       } else {
                           
                           self?.showMessage(withTitle: "パスワード", message: "パスワードが違います")
                       }
    
                
                   })
           )
    
        //キャンセルボタン
           alert.addAction(
           UIAlertAction(
               title: "キャンセル",
               style: .cancel)
        )
           //アラートが表示されるごとにprint
           self.present(
           alert,
           animated: true)
    
}
    
    func resetPasswordMessege(_ accountViewController: AccountViewController) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
           alert.view.setNeedsLayout()
           alert.title = "パスワードリセット"
           alert.message = "ログイン時のメールアドレスを入力してください"

           alert.addTextField(configurationHandler: {(textField) -> Void in

               textField.textContentType = .emailAddress
               textField.placeholder = "メールアドレス"
           })
           //追加ボタン
           alert.addAction(
               UIAlertAction(
                   title: "入力完了",
                   style: .default,
                   handler: { [ weak self ] _ in
                       guard let email =  alert.textFields?.first?.text else {
                           self?.showMessage(withTitle: "エラー", message: "適切なメールアドレスが入力されていません")
                          
                           return
                           
                       }
                       AuthService.resetPassword(withEmail: email) { error in
                           
                           if let error = error {
                               self?.showErrorIfNeeded(error)
                               return
                           }
                           
                           DispatchQueue.main.async {
                               accountViewController.messageLabel.isHidden = false
                               accountViewController.messageLabel.text = "リセット用のメールを送りました!"
                               
                               
                           }
                           
                           
                       }
                           
                       
                   })
           )
    
        //キャンセルボタン
           alert.addAction(
           UIAlertAction(
               title: "キャンセル",
               style: .cancel
           )
           )
           //アラートが表示されるごとにprint
           self.present(
           alert,
           animated: true,
           completion: {
               print("アラートが表示された")
           })
    

    }


}
