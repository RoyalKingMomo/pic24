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
    var posOfSignUpButton: CGFloat = 0
    var posOfEmailTextField: CGFloat = 0
    var posOfEmailUnderline: CGFloat = 0
    var colOfEmailUnderline: UIColor = UIColor.black
    var colOfPasswordUnderline: UIColor = UIColor.black
    
    
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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameUnderline: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameUnderline: UIView!
    @IBOutlet weak var birthLabel: UILabel!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        self.signUpButton.setup()
        self.loginButton.setup()
        
        self.signUpButton.onPress = {
            //First Check email and password conformity
            var emailCheck:Bool = false
            var passwordCheck:Bool = false
            if self.emailTextField.text! != "" {
                self.emailTextField.text! = self.emailTextField.text!.trailingTrim(.whitespaces)
            }
            if self.emailTextField.text!.isValidEmail() {
                emailCheck = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailUnderline.backgroundColor! = self.colOfEmailUnderline
                })
            }else{
                emailCheck = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                })
            }
            if self.passwordTextField.text!.count >= 6 {
                passwordCheck = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.passwordUnderline.backgroundColor! = self.colOfPasswordUnderline
                })
            }else{
                passwordCheck = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.passwordUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                })
            }
            //Go to SignUp End
            if passwordCheck && emailCheck {
                if self.state == 1 {
                    self.stateChanger(toState: 2)
                }else if self.state == 2{
                    var usernameCheck: Bool = false
                    var nameCheck: Bool = false
                    if self.usernameTextField.text! != "" {
                        self.usernameTextField.text! = self.usernameTextField.text!.trailingTrim(.whitespaces)
                    }
                    if self.nameTextField.text! != "" {
                        self.nameTextField.text! = self.nameTextField.text!.trailingTrim(.whitespaces)
                    }
                    if self.usernameTextField.text!.isValidUsername() {
                        usernameCheck = true
                        UIView.animate(withDuration: 0.3, animations: {
                            self.usernameUnderline.backgroundColor! = self.colOfEmailUnderline
                        })
                    }else{
                        usernameCheck = false
                        UIView.animate(withDuration: 0.3, animations: {
                            self.usernameUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                        })
                    }
                    if self.nameTextField.text! != "" {
                        nameCheck = true
                        UIView.animate(withDuration: 0.3, animations: {
                            self.nameUnderline.backgroundColor! = self.colOfPasswordUnderline
                        })
                    }else{
                        nameCheck = false
                        UIView.animate(withDuration: 0.3, animations: {
                            self.nameUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                        })
                    }
                    
                    if usernameCheck && nameCheck {
                        //Actually Perform Signup
                        performSignUp(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {
                            //Add vars
                            fillUserDataOnSignUp(name: self.nameTextField.text!, username: self.usernameTextField.text!, dateOfBirth: self.birthDatePicker.date)
                            //perform Segue
                            self.performSegue(withIdentifier: "authSuccess", sender: self)
                        })
                    }
                }
            }
        }
        self.loginButton.onPress = {
            //Actually login
            var emailCheck:Bool = false
            var passwordCheck:Bool = false
            if self.emailTextField.text! != "" {
                self.emailTextField.text! = self.emailTextField.text!.trailingTrim(.whitespaces)
            }
            if self.emailTextField.text!.isValidEmail() {
                emailCheck = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailUnderline.backgroundColor! = self.colOfEmailUnderline
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                })
            }
            if self.passwordTextField.text!.count >= 6 {
                passwordCheck = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.passwordUnderline.backgroundColor! = self.colOfPasswordUnderline
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.passwordUnderline.backgroundColor! = UIColor.init(hex: 0xCC2222).withAlphaComponent(0.5)
                })
            }
            if emailCheck && passwordCheck{
                performLogin(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {
                    //perform Segue
                    self.performSegue(withIdentifier: "authSuccess", sender: self)
                })
            }
        }
        
        self.stateSetup()
        self.saveVars()
    }
    
    func saveVars () {
        self.posOfSignUpButton = self.signUpButton.frame.origin.y
        self.posOfEmailTextField = self.emailTextField.frame.origin.y
        self.posOfEmailUnderline = self.emailUnderline.frame.origin.y
        self.colOfEmailUnderline = self.emailUnderline.backgroundColor!
        self.colOfPasswordUnderline = self.passwordUnderline.backgroundColor!
    }
    
    @IBAction func alternativeLoginButtonPressed(_ sender: Any) {
        stateChanger(toState: 0)
    }
    @IBAction func alternativeSignUpButtonPressed(_ sender: Any) {
        stateChanger(toState: 1)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
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
        self.backButton.alpha -= 1
        self.birthDatePicker.alpha -= 1
        self.birthLabel.alpha -= 1
        self.nameTextField.alpha -= 1
        self.usernameTextField.alpha -= 1
        self.usernameUnderline.alpha -= 1
        self.nameUnderline.alpha -= 1
        var comp  = DateComponents.init()
        comp.year = -150
        self.birthDatePicker.minimumDate = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!.date(byAdding: comp, to: Date.init(), options: NSCalendar.Options.init(rawValue: 0))
        comp.year = -13
        self.birthDatePicker.maximumDate = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!.date(byAdding: comp, to: Date.init(), options: NSCalendar.Options.init(rawValue: 0))
        self.birthDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.birthDatePicker.setValue(false, forKeyPath: "highlightsToday")
        
        //TEMP
        self.emailTextField.text! = "malalalal@ualabsss.ca"
        self.passwordTextField.text! = "321uids"
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
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.alpha -= 1
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.birthDatePicker.alpha -= 1
            self.birthLabel.alpha -= 1
            self.nameTextField.alpha -= 1
            self.usernameTextField.alpha -= 1
            self.usernameUnderline.alpha -= 1
            self.nameUnderline.alpha -= 1
        }, completion: { (uneeded) in
            UIView.animate(withDuration: 0.3, animations: {
                self.pic24Logo.frame.origin.y += (self.pic24Logo.frame.height + self.pic24Logo.frame.minY)
                self.emailUnderline.frame.origin.y += (self.posOfEmailUnderline - self.view.frame.height/32 - self.emailTextField.frame.height)
                self.emailTextField.frame.origin.y += (self.posOfEmailTextField - self.view.frame.height/32)
                self.emailUnderline.alpha += 1
                self.passwordTextField.alpha += 1
                self.passwordUnderline.alpha += 1
                self.signUpButton.frame.origin.y -= (-self.posOfSignUpButton + self.view.frame.height*5/6)
                self.emailTextField.isEnabled = true
                self.loginAlternativeLabel.alpha += 1
                self.loginAlternativeButton.alpha += 1
            })
        })
    }
    func signUpStartToSignUpEnd () {
        UIView.animate(withDuration: 0.300, animations: {
            self.pic24Logo.frame.origin.y -= (self.pic24Logo.frame.height + self.pic24Logo.frame.minY)
            self.emailUnderline.frame.origin.y -= (self.posOfEmailUnderline - self.view.frame.height/32 - self.emailTextField.frame.height)
            self.emailTextField.frame.origin.y -= (self.posOfEmailTextField - self.view.frame.height/32)
            self.emailUnderline.alpha -= 1
            self.passwordTextField.alpha -= 1
            self.passwordUnderline.alpha -= 1
            self.signUpButton.frame.origin.y += (-self.posOfSignUpButton + self.view.frame.height*5/6)
            self.emailTextField.isEnabled = false
            self.loginAlternativeLabel.alpha -= 1
            self.loginAlternativeButton.alpha -= 1
            self.backButton.alpha += 1
        }, completion: { (uneeded) in
            UIView.animate(withDuration: 0.5, animations: {
                self.birthDatePicker.alpha += 1
                self.birthLabel.alpha += 1
                self.nameTextField.alpha += 1
                self.usernameTextField.alpha += 1
                self.usernameUnderline.alpha += 1
                self.nameUnderline.alpha += 1
            })
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
