//
//  CollectionViewCell.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    private let imagename: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
       // label.attributedText = NSAttributedString(
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.sizeToFit()
        return label
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(imageView)
    imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0,paddingRight: 0)
        
    imageView.setDimensions(height: self.bounds.height / 1.25, width: self.bounds.width)
    addSubview(imagename)
        imagename.anchor(top: imageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 1,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0)
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        
        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 7)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5

    
    }
    func setup(image: URL?, imagename: String?){
        imageView.sd_setImage(with: image, completed: nil)
        self.imagename.text = imagename
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
