//
//  KKPanAnimationController.swift
//
//  Created by Kyle Kirkland on 3/23/15.
//  Copyright (c) 2015 Kyle Kirkland. All rights reserved.
//


import Foundation
import UIKit


protocol KKPanAnimationControllerDelegate: class  {
    func completedDismissal()
    func updateForProgress(progress: CGFloat, forViewController viewController: UIViewController)
}

class KKPanAnimationController: KKReversibleAnimationController {
    
    var dynamicAnimator: UIDynamicAnimator?
    weak var context: UIViewControllerContextTransitioning?
    weak var navigationBar: UIView? {
        didSet {
            self.navigationBarSnapshot = self.navigationBar!.snapshotViewAfterScreenUpdates(true)
        }
    }
    var navigationBarSnapshot: UIView?
    weak var delegate: KKPanAnimationControllerDelegate?
    
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
       
        self.context = transitionContext
        let containerView = transitionContext.containerView()
        let detailVc =  reverse ? fromVC : toVC
        
        
        self.dynamicAnimator = UIDynamicAnimator(referenceView: containerView)
        self.dynamicAnimator!.delegate = self
        
        if let navBar = self.navigationBar {
            animateSnapshotWithParentView(detailVc, containerView: containerView)
        }

    }
    
    /**
    Takes a snapshot of the navigation bar and sets up the UIKitDyamics behaviors
    for the transition. It is assumed that the self.navigationBarSnapshot property is not nil.
    
    :param: parentVc      Presenting - toVC, Dismissing - fromVC
    :param: containerView The container view of the transition.
    */
    private func animateSnapshotWithParentView(parentVc: UIViewController, containerView: UIView) {
        
        //Add the nav bar snapshot and position it correctly.
        parentVc.view.addSubview(self.navigationBarSnapshot!)
        self.navigationBarSnapshot!.frame = CGRectMake(0, CGRectGetHeight(parentVc.view.frame) - CGRectGetHeight(self.navigationBar!.frame), CGRectGetWidth(containerView.frame), CGRectGetHeight(self.navigationBar!.frame))
        
        // If we are not dismissing, then we need to add the toView to the containerView.
        // This toView will be the parentView for this case.
        if !reverse {
            containerView.addSubview(parentVc.view)
            parentVc.view.frame = CGRect(
                x: parentVc.view.frame.origin.x,
                y: -CGRectGetHeight(parentVc.view.frame) + CGRectGetHeight(self.navigationBarSnapshot!.frame),
                width: CGRectGetWidth(parentVc.view.frame),
                height: CGRectGetHeight(parentVc.view.frame)
            )
        }
        
        //Configure the gravity
        self.addGravityBehavior(parentVc, containerView: containerView)
        
        //Configure the collision behavior
        self.addCollisionBehavior(parentVc, containerView: containerView)
        
        //TODO: Let UIKitDynamics to its magic !
        // Refer to the UIDynamicAnimatorDelegate extension for transition completion
    }
    
    /**
    Configures the collision boundary for the transition. 
    The collision boundary will either be the top or bottom edge of the container view 
    depending on the direction of the transition.
    
    :param: parentVc      Presenting - toVC, Dismissing - fromVC
    :param: containerView The container view of the transition.
    */
    private func addCollisionBehavior(parentVc: UIViewController, containerView: UIView) {
        // Configure the collision boundary
        // This will be the bottom edge or top of the container view.
        var collision = UICollisionBehavior(items: [parentVc.view])
        
        // Calculate the collision boundary.
        // The height is added to the y coordinate when the transition is reversed to
        // make the nav bar appear to collide with the top of the screen and come to rest.
        let fromPoint = !reverse ? CGPoint(x: 0, y: CGRectGetMaxY(containerView.frame) + 1) :
            CGPoint(x: 0, y: -CGRectGetHeight(containerView.frame) + CGRectGetHeight(self.navigationBarSnapshot!.frame))
        let toPoint = !reverse ? CGPoint(x: CGRectGetMaxX(containerView.frame), y: CGRectGetMaxY(containerView.frame) + 1) : CGPoint(x: CGRectGetMaxX(containerView.frame), y: -CGRectGetHeight(containerView.frame) + CGRectGetHeight(self.navigationBarSnapshot!.frame))
        
        collision.addBoundaryWithIdentifier("CollisionEdge", fromPoint: fromPoint, toPoint: toPoint)
        self.dynamicAnimator!.addBehavior(collision)
    }
    
    /**
    Configures the gravity behavior for the transition.
    The gravity behavior will either be in the +/- y direction.
    
    :param: parentVc      Presenting - toVC, Dismissing - fromVC
    :param: containerView The container view of the transition.
    */
    private func addGravityBehavior(parentVc: UIViewController, containerView: UIView) {
        var gravity = UIGravityBehavior(items: [parentVc.view])
        gravity.gravityDirection = CGVectorMake(0, !reverse ? 7 : -12 )
        
        //Add action to gravity to get progress updates.
        gravity.action = {[unowned self] in
            let height = !self.reverse ? CGRectGetHeight(containerView.frame) : (CGRectGetHeight(containerView.frame) - CGRectGetHeight(self.navigationBarSnapshot!.frame))
            
            var progress = max(0, abs(parentVc.view.frame.origin.y) / height)
            
            //TODO: hides nav bar variable.
            self.navigationBarSnapshot!.alpha = min(1, progress)
            self.delegate?.updateForProgress(1-progress, forViewController: parentVc)
            
        }
        self.dynamicAnimator?.addBehavior(gravity)
    }

}

extension KKPanAnimationController: UIDynamicAnimatorDelegate {
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        
        //Clean up. Direction of transition does not matter for this section of code. 
        self.dynamicAnimator!.removeAllBehaviors()
        self.context!.completeTransition(true)
        self.navigationBarSnapshot?.removeFromSuperview()
    }
}
