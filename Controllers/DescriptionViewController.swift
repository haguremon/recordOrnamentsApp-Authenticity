//
//  DescriptionViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/08.
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
    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    
    private var timer: Timer!
    
    
    @IBOutlet weak var belowView: UIView!
    
    private var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        scrollViewsetup()
        setUpImageView()
        
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.scrollPage), userInfo: nil, repeats: true)
    }
    
    // タイマーを破棄
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let workingTimer = self.timer {
            workingTimer.invalidate()
        }
    }
    
    func scrollViewsetup(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: belowView.frame.size.width - 10, height: belowView.frame.size.height))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: belowView.frame.size.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
//        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//                scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//                scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//                scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//                scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
    scrollView.topAnchor.constraint(equalTo: belowView.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: belowView.bottomAnchor).isActive = true
    scrollView.leftAnchor.constraint(equalTo: belowView.leftAnchor).isActive = true
    scrollView.rightAnchor.constraint(equalTo: belowView.rightAnchor).isActive = true
    scrollView.widthAnchor.constraint(equalTo: belowView.widthAnchor, multiplier: 1).isActive = true
    scrollView.topAnchor.constraint(equalTo: pageControl.bottomAnchor,constant: -20).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor,constant: -50 ).isActive = true
    }
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: Photo) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(systemName:  image.imageName)
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode =  UIView.ContentMode.scaleToFill
        return imageView
    }
    func setUpImageView() {
        for i in 0 ..< self.photoList.count {
            let photoItem = self.photoList[i]
            print("\(i)")
            let imageView = createImageView(x: 0, y: 0, width: self.belowView.frame.size.width, height: self.belowView.frame.size.height, image: photoItem)
       imageView.frame = CGRect(origin: CGPoint(x: belowView.frame.size.width * CGFloat(i), y: 0), size: CGSize(width: self.belowView.frame.size.width, height: self.scrollView.frame.size.height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
            //scrollView.addSubview(belowView)
            self.belowView.addSubview(imageView)

        
//        for i in 0 ..< self.photoList.count {
//            let photoItem = self.photoList[i]
//            let imageView = createImageView(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height, image: photoItem)
//
////            imageView.frame = CGRect(origin: CGPoint(x: self.belowView.frame.size.width * CGFloat(i), y: 0), size: CGSize(width: self.belowView.frame.size.width, height: self.belowView.frame.size.height))
//
//            imageView.frame = CGRect(origin: CGPoint(x: self.belowView.frame.size.width * CGFloat(i) , y: 0), size: CGSize(width: self.belowView.frame.size.width, height: self.scrollView.frame.size.height))
//    //
//            self.scrollView.addSubview(imageView)
            imageView.centerXAnchor.constraint(equalTo: belowView.centerXAnchor,constant: belowView.frame.size.width + 10 * CGFloat(i)).isActive = true    // X座標軸の中心を親Viewと合わせる制約を有効にする
            
          imageView.centerYAnchor.constraint(equalTo: belowView.centerYAnchor).isActive = true
           // imageView.topAnchor.constraint(equalTo: pageControl.bottomAnchor,constant: -20).isActive = true
            imageView.topAnchor.constraint(equalTo: belowView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: belowView.bottomAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: CGFloat(i)).isActive = true
            imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,constant: CGFloat(i)).isActive = true
            
            imageView.widthAnchor.constraint(equalTo: belowView.widthAnchor, multiplier: CGFloat(i)).isActive = true
            
           // imageView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor,constant: -60 ).isActive = true
            
            //
            
            
            
            
        }
        
        
    }
    // offsetXの値を更新することページを移動
    @objc func scrollPage() {
        // 画面の幅分offsetXを移動
        self.offsetX += scrollView.frame.size.width
        // 3ページ目まで移動したら1ページ目まで戻る
        if self.offsetX < scrollView.frame.size.width * 3 {
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
    
    
    @IBAction func backToSreenButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}



extension DescriptionViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.y = offsetY
        // scrollViewのページ移動に合わせてpageControlの表示も移動
        self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        print("\(pageControl.currentPage)")
        // offsetXの値を更新
        self.offsetX = self.scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetY = scrollView.contentOffset.y
       }

}
