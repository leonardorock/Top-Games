//
//  ContextualImageTransitionAnimationController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/12/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

protocol ContextualImageTransitionDelegate {
    
    var imageViewFrameForContextualImageTransition: CGRect? { get }
    var imageForContextualImageTransition: UIImage? { get }
    
    func transitionSetup()
    func transitionCleanUp()
}

class ContextualImageTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.5
    
    private var fromDelegate: ContextualImageTransitionDelegate?
    private var toDelegate: ContextualImageTransitionDelegate?
    
    func setupTransition(from: ContextualImageTransitionDelegate?, to: ContextualImageTransitionDelegate?) {
        self.fromDelegate = from
        self.toDelegate = to
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let container = transitionContext.containerView
        
        toViewController.view.frame = fromViewController.view.frame
        let imageView = UIImageView(image: fromDelegate?.imageForContextualImageTransition)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = fromDelegate?.imageViewFrameForContextualImageTransition ?? .zero
        container.addSubview(imageView)
        
        fromDelegate?.transitionSetup()
        toDelegate?.transitionSetup()
        
        let fromSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: true)
        fromSnapshot?.frame = fromViewController.view.frame
        if let fromSnapshot = fromSnapshot {
            container.addSubview(fromSnapshot)
        }
        let toSnapshot = toViewController.view.snapshotView(afterScreenUpdates: true)
        toSnapshot?.frame = toViewController.view.frame
        toSnapshot?.alpha = 0
        if let toSnapshot = toSnapshot {
            container.addSubview(toSnapshot)
        }
        
        container.bringSubview(toFront: imageView)
        let toFrame: CGRect = toDelegate?.imageViewFrameForContextualImageTransition ?? .zero
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            toSnapshot?.alpha = 1.0
            imageView.frame = toFrame
        }) { [weak self] finished in
            
            self?.fromDelegate?.transitionCleanUp()
            self?.toDelegate?.transitionCleanUp()
            
            imageView.removeFromSuperview()
            fromSnapshot?.removeFromSuperview()
            toSnapshot?.removeFromSuperview()
            
            if !transitionContext.transitionWasCancelled {
                container.addSubview(toViewController.view)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
    }
    
}
