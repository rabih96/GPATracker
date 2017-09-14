//
//  MInfoViewController.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 6/19/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import Foundation
import SwiftyFORM

class MInfoViewController: FormViewController {

    var userDefaults = UserDefaults.standard

    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(checkSaving(_:)))
    }

    public func checkSaving(_ sender: AnyObject?) {
        formBuilder.validateAndUpdateUI()
        let result = formBuilder.validate()
        save(result)
    }

    public func save(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:

            userDefaults.setValue(Float(MajorName.value), forKey: "Desired Cumulative GPA")
            userDefaults.setValue(Int(MajorCredits.value), forKey: "Major Total Credits")
            userDefaults.synchronize()

            _ = navigationController?.popViewController(animated: true)

            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Error"
            form_simpleAlert(title, message)
        }
    }

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Major Info"
        builder.toolbarMode = .simple

        builder += MajorName
        builder += MajorCredits

    }

    lazy var MajorName: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Desired Cumulative GPA")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(Int(getLowestGPAGrade())), message: "Minimum input number restriction")

        if let valueOfKey = UserDefaults.standard.value(forKey: instance.title) {
            instance.value = self.userDefaults.string(forKey: instance.title)!
        } else {
            instance.value = ""
        }

        return instance
    }()

    lazy var MajorCredits: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Major Total Credits")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the major credits")

        if let valueOfKey = UserDefaults.standard.value(forKey: instance.title) {
            instance.value = String(self.userDefaults.integer(forKey: instance.title))
        }

        return instance
    }()


}
