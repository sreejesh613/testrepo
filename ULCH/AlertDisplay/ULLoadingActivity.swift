//
//  ULLoadingActivity.swift
//  ULLoadingActivity
//
//  Created by Goktug Yilmaz on 02/06/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

public struct ULLoadingActivity {
    
    //==========================================================================================================
    // Feel free to edit these variables
    //==========================================================================================================
    public struct Settings {
        public static var BackgroundColor = UIColor.lightText
        public static var ActivityColor = UIColor.black
        public static var TextColor = UIColor.black
        public static var FontName = "HelveticaNeue-Light"
        // Other possible stuff: ✓ ✓ ✔︎ ✕ ✖︎ ✘
        public static var SuccessIcon = "✔︎"
        public static var FailIcon = "✘"
        public static var SuccessText = "Success"
        public static var FailText = "Failure"
        public static var SuccessColor = UIColor(red: 68/255, green: 118/255, blue: 4/255, alpha: 1.0)
        public static var FailColor = UIColor(red: 255/255, green: 75/255, blue: 56/255, alpha: 1.0)
        public static var ActivityWidth = UIScreen.ScreenWidth / Settings.WidthDivision
        public static var ActivityHeight = ActivityWidth / 3
        public static var WidthDivision: CGFloat {
            get {
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    return  3.5
                } else {
                    return 2.0
                }
            }
        }
    }
    
    fileprivate static var instance: LoadingActivity?
    fileprivate static var hidingInProgress = false
    
    /// Disable UI stops users touch actions until ULLoadingActivity is hidden. Return success status
    @discardableResult public static func show(_ text: String, disableUI: Bool) -> Bool {
        guard instance == nil else {
            print("ULLoadingActivity: You still have an active activity, please stop that before creating a new one")
            return false
        }
        
        guard topMostController != nil else {
            print("ULLoadingActivity Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
            return false
        }
        // Separate creation from showing
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            instance?.showLoadingActivity()
        }
        return true
    }
    
    public static func showWithDelay(_ text: String, disableUI: Bool, seconds: Double) -> Bool {
        let showValue = show(text, disableUI: disableUI)
        delay(seconds) { () -> () in
            hide(success: true, animated: false)
        }
        return showValue
    }
    
    public static func showOnController(_ text: String, disableUI: Bool, controller:UIViewController) -> Bool{
        guard instance == nil else {
            print("ULLoadingActivity: You still have an active activity, please stop that before creating a new one")
            return false
        }
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            instance?.showLoadingWithController(controller);
        }
        
        return true;
    }
    
    /// Returns success status
    @discardableResult public static func hide(success: Bool? = nil, animated: Bool = false) -> Bool {
        guard instance != nil else {
            print("ULLoadingActivity: You don't have an activity instance")
            return false
        }
        
        guard hidingInProgress == false else {
            print("ULLoadingActivity: Hiding already in progress")
            return false
        }
        
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                instance?.hideLoadingActivity(success: success, animated: animated)
            }
        } else {
            instance?.hideLoadingActivity(success: success, animated: animated)
        }
        
        return true
    }
    
    fileprivate static func delay(_ seconds: Double, after: @escaping ()->()) {
        let queue = DispatchQueue.main
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
    fileprivate class LoadingActivity: UIView {
        var textLabel: UILabel!
        var activityView: UIActivityIndicatorView!
        var icon: UILabel!
        var UIDisabled = false
        
        convenience init(text: String, disableUI: Bool) {
            self.init(frame: CGRect(x: 0, y: 0, width: Settings.ActivityWidth, height: Settings.ActivityHeight))
            center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            backgroundColor = Settings.BackgroundColor
            alpha = 1
            layer.cornerRadius = 8
            createShadow()
            
            let yPosition = frame.height/2 - 10
            
            activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityView.frame = CGRect(x: 15, y: yPosition, width: 20, height: 20)
            activityView.color = Settings.ActivityColor
            activityView.startAnimating()
            
            textLabel = UILabel(frame: CGRect(x: 60, y: yPosition-10, width: Settings.ActivityWidth - 70, height: 40))
            textLabel.textColor = Settings.TextColor
            textLabel.font = UIFont(name: Settings.FontName, size: 20)
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.text = text
            
            if disableUI {
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIDisabled = true
            }
        }
        
        func showLoadingActivity() {
            addSubview(activityView)
            addSubview(textLabel)
            
            topMostController!.view.addSubview(self)
        }
        
        func showLoadingWithController(_ controller:UIViewController){
            addSubview(activityView)
            addSubview(textLabel)
            
            controller.view.addSubview(self);
        }
        
        func createShadow() {
            layer.shadowPath = createShadowPath().cgPath
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
        }
        
        func createShadowPath() -> UIBezierPath {
            let myBezier = UIBezierPath()
            myBezier.move(to: CGPoint(x: -3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: frame.height + 3))
            myBezier.addLine(to: CGPoint(x: -3, y: frame.height + 3))
            myBezier.close()
            return myBezier
        }
        
        func hideLoadingActivity(success: Bool?, animated: Bool) {
            hidingInProgress = true
            if UIDisabled {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            var animationDuration: Double = 0
            if success != nil {
                if success! {
                    animationDuration = 0.5
                } else {
                    animationDuration = 1
                }
            }
            
            icon = UILabel(frame: CGRect(x: 10, y: frame.height/2 - 20, width: 40, height: 40))
            icon.font = UIFont(name: Settings.FontName, size: 60)
            icon.textAlignment = NSTextAlignment.center
            
            if animated {
                textLabel.fadeTransition1(animationDuration)
            }
            
            if success != nil {
                if success! {
                    icon.textColor = Settings.SuccessColor
                    icon.text = Settings.SuccessIcon
                    textLabel.text = Settings.SuccessText
                } else {
                    icon.textColor = Settings.FailColor
                    icon.text = Settings.FailIcon
                    textLabel.text = Settings.FailText
                }
            }
            
            addSubview(icon)
            
            if animated {
                icon.alpha = 0
                activityView.stopAnimating()
                UIView.animate(withDuration: animationDuration, animations: {
                    self.icon.alpha = 1
                    }, completion: { (value: Bool) in
                        self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                        instance = nil
                        hidingInProgress = false
                })
            } else {
                activityView.stopAnimating()
                self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                instance = nil
                hidingInProgress = false
            }
        }
    }
}

private extension UIView {
    /// Extension: insert view.fadeTransition right before changing content
    func fadeTransition1(_ duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionFade)
    }
}

private extension NSObject {
    func callSelectorAsync(_ selector: Selector, delay: TimeInterval) {
        let timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: selector, userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
}

private extension UIScreen {
    class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }
    class var ScreenWidth: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    class var ScreenHeight: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}

private var topMostController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let pVC = presentedVC?.presentedViewController {
        presentedVC = pVC
    }
    
    return presentedVC
}

