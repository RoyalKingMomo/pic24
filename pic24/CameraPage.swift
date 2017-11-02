//
//  CameraPage.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-06.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPage: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = UIColor(hex: 0xFFFFFF)
    }
    
    //func to temporary logout fast af
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print(touch.location(in: self.view))
            logOut(completion: {
                self.parent!.performSegue(withIdentifier: "loggedOut", sender: self.parent!)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
