// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM
import Accounts
import Social

class ReportViewController: FormViewController {
    
    let followButton = ButtonFormItem()

	override func populate(_ builder: FormBuilder) {
        configureButtons()
        
		builder.navigationTitle = "About"
        builder += SectionHeaderTitleFormItem().title("Developer 1")
        builder += StaticTextFormItem().title("Name").value("Rabih Mteyrek")
        builder += followButton

        builder += SectionHeaderTitleFormItem().title("Developer 2")
        builder += StaticTextFormItem().title("Name").value("Alaa Mteyrek")

		builder += SectionHeaderTitleFormItem().title("Device info")
		builder += deviceName()
		builder += systemVersion()
		builder += SectionHeaderTitleFormItem().title("App info")
		builder += appName()
		builder += appVersion()
	}
    
    func configureButtons() {
        followButton.title = "Follow me on Twitter  @rabih96"
        
        followButton.action = {
            let screenName =  "rabih96"
            let links:[URL]
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
                    application.open(link, options: [:], completionHandler: nil)
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
}

