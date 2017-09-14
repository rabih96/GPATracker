// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM
import Accounts
import Social
import MessageUI

class ReportViewController: FormViewController, MFMailComposeViewControllerDelegate, UIApplicationDelegate {

    let followButton = ButtonFormItem()
    let sendButton = ButtonFormItem()

    override func populate(_ builder: FormBuilder) {
        configureButtons()

        builder.navigationTitle = "About"
        builder += SectionHeaderTitleFormItem().title("Developers")
        builder += StaticTextFormItem().title("Dev 1").value("Rabih Mteyrek")

        //builder += SectionHeaderTitleFormItem().title("Developer 2")
        builder += StaticTextFormItem().title("Dev 2").value("Alaa Mteyrek")
        builder += followButton


        builder += SectionHeaderTitleFormItem().title("Device info")
        builder += deviceName()
        builder += systemVersion()
        builder += SectionHeaderTitleFormItem().title("App info")
        builder += appName()
        builder += appVersion()

        builder += SectionHeaderTitleFormItem().title("Report")
        builder += sendButton

    }

    func configureButtons() {
        sendButton.title = "Send Feedback"
        sendButton.action = { [weak self] in
            self?.sendMail()
        }

        followButton.title = "Follow @rabih96"

        followButton.action = {
            let screenName = "rabih96"
            let links: [URL]
            links = [URL(string: "twitter://user?screen_name=\(screenName)")!, //Twitter
                URL(string: "tweetbot:///user_profile/\(screenName)")!, // TweetBot
                URL(string: "echofon:///user_timeline?\(screenName)")!, // Echofon
                URL(string: "twit:///user?screen_name=\(screenName)")!, // Twittelator Pro
                URL(string: "x-seesmic://twitter_profile?twitter_screen_name=\(screenName)")!, // Seesmic
                URL(string: "x-birdfeed://user?screen_name=\(screenName)")!, // Birdfeed
                URL(string: "tweetings:///user?screen_name=\(screenName)")!, // Tweetings
                URL(string: "simplytweet:?link=http://twitter.com/\(screenName)")!, // SimplyTweet
                URL(string: "icebird://user?screen_name=\(screenName)")!, // IceBird
                URL(string: "fluttr://user/\(screenName)")!, //Fluttr
                URL(string: "https://twitter.com/\(screenName)")!] //Web

            let application = UIApplication.shared

            for link in links {
                if application.canOpenURL(link) {
                    if #available(iOS 10.0, *) {
                        application.open(link, options: [:], completionHandler: nil)
                    } else {
                        application.openURL(link)
                    }
                    return
                }
            }
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

