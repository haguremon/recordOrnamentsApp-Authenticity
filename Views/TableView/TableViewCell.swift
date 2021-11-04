//
//  TableViewCell.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/03.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lable: UILabel!
    
    @IBOutlet weak var textField: UITextField!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        
        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 6)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        lable.textColor = .white
        textField.textColor = .green
        textField.isEnabled = false
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
