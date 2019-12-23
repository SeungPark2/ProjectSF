//
//  SignUpViewController.swift
//  ProjectSF
//
//  Created by PST on 2019/12/23.
//  Copyright © 2019 PST. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mainBackButton(_sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
