//
//  MainViewController.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 06/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import Foundation


class MainViewController : UIViewController{
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var scanImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var configImage: UIImageView!
    
    var cameraController : CameraViewController?
    var listController : ViewController?
    var configController : ConfigViewController?
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            
            inActiveVC.willMoveToParentViewController(nil)
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
            
            (inActiveVC as! BaseController).Active();
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            
            addChildViewController(activeVC)
            activeVC.view.frame = container.bounds;
            
            container.addSubview(activeVC.view)
            
            activeVC.didMoveToParentViewController(self)
            (activeVC as! BaseController).Inactive();
            
            /*
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.005 * Double(NSEC_PER_SEC)))
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {
            activeVC.view.setNeedsUpdateConstraints();
            activeVC.view.setTranslatesAutoresizingMaskIntoConstraints(true)
            activeVC.updateViewConstraints();
            
            activeVC.viewDidLayoutSubviews()
            }
            */
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture1 = UITapGestureRecognizer(target: self, action: Selector("showScan"))
        scanImage.addGestureRecognizer(gesture1);
        
        let gesture2 = UITapGestureRecognizer(target: self, action: Selector("showList"))
        listImage.addGestureRecognizer(gesture2);
        
        let gesture3 = UITapGestureRecognizer(target: self, action: Selector("showConfig"))
        configImage.addGestureRecognizer(gesture3);
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        cameraController =  storyBoard.instantiateViewControllerWithIdentifier("Camera") as? CameraViewController
        listController =  storyBoard.instantiateViewControllerWithIdentifier("List") as? ViewController
        configController =  storyBoard.instantiateViewControllerWithIdentifier("Config") as? ConfigViewController
        
        activeViewController = listController
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.activeViewController = self.listController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showList() {
        if (activeViewController != listController)
        {
            activeViewController = listController
        }
    }
    
    func showScan() {
        if (activeViewController != cameraController)
        {
            activeViewController = cameraController
        }
    }
    
    func showConfig() {
        if (activeViewController != configController)
        {
            activeViewController = configController
            configController?.viewDidLoad();
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}

/*

func showList() {
executeController(listController, image:listImage);
}

func showScan() {
executeController(cameraController, image:scanImage);
}

func showConfig() {
executeController(configController, image:configImage);
}

private func executeController(controller: UIViewController!, image: UIImageView!)
{
var sprintAnimation = POPSpringAnimation(propertyNamed:kPOPViewScaleXY);

sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(12, 12));
sprintAnimation.springBounciness = 20;
//image.pop_addAnimation(sprintAnimation, forKey:"sendAnimation");

if (self.activeViewController != controller)
{
self.activeViewController = controller
controller?.viewDidLoad();
}
}
*/