//
//  CheckBoxButton.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/29.
//

import Foundation

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(systemName: "checkmark.square.fill")
    let uncheckedImage = UIImage(systemName: "square")
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
        
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
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
    

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
