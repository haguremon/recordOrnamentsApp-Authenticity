//
//  ViewController.swift
//  autoScroll
//
//  Created by IwasakIYuta on 2021/09/27.
//

import UIKit

class DescriptionViewController: UIViewController {
    
     struct Photo {
         var imageName: String
     }
     //"gear","magnifyingglass","clock"
     var photoList = [
         Photo(imageName: "gear"),
         Photo(imageName: "magnifyingglass"),
         Photo(imageName: "clock")
     ]
     
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        // メニュー単位のスクロールを可能にする
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
   
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
         pageControl.numberOfPages = 3
         // pageControlのドットの色
         pageControl.pageIndicatorTintColor = UIColor.lightGray
         // pageControlの現在のページのドットの色
         pageControl.backgroundColor = .green
         pageControl.currentPageIndicatorTintColor = UIColor.black
        return pageControl
    }()
    private lazy var button: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .orange
        button.titleLabel?.text = "戻る"
        button.setTitle("戻る", for: UIControl.State.normal)
        button.tintColor = .white
        //button.target(forAction: #selector(test), withSender: nil)
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        return button
    }()
    @objc func test() {
        
        dismiss(animated: true, completion: nil)
    }
     private var offsetX: CGFloat = 0
     private var timer: Timer!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
      let frameGuide = scrollView.frameLayoutGuide
  
         // scrollViewのデリゲートになる
         scrollView.delegate = self
         scrollView.backgroundColor = .green
         
         view.addSubview(scrollView)
        
         view.addSubview(pageControl)
        
        frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        frameGuide.topAnchor.constraint(equalTo:  pageControl.bottomAnchor, constant: -5).isActive = true
        frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        frameGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -150).isActive = true

         setUpImageView()

         pageControl.anchor1(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0),size: .init(width: view.frame.size.width, height: 20))
         pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         view.addSubview(button)
         
         button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         button.anchor1(top: scrollView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left:0 , bottom: 0, right: 0),size: .init(width: 200, height: 50))

         // タイマーを作成
         self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.scrollPage), userInfo: nil, repeats: true)
     }
     
     // タイマーを破棄
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         if let workingTimer = self.timer {
             workingTimer.invalidate()
         }
     }
    override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height / 2)

    }

     // UIImageViewを生成
     func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: Photo) -> UIImageView {
         let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
         let image = UIImage(systemName:  image.imageName)
         imageView.image = image
         return imageView
     }
     
     // photoListの要素分UIImageViewをscrollViewに並べる
     func setUpImageView() {
         for i in 0 ..< self.photoList.count {
             let photoItem = self.photoList[i]
             let imageView = createImageView(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height , image: photoItem)
             imageView.frame = CGRect(origin: CGPoint(x: self.scrollView.frame.size.width * 3, y: 0), size: CGSize(width: self.scrollView.frame.size.width - 100, height: view.frame.size.height / 2 - 50))
             
             imageView.translatesAutoresizingMaskIntoConstraints = false
             imageView.backgroundColor = .gray
             
             scrollView.addSubview(imageView)
             imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor,constant: view.frame.size.width * CGFloat(i)).isActive = true
             imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
             imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant:  -20).isActive = true
             imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor,constant: -20).isActive = true

         }
     }

    
    
    
    
    
    
    

//     // offsetXの値を更新することページを移動
     @objc func scrollPage() {
         // 画面の幅分offsetXを移動
         self.offsetX += self.view.frame.size.width
         // 3ページ目まで移動したら1ページ目まで戻る
         if self.offsetX < self.view.frame.size.width * 3 {
             UIView.animate(withDuration: 0.3) {
                 self.scrollView.contentOffset.x = self.offsetX
             }
         } else {
             UIView.animate(withDuration: 0.3) {
                 self.offsetX = 0
                 self.scrollView.contentOffset.x = self.offsetX
             }
         }
     }
 }

 extension DescriptionViewController: UIScrollViewDelegate {
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         // scrollViewのページ移動に合わせてpageControlの表示も移動
         self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
         // offsetXの値を更新
         self.offsetX = self.scrollView.contentOffset.x
     }


}

