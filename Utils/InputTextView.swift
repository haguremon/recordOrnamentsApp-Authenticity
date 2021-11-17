//
//  InputTextView.swift
//  InstagramClone
//
//  Created by IwasakI Yuta on 2021-10-17.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK: - プロパティ等
    var placeholderText: String? {
        didSet{ placeholderLabel.text = placeholderText }
    }
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label .textColor = .systemGray
        return label
    }()
    
    var placeholderShouldCenter =  true {
        didSet{
            if placeholderShouldCenter {
                placeholderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            } else {
                placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 7, paddingLeft: 8)
            }
        }
    }

    // MARK: - ライフサイクル
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 7, paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - メソッド
    
    @objc func handleTextDidChange() {
        //placeholderLabelを隠す
        placeholderLabel.isHidden = !text.isEmpty
    }
}
