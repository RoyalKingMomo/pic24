//
//  LoginSignUpViewController.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-06.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    var state:Int  = 1 // goes from 0 to 2.
    // State 0: Login Page
    // State 1: SignUp Start Page
    // State 2: SignUp End Page
    
    
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var loginAlternativeButton: UIButton!
    @IBOutlet weak var loginAlternativeLabel: UILabel!
    @IBOutlet weak var signUpAlternativeLabel: UILabel!
    @IBOutlet weak var signUpAlternativeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailUnderline: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordUnderline: UIView!
    @IBOutlet weak var pic24Logo: UIImageView!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        self.signUpButton.setup()
        self.loginButton.setup()
        
        self.signUpButton.onPress = {
            //First Check email and password conformity
            var emailCheck:Bool = false
            var passwordCheck:Bool = false
            if self.emailTextField.text!.isValidEmail() {
                emailCheck = true
            }
            if self.passwordTextField.text!.count >= 6 {
                passwordCheck = true
            }
            //Go to SignUp End
            if passwordCheck && emailCheck {
                if self.state == 1 {
                    self.stateChanger(toState: 2)
                }else if self.state == 2{
                    //Actually Perform SignUp
                }
            }
        }
        self.loginButton.onPress = {
            //Actually login
            var emailCheck:Bool = false
            var passwordCheck:Bool = false
            if self.emailTextField.text!.isValidEmail() {
                emailCheck = true
            }
            if self.passwordTextField.text!.count >= 6 {
                passwordCheck = true
            }
            if emailCheck && passwordCheck{
                performLogin(email: self.emailTextField.text!, password: self.passwordTextField.text!)
            }
        }
        
        self.stateSetup()
    }
    
    @IBAction func alternativeLoginButtonPressed(_ sender: Any) {
        stateChanger(toState: 0)
    }
    @IBAction func alternativeSignUpButtonPressed(_ sender: Any) {
        stateChanger(toState: 1)
    }
    
    func stateChanger (toState: Int){
        let fromState:Int = self.state
        self.state = toState
        
        switch toState {
            case 0:
                switch fromState {
                    case 1:
                        // Do from SignUp Start to Login
                        self.signUpStartToLogin()
                        break;
                    case 2:
                        fatalError("Cannot go from SignUp End to Login!")
                        break;
                    default:
                        fatalError("fromState and toState is the same! (or not from 0-2)")
                        break;
                }
                break;
            case 1:
                switch fromState {
                    case 0:
                        // Do from Login to SignUp Start
                        self.loginToSignUpStart()
                        break;
                    case 2:
                        // Do from SignUp End to SignUp Start
                        self.signUpEndToSignUpStart()
                        break;
                    default:
                        fatalError("fromState and toState is the same! (or not from 0-2)")
                        break;
                }
                break;
            case 2:
                switch fromState {
                    case 0:
                        fatalError("Cannot go from Login to SignUp End!")
                        break;
                    case 1:
                        // Do from SignUp Start to SignUp End
                        self.signUpStartToSignUpEnd()
                        break;
                    default:
                        fatalError("fromState and toState is the same! (or not from 0-2)")
                        break;
                }
                break;
            default:
                fatalError("state not from 0-2")
                break;
        }
    }
    
    func stateSetup () {
        self.loginButton.frame.origin.x -= self.view.frame.width
        self.signUpAlternativeButton.frame.origin.x -= self.view.frame.width
        self.signUpAlternativeLabel.frame.origin.x -= self.view.frame.width
    }
    
    func signUpStartToLogin () {
        UIView.animate(withDuration: 0.300, animations: {
            self.loginButton.frame.origin.x += self.view.frame.width
            self.signUpButton.frame.origin.x += self.view.frame.width
            self.loginAlternativeLabel.frame.origin.x += self.view.frame.width
            self.signUpAlternativeButton.frame.origin.x += self.view.frame.width
            self.signUpAlternativeLabel.frame.origin.x += self.view.frame.width
            self.loginAlternativeButton.frame.origin.x += self.view.frame.width
        })
    }
    func loginToSignUpStart ()  {
        UIView.animate(withDuration: 0.300, animations: {
            self.loginButton.frame.origin.x -= self.view.frame.width
            self.signUpButton.frame.origin.x -= self.view.frame.width
            self.loginAlternativeLabel.frame.origin.x -= self.view.frame.width
            self.signUpAlternativeButton.frame.origin.x -= self.view.frame.width
            self.signUpAlternativeLabel.frame.origin.x -= self.view.frame.width
            self.loginAlternativeButton.frame.origin.x -= self.view.frame.width
        })
        
    }
    func signUpEndToSignUpStart () {
        UIView.animate(withDuration: 0.300, animations: {
            
        })
    }
    func signUpStartToSignUpEnd () {
        UIView.animate(withDuration: 0.300, animations: {
            self.pic24Logo.frame.origin.y -= (self.pic24Logo.frame.height + self.pic24Logo.frame.minY)
        })
    }
    
    
}

class CustomButton: UIView {
    
    func setup(){
        self.roundCorners(UIRectCorner.allCorners, radius: 5)
    }
    
    var onPress: () -> Void  = {};
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onPress()
    }
}
