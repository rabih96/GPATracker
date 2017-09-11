//
//  CourseTableViewCell.swift
//  GPA
//
//  Created by Rabih Mteyrek on 3/25/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit

protocol CourseTableViewCellDelegate: class {
}

class CourseTableViewCell: UITableViewCell {

    var delegate: CourseTableViewCellDelegate?
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var gradeTitleLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    
    weak var course: Course!

    override func awakeFromNib() {
        gradeTitleLabel.baselineAdjustment = .alignCenters
        gradeTitleLabel.backgroundColor = ThemeManager.currentTheme().color//UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        gradeTitleLabel.layer.cornerRadius = 7.5
        gradeTitleLabel.textColor = UIColor.white
        gradeTitleLabel.layer.masksToBounds = true
    }
    
}
