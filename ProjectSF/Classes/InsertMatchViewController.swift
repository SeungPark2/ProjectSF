//
//  InsertMatchViewController.swift
//  ProjectSF
//
//  Created by PST on 2019/12/17.
//  Copyright © 2019 PST. All rights reserved.
//

import UIKit

class InsertMatchViewController: UIViewController {

    @IBOutlet var teamNameTextField: UITextField?
    @IBOutlet var teamAgeTextField: UITextField?
    @IBOutlet var teamUniformTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
    }
    
    func setTextField() {
        teamNameTextField?.setPadding()
        teamNameTextField?.setBottomBorder()
        teamAgeTextField?.setPadding()
        teamAgeTextField?.setBottomBorder()
        teamUniformTextField?.setPadding()
        teamUniformTextField?.setBottomBorder()
    }
    
}

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
