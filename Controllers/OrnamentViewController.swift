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
        
        print("hello")
        navigationController?.navigationBar.isTranslucent = true
        collectionView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        setStatusBarBackgroundColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        
        configureSearchController()
     
        setupSideMenu()
        setupCollectionView()
        fetchPosts()
   
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(habdleRefresh), for: .valueChanged)
        refresher.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        refresher.tintColor = .blue
        collectionView.refreshControl = refresher

    }
    private func setupSideMenu() {
        let sideMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as? SideMenuViewController
        sideMenuViewController?.delegate = self
        //sideMenuViewController?.user = self.user
        menu = SideMenuNavigationController(rootViewController: sideMenuViewController!)
        
        menu?.leftSide = true
        menu?.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
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
//                            self?.presentToViewController()
//                        }))
//                        self.present(alert, animated: true)
//                    }
//                }
//            })
//        }
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
        PostService.fetchPosts(forUser: uid) { (posts) in
            self.posts = posts
            //self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader(true)
        fetchUser()
        fetchPosts()
        
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
        searchController.searchBar.placeholder = "登録した名前で検索できるよ"
        searchController.searchBar.tintColor = .label
        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        searchController.searchBar.layer.borderColor = UIColor.systemBlue.cgColor
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "ア　プ　リ　名"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapPostToButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.left"),
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





//MARK: -CollectionView
extension OrnamentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayout.ornamentCollectionViewLayout()

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowOffset = CGSize(width: 7, height: 5)
        collectionView.layer.shadowColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        collectionView.layer.shadowRadius = 2
        collectionView.layer.shadowOpacity = 0.5
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
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
        return extractedFunc(indexPath, header)
    }
    
    @objc func habdleRefresh(){
        posts.removeAll()
        //ここでもう一回postsに入れる
        fetchPosts()
        
        }
                                   
    }
                                   
                                   
        //MARK: -SideMeun

extension OrnamentViewController: SideMenuNavigationControllerDelegate {
    
    private func makeSettings() -> SideMenuSettings {
        var settings = SideMenuSettings()
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
                accoutViewController.user = self.user
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
    func didSelectMeunItem(_ viewController: AccountViewController, name: AccountMenu) {
        
       
        switch name {
        case .name:
            print("name")
    //MARK: - 11/6日やるやつ
        case .password:
            resetPasswordMessege()
        
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





// extension OrnamentViewController : UITextFieldDelegate {
// }


// MARK: - UISearchResultsUpdating
extension OrnamentViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        //1文字でも含まれてたら検索できる
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

           })
           //追加ボタン
           alert.addAction(
               UIAlertAction(
                   title: "入力完了",
                   style: .default,
                   handler: { [ weak self ] _ in
                       if alert.textFields?.first?.text == user.email {
                           let resuetdate = ResetData(password: nil, isSetPassword: false)
                           PostService.resetPasswordPost(ownerUid: post, updatepost: resuetdate) { _ in
                
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
    func resetPasswordMessege() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
           alert.title = "パスワードリセット"
           alert.message = "ログイン時のメールアドレスを入力してください"

           alert.addTextField(configurationHandler: {(textField) -> Void in

               textField.textContentType = .emailAddress

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
                           
                           do {
                               
                               try Auth.auth().signOut()
                               
                               self?.presentToViewController()
                               DispatchQueue.main.async {
                                   let loginViewController = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                                   loginViewController.modalPresentationStyle = .fullScreen
                                self?.present(loginViewController, animated: false, completion: nil)
                                
                               }
                               
                           } catch  {
                               self?.showErrorIfNeeded(error)
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
