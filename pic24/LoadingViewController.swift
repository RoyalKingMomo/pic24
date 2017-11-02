//
//  LoadingViewController.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-06.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: Delay App Entering due to cooler animation
        attemptAutoLogin(successToDo: {
            self.performSegue(withIdentifier: "autoLoginSuccess", sender: self)
        }, failToDo: {
            self.performSegue(withIdentifier: "loadingPageSuccess", sender: self)
        })
    }
    
}
