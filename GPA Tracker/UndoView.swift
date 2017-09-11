//
//  UndoView.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 5/6/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import Foundation
import UIKit

public class UndoView: UIView {
    
    var containerView = UIView()
    var undoButton = UIButton()
    var fuckingTimer = Timer()
    
    private let APP_WINDOW: UIWindow = UIApplication.shared.delegate!.window!!

    open class var shared: UndoView {
        struct Static {
            static let instance: UndoView = UndoView()
        }
        return Static.instance
    }
    
    open func showUndoViewForCourse(courseName: String) {
        
        fuckingTimer.invalidate()
        
        let viewWidth = (APP_WINDOW.frame.size.width - 150)/2
        let height  = APP_WINDOW.frame.size.height
        
        containerView.frame = CGRect(x: viewWidth, y: height, width: 150, height: 40)
        containerView.backgroundColor = UIColor(red:0.89, green:0.30, blue:0.30, alpha:1)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.red.cgColor
        
        undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        undoButton.setTitle("Undo Delete", for: .normal)
        undoButton.setTitleColor(.white, for: .normal)
        undoButton.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Light", size: 15)
        undoButton.backgroundColor = .clear
        undoButton.layer.borderWidth = 0
        undoButton.layer.borderColor = UIColor.white.cgColor
        undoButton.addTarget(self, action: #selector(undoDelete), for: .touchUpInside)
        containerView.addSubview(undoButton)
        
        APP_WINDOW.addSubview(containerView)
        APP_WINDOW.windowLevel = UIWindowLevelStatusBar - 1
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.frame = CGRect(x: viewWidth, y: height - 80, width: 150, height: 40)
        }
        
        fuckingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
    }
    
    func undoDelete() {
        courses.append(justDeletedCourse)
        saveCoursesToJSON()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        hideView()
    }
    
    func hideView() {

        let viewWidth = (APP_WINDOW.frame.size.width - 150)/2
        let height  = APP_WINDOW.frame.size.height
        
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.frame = CGRect(x: viewWidth, y: height, width: 150, height: 40)
        }) { (done) in
            self.containerView.removeFromSuperview()
            justDeletedCourse = nil
        }
        
    }
}
