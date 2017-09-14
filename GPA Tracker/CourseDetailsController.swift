//
//  CourseDetailsController.swift
//  GPA
//
//  Created by Rabih Mteyrek on 3/29/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyFORM
import SwiftyJSON

class CourseDetailsController: FormViewController {

    var courseDetails: Course!

    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(checkSaving(_:)))
    }

    public func checkSaving(_ sender: AnyObject?) {
        formBuilder.validateAndUpdateUI()
        let result = formBuilder.validate()
        save(result)
    }

    public func checkIfCourseExists(courseToCheck: Course) -> Bool {
        for courseInCourses in courses {
            if courseToCheck.name == courseInCourses.name &&
                courseToCheck.semester == courseInCourses.semester &&
                courseToCheck.year == courseInCourses.year &&
                courseToCheck.grade == courseInCourses.grade &&
                courseToCheck.credits == courseInCourses.credits {
                return true
            }
        }
        return false
    }

    func saveAndExit() -> Void {
        saveCoursesToJSON()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }

    public func save(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:

            let newCourse = Course(name: courseName.value, grade: gradesArray[gradePicker.value[0]], credits: NSInteger(courseCredits.value)!, semester: semestersArray[semesterPicker.value[0]], year: NSInteger(yearsArray[semesterPicker.value[1]])!)

            if courseDetails != nil {

                if !(courseDetails.credits == newCourse.credits && courseDetails.name == newCourse.name && courseDetails.semester == newCourse.semester && courseDetails.year == newCourse.year && courseDetails.grade == newCourse.grade) {

                    if checkIfCourseExists(courseToCheck: newCourse) == false {

                        courses.remove(at: courses.index(of: courseDetails)!)
                        courses.append(newCourse)
                        saveAndExit()

                    } else {
                        form_simpleAlert("Error 01", "Course already exist " + newCourse.semester + " " + String(newCourse.year))
                    }

                } else {
                    _ = navigationController?.popViewController(animated: true)
                }

            } else {
                if checkIfCourseExists(courseToCheck: newCourse) {
                    form_simpleAlert("Error 02", "Course already exist")
                } else {
                    courses.append(newCourse)
                    saveAndExit()
                }
            }

        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Error"
            form_simpleAlert(title, message)
        }
    }

    /// Views

    override func populate(_ builder: FormBuilder) {
        if courseDetails == nil {
            builder.navigationTitle = "New Course"
            semesterPicker.value = [semestersArray.index(of: "Fall")!, yearsArray.index(of: String(currentYear))!]
        } else {
            builder.navigationTitle = courseDetails.name

            courseName.value = courseDetails.name
            gradePicker.value = [gradesArray.index(of: courseDetails.grade)!]
            semesterPicker.value = [semestersArray.index(of: courseDetails.semester)!, yearsArray.index(of: String(courseDetails.year))!]
            courseCredits.value = String(courseDetails.credits)
        }

        builder += SectionHeaderTitleFormItem().title("General")
        builder += courseName
        builder += courseCredits
        builder += gradePicker
        builder += semesterPicker

        /*builder += SectionHeaderTitleFormItem().title("debug")

        builder += summary
        builder += jsonButton
        
        builder.alignLeftElementsWithClass("textFields")
        
        updateSummary()*/
    }

    lazy var courseName: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Name")
        instance.placeholder("Name")
        instance.keyboardType = .asciiCapable
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(1), message: "Enter course name")
        instance.submitValidate(CountSpecification.min(2), message: "Length must be minimum 2 characters")
        instance.validate(CountSpecification.max(30), message: "Length must be maximum 30 characters")
        return instance
    }()

    lazy var courseCredits: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Credits")
        instance.placeholder("Credits")
        instance.keyboardType = .numberPad
        instance.styleClass("textFields")
        instance.autocorrectionType = .no
        instance.validate(CharacterSetSpecification.decimalDigits, message: "Only decimals are accepted as input")
        instance.submitValidate(CountSpecification.min(1), message: "Enter the credits value")
        instance.validate(CountSpecification.max(2), message: "Length must be maximum 2 numbers")
        return instance
    }()

    lazy var gradePicker: PickerViewFormItem = {
        let instance = PickerViewFormItem().title("Grade")
        instance.pickerTitles = [gradesArray]
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateSummary()
        }
        return instance
    }()

    lazy var semesterPicker: PickerViewFormItem = {
        let instance = PickerViewFormItem().title("Semester")
        instance.pickerTitles = [semestersArray, yearsArray]
        instance.humanReadableValueSeparator = " : "
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateSummary()
        }
        return instance
    }()

    lazy var summary: StaticTextFormItem = {
        return StaticTextFormItem().title("Values").value("-")
    }()

    func updateSummary() {
        let v0 = courseName.value
        let v1 = courseCredits.value
        let v2 = gradesArray[gradePicker.value[0]]
        let v3 = semestersArray[semesterPicker.value[0]]
        let v4 = yearsArray[semesterPicker.value[1]]
        summary.value = "\(v0) , \(v1) , \(v2) , \(v3) , \(v4)"
    }

    lazy var jsonButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "View JSON Data"
        instance.action = { [weak self] in
            if let vc = self {
                DebugViewController.showJSON(vc, jsonData: vc.formBuilder.dump())
            }
        }
        return instance
    }()

}
