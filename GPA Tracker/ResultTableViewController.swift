//
//  ResultTableViewController.swift
//  GPA Tracker
//
//  Created by Rabih Mteyrek on 8/8/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {

    lazy fileprivate var thinFilledProgress: RPCircularProgress = {
        let progress = RPCircularProgress()
        progress.trackTintColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 0.3)
        progress.progressTintColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        progress.thicknessRatio = 0.15
        return progress
    }()

    lazy fileprivate var thinFilledProgressTwo: RPCircularProgress = {
        let progress = RPCircularProgress()
        progress.trackTintColor = UIColor(red: 1.00, green: 0.23, blue: 0.23, alpha: 0.3)
        progress.progressTintColor = UIColor(red: 1.00, green: 0.23, blue: 0.23, alpha: 1.0)
        progress.thicknessRatio = 0.15
        return progress
    }()

    let backgroundView = UIView()
    let percentageLabel = UILabel()
    let percentageLabelTwo = UILabel()
    
    let completionLabel = UILabel()
    let cgpaLabel = UILabel()
    
    func getRadiusSize() -> Int {
        if self.tableView.frame.size.width > self.tableView.frame.size.height {
            return Int(self.tableView.frame.size.height / 3 + 5)
        } else {
            return Int(self.tableView.frame.size.width / 3 + 5)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        thinFilledProgress.center.x = (backgroundView.frame.size.width / 3) - 5
        thinFilledProgressTwo.center.x = (backgroundView.frame.size.width * 2 / 3) + 5
        
        completionLabel.center.x = thinFilledProgress.center.x
        cgpaLabel.center.x = thinFilledProgressTwo.center.x

        var percent = Float(getTotalCreditsFinished()) / userDefaults.float(forKey: "Major Total Credits")
        let percentGPA = Float(getCumulativeGPA())! / getHighestGPAGrade()

        if percent.isNaN || percent.isInfinite {
            percentageLabel.text = "0%"
            percent = 0
        } else {
            percentageLabel.text = String(format: "%.0f%%", percent * 100)
        }
        percentageLabelTwo.text = getCumulativeGPA()

        if thinFilledProgress.progress != CGFloat(percent) || thinFilledProgressTwo.progress != CGFloat(percentGPA){
            thinFilledProgress.updateProgress(CGFloat(percent), initialDelay: 0, duration: 0.75)
            thinFilledProgressTwo.updateProgress(CGFloat(percentGPA), initialDelay: 0, duration: 0.75)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var percent = Float(getTotalCreditsFinished()) / userDefaults.float(forKey: "Major Total Credits")
        if percent.isNaN || percent.isInfinite {
            percent = 0
        }
        let percentGPA = Float(getCumulativeGPA())! / getHighestGPAGrade()

        backgroundView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: (self.tableView.frame.size.width), height: CGFloat(getRadiusSize() + 75)))

        thinFilledProgress.frame = CGRect(x: 0, y: 25, width: getRadiusSize(), height: getRadiusSize())
        thinFilledProgress.updateProgress(CGFloat(percent), initialDelay: 0.25, duration: 1.5)
        thinFilledProgress.center.x = backgroundView.frame.size.width / 3

        percentageLabel.frame = CGRect(x: 0, y: 0, width: getRadiusSize(), height: getRadiusSize())
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        percentageLabel.textColor = UIColor.init(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
        thinFilledProgress.addSubview(percentageLabel)
        
        completionLabel.frame = CGRect(x: 0, y: getRadiusSize() + 40, width: getRadiusSize(), height: 20)
        completionLabel.textAlignment = .center
        completionLabel.text = "Credits"
        completionLabel.font = UIFont(name: "AppleSDGothicNeo", size: 20)
        completionLabel.center.x = thinFilledProgress.center.x
        backgroundView.addSubview(completionLabel)

        thinFilledProgressTwo.frame = CGRect(x: 0, y: 25, width: getRadiusSize(), height: getRadiusSize())
        thinFilledProgressTwo.updateProgress(CGFloat(percentGPA), initialDelay: 0, duration: 1.5)
        thinFilledProgressTwo.center.x = backgroundView.frame.size.width * 2 / 3

        percentageLabelTwo.frame = CGRect(x: 0, y: 0, width: getRadiusSize(), height: getRadiusSize())
        percentageLabelTwo.textAlignment = .center
        percentageLabelTwo.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        percentageLabelTwo.textColor = UIColor(red: 1.00, green: 0.23, blue: 0.23, alpha: 1.0)
        thinFilledProgressTwo.addSubview(percentageLabelTwo)
        
        cgpaLabel.frame = CGRect(x: 0, y: getRadiusSize() + 40, width: getRadiusSize(), height: 20)
        cgpaLabel.textAlignment = .center
        cgpaLabel.text = "CGPA"
        cgpaLabel.font = UIFont(name: "AppleSDGothicNeo", size: 20)
        cgpaLabel.center.x = thinFilledProgressTwo.center.x
        backgroundView.addSubview(cgpaLabel)

        backgroundView.addSubview(thinFilledProgress)
        backgroundView.addSubview(thinFilledProgressTwo)

        self.tableView.tableHeaderView = backgroundView

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        }else if section == 1 {
            return 2
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        //cell.isUserInteractionEnabled = false

        if indexPath.section == 0 {

            if indexPath.row == 0 {
                cell.textLabel?.text = "Courses"
                cell.detailTextLabel?.text = String(courses.count)
                return cell
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Semesters"
                cell.detailTextLabel?.text = String(semestersListArray.count)
                return cell
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Credits"
                cell.detailTextLabel?.text = String(getTotalCreditsFinished())
                return cell
            }

        } else if indexPath.section == 1 {

            if indexPath.row == 0 {
                cell.textLabel?.text = "Desired Final GPA"
                if isKeyPresentInUserDefaults(key: "Desired Cumulative GPA") {
                    cell.detailTextLabel?.text = userDefaults.string(forKey: "Desired Cumulative GPA")
                }else{
                    cell.detailTextLabel?.text = "-"
                }
                return cell
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Required Average GPA"
                if isKeyPresentInUserDefaults(key: "Desired Cumulative GPA") {
                    cell.detailTextLabel?.text = String(calculateRequiredGPA())
                }else{
                    cell.detailTextLabel?.text = "-"
                }
                return cell
            }

        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
