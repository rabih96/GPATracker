//
//  SettingsController.swift
//  GPA Tracker
//
//  Created by Rabih Mteyrek on 7/2/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteAll(_ sender: Any) {
        let alert = UIAlertController(title: "Remove all courses", message: "Are you sure ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove All", style: .destructive) { action in
            courses = []
            let jsonSave = ""
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = dir.appendingPathComponent("Courses.json")
                do {
                    try jsonSave.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch { }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true)
    }

}
