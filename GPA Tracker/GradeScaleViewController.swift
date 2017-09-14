//
//  GradeScaleViewController.swift
//  GPA
//
//  Created by Rabih Mteyrek on 4/7/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyFORM

class GradeScaleViewController: FormViewController {

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

            let userDefaults = UserDefaults.standard
            userDefaults.setValue(Float(scaleAPlus.value), forKey: "A+")
            userDefaults.setValue(Float(scaleA.value), forKey: "A")
            userDefaults.setValue(Float(scaleAMinus.value), forKey: "A-")
            userDefaults.setValue(Float(scaleBPlus.value), forKey: "B+")
            userDefaults.setValue(Float(scaleB.value), forKey: "B")
            userDefaults.setValue(Float(scaleBMinus.value), forKey: "B-")
            userDefaults.setValue(Float(scaleCPlus.value), forKey: "C+")
            userDefaults.setValue(Float(scaleC.value), forKey: "C")
            userDefaults.setValue(Float(scaleCMinus.value), forKey: "C-")
            userDefaults.setValue(Float(scaleDPlus.value), forKey: "D+")
            userDefaults.setValue(Float(scaleD.value), forKey: "D")
            userDefaults.setValue(Float(scaleDMinus.value), forKey: "D-")
            userDefaults.setValue(Float(scaleF.value), forKey: "F")
            userDefaults.synchronize()

            _ = navigationController?.popViewController(animated: true)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Error"
            form_simpleAlert(title, message)
        }
    }

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Grades Scale"
        builder.toolbarMode = .simple

        builder += scaleAPlus
        builder += scaleA
        builder += scaleAMinus

        builder += scaleBPlus
        builder += scaleB
        builder += scaleBMinus

        builder += scaleCPlus
        builder += scaleC
        builder += scaleCMinus

        builder += scaleDPlus
        builder += scaleD
        builder += scaleDMinus

        builder += scaleF

    }

    lazy var scaleAPlus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("A+")
        instance.placeholder("4.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if let valueOfKey = UserDefaults.standard.value(forKey: instance.title) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleBPlus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("B+")
        instance.placeholder("3.33")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleCPlus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("C+")
        instance.placeholder("2.33")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleDPlus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("D+")
        instance.placeholder("1.33")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleA: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("A")
        instance.placeholder("4.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleB: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("B")
        instance.placeholder("3.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleC: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("C")
        instance.placeholder("2.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleD: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("D")
        instance.placeholder("1.33")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")

        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }

        return instance
    }()

    lazy var scaleAMinus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("A-")
        instance.placeholder("3.67")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")
        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }
        return instance
    }()

    lazy var scaleBMinus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("B-")
        instance.placeholder("2.67")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")
        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }
        return instance
    }()

    lazy var scaleCMinus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("C-")
        instance.placeholder("1.67")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")
        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }
        return instance
    }()

    lazy var scaleDMinus: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("D-")
        instance.placeholder("1.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")
        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder) && self.userDefaults.float(forKey: instance.title) != 0.0) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }
        return instance
    }()

    lazy var scaleF: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("F")
        instance.placeholder("0.00")
        instance.keyboardType = .decimalPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter the scale value")
        instance.validate(CountSpecification.max(4), message: "Length must be maximum 3 digits")
        if (self.userDefaults.float(forKey: instance.title) != Float(instance.placeholder)) {
            instance.value = String(format: "%.2f", self.userDefaults.float(forKey: instance.title))
        } else {
            instance.value = instance.placeholder
        }
        return instance
    }()
}
