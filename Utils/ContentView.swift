//
//  ContentView.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/28.
//

import UIKit

class ContentView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    //自分自身はサワレナイ
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        if view == self {
            return nil
        }
        return view
    }
}
