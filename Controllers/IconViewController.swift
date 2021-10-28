//
//  IconViewController.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/08.
//

import UIKit

class IconViewController: UIViewController {

    
    @IBOutlet weak var iconVIew: UIView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func selectedButton(_ sender: UIButton) {
    //ここで選択してFierBaseに画像を保存する
    //ログイン画面で表示する
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
     
    
    
    }
    

}

