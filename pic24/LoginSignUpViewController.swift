//
//  LoginSignUpViewController.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-06.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    //Create login
    
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        self.signUpButton.setup()
    }
    
}

class CustomButton: UIView {
    
    func setup(){
        self.roundCorners(UIRectCorner.allCorners, radius: 200)
    }
    
    var onPress: () -> Void  = {};
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onPress()
    }
}
