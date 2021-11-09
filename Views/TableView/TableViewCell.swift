//
//  TableViewCell.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//

import UIKit
protocol TableViewCellDelegat: AnyObject {
    //コメントviewに行くにはFeedControllerのFeedCellのcommentButtonを押さないといけない
    func cell(_ cell: TableViewCell)
    func textFieldShouldReturnCell(_ cell: TableViewCell) -> Bool
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lable: UILabel!
    
    @IBOutlet weak var textField: UITextField!
   
    weak var delegat: TableViewCellDelegat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        
        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 6)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        lable.textColor = .white
        textField.textColor = .black
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
  
    
}
extension TableViewCell: UITextFieldDelegate {

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
