//
//  File.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/01.
//


import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
     
    //MARK: - プロパティ等
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
         label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.font = UIFont(name: "Arial-BoldMT", size: 30)
        label.sizeToFit()
        return label
    }()
    
    //MARK: - ライフサイクル
    override init(frame: CGRect) {
        super.init(frame: frame)
    addSubview(headerLabel)
    headerLabel.setDimensions(height: self.bounds.height, width: self.bounds.width / 1.08)
        self.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
}
