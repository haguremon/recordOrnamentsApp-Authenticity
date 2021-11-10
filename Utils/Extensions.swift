//
//  Extensions.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/10/23.
//

import JGProgressHUD
import UIKit


extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    //インジゲーターの処理
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func showMessage(withTitle title: String, message: String,handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
       
        let message =  AuthService.errorMessage(of: error)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

        private final class StatusBarView: UIView { }

        func setStatusBarBackgroundColor(_ color: UIColor?) {
            for subView in self.view.subviews where subView is StatusBarView {
                subView.removeFromSuperview()
            }
            guard let color = color else {
                return
            }
            let statusBarView = StatusBarView()
            statusBarView.backgroundColor = color
            self.view.addSubview(statusBarView)
            statusBarView.translatesAutoresizingMaskIntoConstraints = false
            statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
   
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
//ダークモード等で変化するカラー等
    static var offWhiteOrBlack: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                let rgbValue: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0 : 247
                return UIColor(r: rgbValue, g: rgbValue, b: rgbValue)
            }
        } else {
            return UIColor(r: 247, g: 247, b: 247)
        }
    }
    
    static var offBlackOrWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                let rgbValue: CGFloat = traitCollection.userInterfaceStyle == .dark ? 247 : 0
                return UIColor(r: rgbValue, g: rgbValue, b: rgbValue)
            }
        } else {
            return UIColor(r: 0, g: 0, b: 0)
        }
    }
}

extension UIButton {
    
    func pulsate(){
        // 強調するボタン
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
    
    func flash() {
        // 光るボタン
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    func errorAnimation (duration: CFTimeInterval) {
        // 揺れるボタン
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
    func shake2() {
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.fromValue = 1.25
        animation.toValue = 1.0
        animation.mass = 1.0
        animation.initialVelocity = 30.0
        animation.damping = 3.0
        animation.stiffness = 120.0
        layer.add(animation, forKey: nil)
    }
    
    func touchStartAnimation(duration: TimeInterval,delay: TimeInterval) {
       UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
           self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
           self.alpha = 0.9
       },completion: nil)
   }

    
    
    func showAnimation(_ show: Bool) {
        if show {
            pulsate()
            
        } else {
            errorAnimation(duration: 0.01)
            
        }
    }
    
    
}
extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
        func anchor1(top: NSLayoutYAxisAnchor?,
                    leading: NSLayoutXAxisAnchor?,
                    bottom: NSLayoutYAxisAnchor?,
                    trailing: NSLayoutXAxisAnchor?,
                    padding: UIEdgeInsets = .zero,
                    size: CGSize = .zero) {
            translatesAutoresizingMaskIntoConstraints = false
            
            if let top = top {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            }
            
            if let leading = leading {
                leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            }
            
            if let bottom = bottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
            }
            
            if let trailing = trailing {
                trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
            }
            
            if size.width != 0 {
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            
            if size.height != 0 {
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
    }
    
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}









extension UIWindow {

    func beginIgnoringInteractionEvents() {
        let overlayView = UIView(frame: bounds)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.tag = 10000
            addSubview(overlayView)
    }

    func endIgnoringInteractionEvents() {
        viewWithTag(10000)?.removeFromSuperview()
    }
}
