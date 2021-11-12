//
//  AccountCollectionViewCell.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/12.
//AccountCollectionViewCell


import UIKit
protocol AccountCollectionViewCellDelegat: AnyObject {
    //コメントviewに行くにはFeedControllerのFeedCellのcommentButtonを押さないといけない
    func cell(_ cell: AccountCollectionViewCell)
    func textFieldShouldReturnCell(_ cell: AccountCollectionViewCell) -> Bool
}

class AccountCollectionViewCell: UICollectionViewCell {
    
    weak var delegat: AccountCollectionViewCellDelegat?
    
    let textField: UITextField = {
       let tf = UITextField()
        tf.textColor = .black
        tf.textAlignment = .center
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.placeholder = "名前"
        tf.backgroundColor = .white
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isHidden = true
       return tf
   }()
    
    
     let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 13.5)
        label.isHidden = true
        label.sizeToFit()
        return label
    }()
     let accountMenuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.isHidden = false
        label.sizeToFit()
        return label
    }()
        
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 1,
                         paddingLeft: 5,
                         paddingRight: 5)
        nameLabel.setHeight(self.bounds.height / 3)
        
        contentView.addSubview(textField)
        textField.anchor(top: nameLabel.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 1,
                         paddingLeft: 7,
                         paddingBottom: 1,
                         paddingRight: 7)
        
     
        contentView.addSubview(accountMenuLabel)
        
        accountMenuLabel.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 5,
                         paddingLeft: 5,
                         paddingBottom: 5,
                         paddingRight: 5)
        //accountMenuLabel.center(inView: self)
        
        
        //addSubview(imagename)
        textField.delegate = self
        clipsToBounds = true
        setup()
   
    }
    private func setup() {
        self.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 3, height: 7)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension AccountCollectionViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        if  delegat?.textFieldShouldReturnCell(self) == true {
            textField.resignFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
        
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegat?.cell(self)
    }
}

