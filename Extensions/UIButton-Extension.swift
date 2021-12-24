//
//  UIButton-Extension.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/12/24.
//

import UIKit

extension UIButton {
    
    
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.05
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    
    func errorAnimation (duration: CFTimeInterval) {
        let shake = CASpringAnimation(keyPath: "position")
        
        shake.duration = duration
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.damping = 2.0
        shake.stiffness = 120
        
        let fromPoint = CGPoint(x: center.x - 4 , y: center.y)
        let toPoint = NSValue(cgPoint: fromPoint)
        shake.fromValue = fromPoint
        shake.toValue = toPoint
        
        layer.add(shake, forKey: nil)
    }
    
    
    func showSuccessAnimation(_ show: Bool) {
        if show {
            pulsate()
        } else {
            errorAnimation(duration: 0.01)
        }
    }
    
    
}

