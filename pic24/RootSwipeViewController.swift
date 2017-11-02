//
//  RootSwipeViewController.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-07.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

import UIKit

var cameraPage:CameraPage = CameraPage()
var homePage:HomePage = HomePage()
var notificationsPage:NotificationsPage = NotificationsPage()

var currentIndex = 1

class CustomScrollView: UIScrollView{
    
    func initSelf() {
        self.isScrollEnabled = false
    }
    
}

class RootSwipeViewController : UIViewController {
    
    @IBOutlet var csv: CustomScrollView!
    
    override func viewDidLoad() {
        cameraPage = CameraPage(nibName: "CameraPage", bundle: nil)
        homePage = HomePage(nibName: "HomePage", bundle: nil)
        notificationsPage = NotificationsPage(nibName: "NotificationsPage", bundle: nil)
        
        // add backwards
        
        self.addChildViewController(notificationsPage)
        self.csv.addSubview(notificationsPage.view)
        notificationsPage.didMove(toParentViewController: self)

        self.addChildViewController(homePage)
        self.csv.addSubview(homePage.view)
        homePage.didMove(toParentViewController: self)
        
        self.addChildViewController(cameraPage)
        self.csv.addSubview(cameraPage.view)
        cameraPage.didMove(toParentViewController: self)
        
        notificationsPage.view.frame = self.view.frame
        notificationsPage.view.center.x += self.view.frame.width*2
        
        homePage.view.frame = self.view.frame
        homePage.view.center.x += self.view.frame.width*1
        
        cameraPage.view.frame = self.view.frame
        
        let scrollWidth: CGFloat  = 3 * self.view.frame.width
        let scrollHeight: CGFloat  = self.view.frame.size.height
        self.csv!.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        self.csv!.contentOffset.x += self.view.frame.width*1
        self.csv.initSelf()
        
        self.setupScroll()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentIndex = 1 // make sure view resets to index = 1 when readded
    }
    
    func setupScroll(){
        
        let leftGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(goLeft))
        leftGesture.direction = .left
        let rightGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        rightGesture.direction = .right
        
        self.view.addGestureRecognizer(leftGesture)
        self.view.addGestureRecognizer(rightGesture)
    }
    
    @objc func goLeft (){
        let homeFrame = homePage.view.frame
        let notificationsFrame = notificationsPage.view.frame
        switch currentIndex%3{
        case 0:
            self.csv.scrollRectToVisible(homeFrame, animated: true)
            currentIndex=1
            break;
        case 1:
            self.csv.scrollRectToVisible(notificationsFrame, animated: true)
            currentIndex=2
            break;
        case 2:
            print("reached limit")
            break;
        default:
            break;
        }
    }
    @objc func goRight (){
        let cameraFrame = cameraPage.view.frame
        let homeFrame = homePage.view.frame
        switch currentIndex%3{
        case 0:
            print("reached limit")
            break;
        case 1:
            self.csv.scrollRectToVisible(cameraFrame, animated: true)
            currentIndex=0
            break;
        case 2:
            self.csv.scrollRectToVisible(homeFrame, animated: true)
            currentIndex=1
            break;
        default:
            break;
        }
    }
}
