//
//  SettingsViewController.swift
//  GPA
//
//  Created by Rabih Mteyrek on 4/2/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyFORM
import SwiftyJSON

class SettingsViewController: FormViewController, MFMailComposeViewControllerDelegate, UIApplicationDelegate {

    let sendButton = ButtonFormItem()
    let deleteButton = ButtonFormItem()
    let configurebutton = ButtonFormItem()
    var containerView = UIView()
    var progressView = UIView()
    
    override func populate(_ builder: FormBuilder) {
        configureButtons()

        builder.navigationTitle = "Settings"//"¯\\_(  ͡•͜ʖ͡• )_/¯"
        
        builder += SectionHeaderTitleFormItem().title("Summary")
        builder += AttributedTextFormItem().title("Cumulative GPA").value(getCumulativeGPA(), [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue as AnyObject
            ])
        builder += StaticTextFormItem().title("Courses").value(String(courses.count))
        builder += StaticTextFormItem().title("Semesters").value(String(semestersListArray.count))
        builder += StaticTextFormItem().title("Credits").value(String(getTotalCreditsFinished()))
        builder += configurebutton
        
        builder += SectionHeaderTitleFormItem().title("General")
        builder += ViewControllerFormItem().title("Grades Scale").viewController(GradeScaleViewController.self)
        
         builder += ViewControllerFormItem().title("Major Info").viewController(MInfoViewController.self)
        
        /*let colorPickerCell = CustomFormItem()
        colorPickerCell.createCell = { _ in
            return try ColorPickerCell.createCell()
        }
        builder += colorPickerCell

        builder += SectionHeaderTitleFormItem().title("DropBox")*/
        
        builder += ViewControllerFormItem().title("Backup with Dropbox").viewController(DropboxViewController.self)
        builder += deleteButton
        
        builder += SectionHeaderTitleFormItem().title("Credits")
        builder += ViewControllerFormItem().title("About").viewController(ReportViewController.self)
        builder += ViewControllerFormItem().title("Open Source Licenses").viewController(OSLViewController.self)
        builder += sendButton
        
    }
    
    func configureButtons() {
        sendButton.title = "Send Feedback"
        sendButton.action = { [weak self] in
            self?.sendMail()
        }
        
        deleteButton.title = "Remove all courses"
        deleteButton.action = {
            let alert = UIAlertController(title: "Remove all courses", message: "Are you sure ?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Remove All", style: .destructive) { action in
                courses = []
                let jsonSave = ""
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let path = dir.appendingPathComponent("Courses.json")
                    do {
                        try jsonSave.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                    }
                    catch {}
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alert, animated: true)
        }
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        
        configurebutton.title = "Major Completion Progress"
        configurebutton.action = {
            ProgressAlertView.shared.showProgressView(win)
        }
    }
    
    static func platformModelString() -> String? {
        if let key = "hw.machine".cString(using: String.Encoding.utf8) {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname(key, &machine, &size, nil, 0)
            return String(cString: machine)
        }
        return nil
    }
    
    func deviceName() -> StaticTextFormItem {
        let string = ReportViewController.platformModelString() ?? "N/A"
        return StaticTextFormItem().title("Device").value(string)
    }
    
    func systemVersion() -> StaticTextFormItem {
        let string: String = UIDevice.current.systemVersion
        return StaticTextFormItem().title("iOS").value(string)
    }
    
    func appName() -> StaticTextFormItem {
        let mainBundle = Bundle.main
        let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let string1 = mainBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        let string = string0 ?? string1 ?? "Unknown"
        return StaticTextFormItem().title("Name").value(string)
    }
    
    func appVersion() -> StaticTextFormItem {
        let mainBundle = Bundle.main
        let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let string = string0 ?? "Unknown"
        return StaticTextFormItem().title("Version").value(string)
    }
    
    func appBuild() -> StaticTextFormItem {
        let mainBundle = Bundle.main
        let string0 = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        let string = string0 ?? "Unknown"
        return StaticTextFormItem().title("Build").value(string)
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mc = configuredMailComposeViewController()
            present(mc, animated: true, completion: nil)
        } else {
            form_simpleAlert("Could Not Send Mail", "Your device could not send mail. Please check mail configuration and try again.")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let emailTitle = "Report: " + appName().value + " (Version: " + appVersion().value + " Build: " + appBuild().value + ")"
        let messageBody = "Device: " + deviceName().value + " (iOS: " + systemVersion().value + ")"
        let toRecipents = ["rabihmteyrek@hotmail.com"]
        
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        return mc
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: false) { [weak self] in
            self?.showMailResultAlert(result, error: error)
        }
    }
    
    func showMailResultAlert(_ result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            form_simpleAlert("Mail Sent", "Expect to hear from us soon, Thanks for your feedback.")
        case .failed:
            form_simpleAlert("Mail failed", "error: \(String(describing: error))")
        default: break
        }
    }

}
