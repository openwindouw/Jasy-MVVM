//
//  BottomSheetViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 09/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    // holdView can be UIImageView instead
    @IBOutlet weak var holdView: UIView!
    
    private var parentHeight: CGFloat!
    private var fullView: CGFloat = 545 //This number is just a placeholder. It'll be calculated on ViewDidLoad.
    
    var _minimumHeight: CGFloat! {
        didSet {
            partialView = UIScreen.main.bounds.height - (minimumHeight! + UIApplication.shared.statusBarFrame.height)
        }
    }
    
    private var minimumHeight: CGFloat! {
        set {
            _minimumHeight = newValue
        }
        get {
            return _minimumHeight
        }
    }
    
    private var partialView: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initially, view has the storyboard scene size.
        //We forced it to take the device size.
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(gesture)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet)))
        holdView.backgroundColor = .blue
        roundViews()
        
        view.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        view.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        minimumHeight = 0
        
        fullView = fullView <= 0 ? 10 : fullView
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            let frame = self.view.frame
            let yComponent = self.fullView
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            self.view.alpha = 1
        })
    }
    
    deinit {
        print("deallocated bottom sheet")
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    private func roundViews() {
        view.layer.cornerRadius = 5
        holdView.layer.cornerRadius = 3
        view.clipsToBounds = true
    }
    
    private func prepareBackgroundView(){
        view.backgroundColor = .white
    }
    
    @discardableResult
    class func show(in viewController: UIViewController) -> BottomSheetViewController {
        let bottomSheetVC =  R.storyboard.main.bottomSheetViewControllerID()!
        
        
        bottomSheetVC.parentHeight = viewController.view.bounds.height
        
        viewController.addChild(bottomSheetVC)
        viewController.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: viewController)
        
        return bottomSheetVC
    }
    
    @objc func dismissBottomSheet() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
