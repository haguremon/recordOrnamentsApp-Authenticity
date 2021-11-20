//
//  CheckBoxButton.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/29.
//

import UIKit

final class CheckBox: UIButton {
    
    //MARK: - プロパティ等
    let checkedImage = UIImage(systemName: "checkmark.square.fill")
    let uncheckedImage = UIImage(systemName: "square")
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    //MARK: - ライフサイクル
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        isChecked = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
    
    //MARK: - 関数等
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
}
