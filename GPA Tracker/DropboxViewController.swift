//
//  DropboxViewController.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 4/19/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxViewController: UITableViewController {

    func updateCells() -> Void {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.download(path: "/Courses-Backup.json").response { response, error in
                for cell in self.tableView.visibleCells {
                    let indexPath = self.tableView.indexPath(for: cell)
                    if indexPath?.section == 0 && indexPath?.row == 0 {
                        let dbCell = cell as! DropboxUserCell
                        if let dateEdited = response?.0.clientModified {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEE, MMM d yyyy, h:mm a"
                            let dateString = dateFormatter.string(from: dateEdited)
                            dbCell.backupTime.text = "Last backup: " + dateString
                        } else {
                            dbCell.backupTime.text = "Last backup: Never"
                        }
                    } else if indexPath?.section == 1 {
                        if indexPath?.row == 0 && courses.count > 0 {
                            cell.selectionStyle = .default
                            cell.textLabel?.isEnabled = true
                        } else if indexPath?.row == 1 && response?.1 != nil {
                            cell.selectionStyle = .default
                            cell.textLabel?.isEnabled = true
                        }
                    } else if indexPath?.section == 2 {
                        cell.selectionStyle = .default
                        cell.textLabel?.isEnabled = true
                        cell.textLabel?.textColor = UIColor.white
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.title = "Dropbox Backup"
        self.tableView.isScrollEnabled = true

        updateCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if DropboxClientsManager.authorizedClient != nil {
            return 3
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DropboxClientsManager.authorizedClient != nil {
            switch section {
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return 1
            default:
                return 0
            }
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("DropboxUserCell", owner: self, options: nil)?.first as! DropboxUserCell
            cell.isUserInteractionEnabled = false
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        cell.textLabel?.isEnabled = false

        if DropboxClientsManager.authorizedClient != nil {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Backup"
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "Restore from backup"
                }
            } else if indexPath.section == 2 {
                cell.textLabel?.text = "Sign out"
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.init(red: 1, green: 0.3, blue: 0.3, alpha: 1)
            }
        } else {
            cell.textLabel?.text = "Sign in"
            cell.selectionStyle = .default
            cell.textLabel?.isEnabled = true
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.init(red: 88 / 255, green: 173 / 255, blue: 247 / 255, alpha: 1)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let client = DropboxClientsManager.authorizedClient {
            if tableView.cellForRow(at: indexPath)?.textLabel?.text == "Sign out" {
                DropboxClientsManager.unlinkClients()
                _ = navigationController?.popViewController(animated: true)
            } else if tableView.cellForRow(at: indexPath)?.textLabel?.text == "Backup" {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                    let coursesFile = dir.appendingPathComponent("Courses.json")
                    LoadingIndicatorView.shared.showProgressView(view)
                    do {
                        let data = try Data(contentsOf: coursesFile)
                        client.files.upload(path: "/Courses-Backup.json", mode: Files.WriteMode.overwrite, autorename: false, clientModified: nil, mute: true, input: data).response { response, error in
                            if let response = response {
                                print(response)
                            } else if let error = error {
                                print(error)
                            }
                        }.progress { progressData in
                            if progressData.completedUnitCount == progressData.totalUnitCount {
                                LoadingIndicatorView.shared.hideProgressView()
                                self.updateCells()
                            }
                        }
                    } catch { }

                }
            } else if tableView.cellForRow(at: indexPath)?.textLabel?.text == "Restore from backup" {
                LoadingIndicatorView.shared.showProgressView(view)
                if courses.count == 0 {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        do {
                            try "Hi".write(to: dir.appendingPathComponent("Courses.json"), atomically: false, encoding: String.Encoding.utf8)
                        } catch { }
                    }
                }
                client.files.download(path: "/Courses-Backup.json").response { response, error in
                    if let response = response {
                        let responseMetadata = response.0
                        print(responseMetadata)
                        let fileContents = response.1
                        print(fileContents)

                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                            let coursesFile = dir.appendingPathComponent("Courses.json")
                            do {
                                let file = try FileHandle.init(forWritingTo: coursesFile)
                                file.write(fileContents)
                                print("JSON data was written to the file successfully!")
                                courses = []
                                getCoursesArrayFromJSON()
                                if !courses.isEmpty { sortCourses() }
                                LoadingIndicatorView.shared.hideProgressView()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                                _ = self.navigationController?.popViewController(animated: true)
                            } catch let error as NSError {
                                print("Couldn't write to file: \(error.localizedDescription)")
                                LoadingIndicatorView.shared.hideProgressView()
                            }
                        }

                    } else if let error = error {
                        print(error)
                        LoadingIndicatorView.shared.hideProgressView()
                    }
                }.progress { progressData in
                    if progressData.completedUnitCount == progressData.totalUnitCount {
                        LoadingIndicatorView.shared.hideProgressView()
                    }
                }
            }
        } else {
            if tableView.cellForRow(at: indexPath)?.textLabel?.text == "Sign in" {
                DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { (url: URL) -> Void in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: { (done: Bool) -> Void in
                            if done {
                                self.tableView.deselectRow(at: indexPath, animated: true)
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        if UIApplication.shared.openURL(url) {
                            self.tableView.deselectRow(at: indexPath, animated: true)
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
