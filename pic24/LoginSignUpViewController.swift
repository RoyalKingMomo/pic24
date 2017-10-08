//
//  LoginSignUpViewController.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-06.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit
var i = 1;

class LoginSignUpViewController: UIViewController {
    //Create login
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var signUpButton: CustomButton!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround();
        self.loginButton.onPress = {self.performSegue(withIdentifier: "authSuccess", sender: self)}
    }
    
}

class CustomButton: UIView {
    
    var onPress: () -> Void  = {};
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onPress()
    }
}
