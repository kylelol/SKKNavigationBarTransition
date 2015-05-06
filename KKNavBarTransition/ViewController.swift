//
//  ViewController.swift
//  KKNavBarTransition
//
//  Created by Kyle Kirkland on 5/6/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*lazy var navBarAnimationController: KKPanAnimationController? = {
        return KKPanAnimationController()
    }()*/
    
    let navBarAnimationController = KKPanAnimationController()
    
    @IBOutlet weak var navigationBar: UIView!
    
    //MARK: View Lifecycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    @IBAction func didTapButton(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailVC") as! UIViewController
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }


}

//MARK: UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.navBarAnimationController.reverse = false
        self.navBarAnimationController.navigationBar = self.navigationBar
        return self.navBarAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.navBarAnimationController.reverse = true
        return self.navBarAnimationController
    }
    
    
}

