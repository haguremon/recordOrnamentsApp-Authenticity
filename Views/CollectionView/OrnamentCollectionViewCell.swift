//
//  CollectionViewCell.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/26.
//

import UIKit

final class OrnamentCollectionViewCell: UICollectionViewCell {
    
   //MARK: - プロパティ等
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 13.0
        iv.layer.borderWidth = 1
        iv.layer.borderColor = #colorLiteral(red: 0.3305901885, green: 0.4503111243, blue: 0.7627663016, alpha: 1)
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.8
        iv.layer.shadowRadius = 8.0
        iv.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.contentMode = .scaleAspectFill
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 13.0
        blurEffectView.layer.borderWidth = 1
        blurEffectView.layer.borderColor = #colorLiteral(red: 0.3305901885, green: 0.4503111243, blue: 0.7627663016, alpha: 1)
        blurEffectView.layer.shadowColor = UIColor.black.cgColor
        blurEffectView.layer.shadowOpacity = 0.8
        blurEffectView.layer.shadowRadius = 8.0
        blurEffectView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        blurEffectView.alpha = 0.9
        return blurEffectView
    }()
    
    
    private let imagename: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.layer.cornerRadius = 5.0
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        label.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 13.5)
        label.sizeToFit()
        return label
    }()
      
    //MARK: - ライフサイクル
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0,paddingRight: 0)
        imageView.setDimensions(height: self.bounds.height / 1.25, width: self.bounds.width)
        
        contentView.addSubview(blurEffectView)
        blurEffectView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0,paddingRight: 0)
        blurEffectView.setDimensions(height: self.bounds.height / 1.25, width: self.bounds.width)
        
        contentView.addSubview(imagename)
        imagename.anchor(top: imageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 1,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0)
        clipsToBounds = true
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - メソッド等
    private func setup() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 7)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
      }
    

    func setup(image: URL?, imagename: String?,setPassword: Bool){
        imageView.sd_setImage(with: image, completed: nil)
        self.imagename.text = imagename
        self.blurEffectView.isHidden = !setPassword
    }
    
    
}
