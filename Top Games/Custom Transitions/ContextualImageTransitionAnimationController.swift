//
//  ContextualImageTransitionAnimationController.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/12/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

protocol ContextualImageTransitionProtocol {
    
    var imageViewFrame: CGRect? { get }
    
    func transitionSetup()
    func transitionCleanUp()
}

class ContextualImageTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.5
    
    private var image: UIImage?
    private var fromDelegate: ContextualImageTransitionProtocol?
    private var toDelegate: ContextualImageTransitionProtocol?
    
    func setupTransition(image: UIImage?, from: ContextualImageTransitionProtocol?, to: ContextualImageTransitionProtocol?) {
        self.image = image
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
        
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = fromDelegate?.imageViewFrame ?? .zero
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
        let toFrame: CGRect = toDelegate?.imageViewFrame ?? .zero
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
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
