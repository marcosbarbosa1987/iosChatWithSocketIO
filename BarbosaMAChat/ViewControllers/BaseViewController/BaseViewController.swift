//
//  BaseViewController.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 10/11/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }

}
