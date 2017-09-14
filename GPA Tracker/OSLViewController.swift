//
//  OSLViewController.swift
//  GPA
//
//  Created by Rabih Mteyrek on 4/14/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyFORM

class OSLViewController: FormViewController {

    let swiftyFORMHeaderView = SectionHeaderViewFormItem()
    let swiftyJSONHeaderView = SectionHeaderViewFormItem()
    let rPCircularProgressHeaderView = SectionHeaderViewFormItem()
    let swiftRATERHeaderView = SectionHeaderViewFormItem()
    let swiftyDBHeaderView = SectionHeaderViewFormItem()
    let alomofireHeaderView = SectionHeaderViewFormItem()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func populate(_ builder: FormBuilder) {

        configureHeaderViews()

        builder.navigationTitle = "Acknowledgements"

        builder += swiftyDBHeaderView
        let swiftyDBCell = CustomFormItem()
        swiftyDBCell.createCell = { _ in
            return try SwiftyDropboxCell.createCell()
        }
        builder += swiftyDBCell

        builder += swiftyFORMHeaderView
        let swiftyFORMCell = CustomFormItem()
        swiftyFORMCell.createCell = { _ in
            return try SwiftyFORMCell.createCell()
        }
        builder += swiftyFORMCell

        builder += swiftyJSONHeaderView
        let swiftyJSONCell = CustomFormItem()
        swiftyJSONCell.createCell = { _ in
            return try SwiftyJSONCell.createCell()
        }
        builder += swiftyJSONCell

        builder += rPCircularProgressHeaderView
        let rPCircularProgressCell = CustomFormItem()
        rPCircularProgressCell.createCell = { _ in
            return try RPCircularProgressCell.createCell()
        }
        builder += rPCircularProgressCell

        builder += alomofireHeaderView
        let alamofireCell = CustomFormItem()
        alamofireCell.createCell = { _ in
            return try AlamofireCell.createCell()
        }
        builder += alamofireCell

        builder += swiftRATERHeaderView
        let swiftRATERCell = CustomFormItem()
        swiftRATERCell.createCell = { _ in
            return try SwiftRaterCell.createCell()
        }
        builder += swiftRATERCell

    }

    func configureHeaderViews() {

        swiftyDBHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "SwiftyDropbox")
        }

        swiftyFORMHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "SwiftyFORM")
        }

        swiftyJSONHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "SwiftyJSON")
        }

        rPCircularProgressHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "RPCircularProgress")
        }

        swiftRATERHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "SwiftRater")
        }

        alomofireHeaderView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), text: "Alamofire")
        }
    }
}
