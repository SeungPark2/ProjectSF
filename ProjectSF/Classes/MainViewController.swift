//
//  MainViewController.swift
//  ProjectSF
//
//  Created by PST on 2019/12/23.
//  Copyright © 2019 PST. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInButton(_ sender: UIButton) {
        guard let login = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") else {return}
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let signup = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") else {return}
        self.present(signup, animated: true)
    }
    
}
