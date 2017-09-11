//
//  ColorPickerCell.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 4/23/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyFORM

let colors = [UIColor.white, UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), UIColor.blue, UIColor.black, UIColor.brown, UIColor.orange, UIColor.yellow, UIColor.cyan, UIColor.green, UIColor.white]

class ColorPickerCell: UITableViewCell, CellHeightProvider, EJVColorPickerDelegate {
    
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var myColorPicker: EJVColorPicker!
    
    static func createCell() throws -> ColorPickerCell {
        let cell: ColorPickerCell = try Bundle.main.form_loadView("ColorPickerCell")
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myColorPicker.delegate = self
        myColorPicker.colors = colors
        
    }
    
    func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 40
    }
    
    func colorPicker(_ view: EJVColorPicker, didSelect color: UIColor) {
        ThemeManager.applyTheme(Theme(rawValue: colors.index(of: color)!)!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }

}
