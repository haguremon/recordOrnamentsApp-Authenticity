//
//  CustomInfoLabel.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/12/24.
//

import UIKit


final class CustomInfoLabel: UILabel {
    
    
    init(frame: CGRect, labelColor: UIColor,labelbackgroundColor: UIColor?, labelText: String?,labeltextAlignment: NSTextAlignment) {
        super.init(frame: frame)
        
        textColor = labelColor
        backgroundColor = labelbackgroundColor
        text = labelText
        adjustsFontSizeToFitWidth = true
        textAlignment = labeltextAlignment
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
