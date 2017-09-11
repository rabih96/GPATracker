//
//  ProgressAlertView.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 6/19/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import Foundation
import UIKit

open class ProgressAlertView {
    
    var containerView = RadialGradientView()
    var alertTitle = UILabel()
    var progressView = UIView()
    var percentageLabel = UILabel()
    var majorName = UILabel()
    var majorCredits = UILabel()
    var totalCredits = UILabel()
    var doneButton = UIButton()
    
    lazy fileprivate var thinFilledProgress: RPCircularProgress = {
        let progress = RPCircularProgress()
        progress.trackTintColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 0.3)
        progress.progressTintColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        progress.thicknessRatio = 0.15
        return progress
    }()
    
    open class var shared: ProgressAlertView {
        struct Static {
            static let instance: ProgressAlertView = ProgressAlertView()
        }
        return Static.instance
    }
    
    open func showProgressView(_ view: UIView) {
        
        let percent = Float(getTotalCreditsFinished())/userDefaults.float(forKey: "Major Total Credits")
        
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hideProgressView))
        //let gesture2 = UITapGestureRecognizer(target: self, action:  nil)

        containerView.frame = view.frame
        containerView.center = view.center
        //containerView.backgroundColor = UIColor.init(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 0.95)//UIColor(HEX: 0xffffff, alpha: 0.3)
        //containerView.addGestureRecognizer(gesture)
        containerView.colors = [UIColor.init(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.85), UIColor.init(red: 0.65, green: 0.65, blue: 0.65, alpha: 0.85)]

        
        progressView.frame = CGRect(x: 0, y: 0, width: 300, height: 370)
        progressView.center = view.center
        progressView.backgroundColor = UIColor.init(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)//UIColor(HEX: 0x444444, alpha: 0.95)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        //progressView.addGestureRecognizer(gesture2)
        
        alertTitle.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        alertTitle.text = "Major Stats"
        alertTitle.textAlignment = .center
        alertTitle.font = UIFont.boldSystemFont(ofSize: 18)
        alertTitle.textColor = .black
        progressView.addSubview(alertTitle)
        
        thinFilledProgress.frame = CGRect(x: progressView.frame.size.width/2 - 70, y: 65, width: 140, height: 140)
        thinFilledProgress.updateProgress(CGFloat(percent), initialDelay: 0.25, duration: 1.5)

        percentageLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        percentageLabel.text = String(format: "%.0f%%", percent*100)
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        percentageLabel.textColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        thinFilledProgress.addSubview(percentageLabel)
        
        majorName.frame = CGRect(x: 15, y: 215, width: 280, height: 30)
        majorName.text = "Major Name : " + userDefaults.string(forKey: "Major Name")!
        majorName.font = UIFont.systemFont(ofSize: 16)
        majorName.textColor = .black
        majorName.textAlignment = .center
        progressView.addSubview(majorName)
        
        majorCredits.frame = CGRect(x: 15, y: 245, width: 280, height: 30)
        majorCredits.text = "Earned Credits : " + String(getTotalCreditsFinished())
        majorCredits.font = UIFont.systemFont(ofSize: 16)
        majorCredits.textColor = .black
        majorCredits.textAlignment = .center
        progressView.addSubview(majorCredits)
        
        totalCredits.frame = CGRect(x: 15, y: 275, width: 280, height: 30)
        totalCredits.text = "Total Credits : " + userDefaults.string(forKey: "Major Total Credits")!
        totalCredits.font = UIFont.systemFont(ofSize: 16)
        totalCredits.textColor = .black
        totalCredits.textAlignment = .center
        progressView.addSubview(totalCredits)
        
        doneButton.frame = CGRect(x: -1, y: 315, width: 302, height: 56)
        doneButton.setTitleColor(UIColor.init(red: 21 / 255, green: 119 / 255, blue: 255 / 255, alpha: 1) , for: .normal)
        doneButton.setBackgroundColor(color: UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0), forState: .highlighted)
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel!.font =  UIFont.boldSystemFont(ofSize: 18)
        doneButton.addTarget(self, action:#selector(hideProgressView), for: .touchUpInside)
        doneButton.layer.borderWidth = 0.5
        doneButton.layer.borderColor = UIColor.lightGray.cgColor
        progressView.addSubview(doneButton)
        
        progressView.addSubview(thinFilledProgress)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
    }
    
    @objc open func hideProgressView() {
        containerView.removeFromSuperview()
        thinFilledProgress.updateProgress(0.0)
    }
}
