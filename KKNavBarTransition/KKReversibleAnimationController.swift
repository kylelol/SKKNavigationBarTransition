//
//  KKReversibleAnimationController.swift
//
//  Created by Kyle Kirkland on 3/23/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//

import UIKit

/**
*  Class for custom transitions that wish to reverse their animations typically for dismissal
*/
class KKReversibleAnimationController: NSObject {
    
    var reverse: Bool = false
    var transitionDuration: NSTimeInterval!
    
    override init() {
        super.init()
        
        self.transitionDuration = 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        
    }
    

}

extension KKReversibleAnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController?
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController?
        var toView = toVC!.view
        var fromView = fromVC!.view
        
        self.animateTransition(transitionContext, fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView)
        
    }
    
}
