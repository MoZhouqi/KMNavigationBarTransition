//
//  UIViewController+KMNavigationBarTransition.swift
//  KMNavigationBarTransition
//
//  Created by 伯驹 黄 on 2016/12/23.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

extension UIViewController {
    struct AssociatedKeys {
        static var transitionNavigationBar: String? = "transitionNavigationBar"
        static var prefersNavigationBarBackgroundViewHidden: String? = "prefersNavigationBarBackgroundViewHidden"
        static var transitionContextToViewController: String? = "transitionContextToViewController"
    }

    static let onceToken = UUID().uuidString

    open override class func initialize() {

        DispatchQueue.once(token: onceToken) {

            KMSwizzleMethod(self,
                            originalSelector: #selector(viewWillLayoutSubviews),
                            swizzledSelector: #selector(km_viewWillLayoutSubviews))

            KMSwizzleMethod(self,
                            originalSelector: #selector(viewDidAppear),
                            swizzledSelector: #selector(km_viewDidAppear))
        }
    }

    func km_viewDidAppear(_ animated: Bool) {
        if let bar = km_transitionNavigationBar {
            navigationController?.navigationBar.setBar(using: bar)

            let transitionViewController = navigationController?.km_transitionContextToViewController

            if transitionViewController == nil || transitionViewController == self {
                km_transitionNavigationBar?.removeFromSuperview()
                km_transitionNavigationBar = nil
                navigationController?.km_transitionContextToViewController = nil
            }
        }
        km_prefersNavigationBarBackgroundViewHidden = false
        km_viewDidAppear(animated)
    }

    func km_viewWillLayoutSubviews() {
        let tc = transitionCoordinator
        let fromVC = tc?.viewController(forKey: .from)
        let toVC = tc?.viewController(forKey: .to)

        if self == navigationController?.viewControllers.last && toVC == self {
            let isTranslucent = navigationController?.navigationBar.isTranslucent ?? false

            if isTranslucent {
                tc?.containerView.backgroundColor = navigationController?.km_containerViewBackgroundColor
            }
            fromVC?.view.clipsToBounds = false
            toVC?.view.clipsToBounds = false
            if km_transitionNavigationBar == nil {
                km_addTransitionNavigationBarIfNeeded()

                km_prefersNavigationBarBackgroundViewHidden = true
            }
            km_resizeTransitionNavigationBarFrame()
        }
        if let bar = km_transitionNavigationBar {
            view.bringSubview(toFront: bar)
        }
        km_viewWillLayoutSubviews()
    }

    func km_resizeTransitionNavigationBarFrame() {
        if view.window == nil { return }
        let backgroundView = navigationController?.navigationBar.value(forKey: "_backgroundView") as? UIView
        let rect = backgroundView?.superview?.convert(backgroundView?.frame ?? CGRect(), to: view)
        km_transitionNavigationBar?.frame = rect ?? CGRect()
    }

    func km_addTransitionNavigationBarIfNeeded() {
        if !isViewLoaded || view.window == nil { return }
        guard let navigationBar = navigationController?.navigationBar else { return }
        km_adjustScrollViewContentOffsetIfNeeded()
        let bar = UINavigationBar()
        bar.barStyle = navigationBar.barStyle
        if bar.isTranslucent != navigationBar.isTranslucent {
            bar.isTranslucent = navigationBar.isTranslucent
        }
        bar.setBar(using: navigationBar)
        km_transitionNavigationBar?.removeFromSuperview()
        km_transitionNavigationBar = bar
        km_resizeTransitionNavigationBarFrame()
        if navigationController?.isNavigationBarHidden == false && !navigationBar.isHidden {
            view.addSubview(km_transitionNavigationBar!)
        }
    }

    func km_adjustScrollViewContentOffsetIfNeeded() {
        if let scrollView = view as? UIScrollView {
            let topContentOffsetY = -scrollView.contentInset.top
            let bottomContentOffsetY = scrollView.contentSize.height - (scrollView.bounds.height - scrollView.contentInset.bottom)

            var adjustedContentOffset = scrollView.contentOffset
            if adjustedContentOffset.y > bottomContentOffsetY {
                adjustedContentOffset.y = bottomContentOffsetY
            }
            if adjustedContentOffset.y < topContentOffsetY {
                adjustedContentOffset.y = topContentOffsetY
            }

            scrollView.setContentOffset(adjustedContentOffset, animated: false)
        }
    }

    var km_transitionNavigationBar: UINavigationBar? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transitionNavigationBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.transitionNavigationBar) as? UINavigationBar
        }
    }

    var km_prefersNavigationBarBackgroundViewHidden: Bool {
        set {
            let backgroundView = navigationController?.navigationBar.value(forKey: "_backgroundView") as? UIView
            backgroundView?.isHidden = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.prefersNavigationBarBackgroundViewHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.prefersNavigationBarBackgroundViewHidden) as? Bool ?? false
        }
    }
}
