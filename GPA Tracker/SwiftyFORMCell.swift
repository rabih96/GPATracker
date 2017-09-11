//
//  SwiftyFORMCell.swift
//  GPA
//
//  Created by Rabih Mteyrek on 4/16/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyFORM
    
class SwiftyFORMCell: UITableViewCell, CellHeightProvider {
    
    @IBOutlet weak var licenseLabel: UILabel!
    
    static func createCell() throws -> SwiftyFORMCell {
        let cell: SwiftyFORMCell = try Bundle.main.form_loadView("SwiftyFORMCell")
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return heightForView(text: licenseLabel.text!, font: licenseLabel.font!, width: self.frame.size.width)
    }
}
