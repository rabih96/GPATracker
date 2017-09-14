//
//  CoursesTableViewController.swift
//  GPA
//
//  Created by Rabih Mteyrek on 3/23/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//


//
// TODO:
//
//  Add an undo feature: a drop view from navigation bar with undo delete and an X button.
//
//

import UIKit
import SwiftyJSON
//import GoogleMobileAds
//import AudioToolbox
import SwiftRater

var valueToPass         : Course!
var justDeletedCourse   : Course!
var coursesInSections           = 0
var filteredSearch              = [Course]()
var semestersListArray:[String] = []
var repeated                    = 6
//var bannerView                  = GADBannerView()

class CoursesTableViewController: UITableViewController/*, GADBannerViewDelegate*/ {

    @IBOutlet var semestersTable: UITableView!
    @IBOutlet weak var cgpaLabel: UILabel!
    @IBOutlet weak var gpaTitleLabel: UILabel!
    @IBOutlet weak var thePlusButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: CourseDetailsController? = nil
    
    func reloadTitle() -> Void {
        cgpaLabel.text = "CGPA : " + getCumulativeGPA()
    }
    
    func loadList(){
        sortCourses()
        reloadTitle()
        semestersTable.reloadData()
    }
    
    func animateIn() -> Void {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.thePlusButton.tintColor = UIColor.green
        }, completion: { (finished: Bool) in
            self.animateOut()
        })
    }
    
    func animateOut() -> Void {
        UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.thePlusButton.tintColor = UIColor.white
        }, completion: { (finished: Bool) in
            if repeated > 0 {
                repeated -= 1
                self.animateIn()
            }
        })
    }
    
    /*override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let window = UIApplication.shared.delegate!.window!!
        let viewWidth = window.frame.size.width
        let ySpacing  = window.frame.size.height - 50 - (self.navigationController?.toolbar.frame.height)!
        
        bannerView.frame = CGRect(x: 0, y: ySpacing, width: viewWidth, height: 50)
        bannerView.center.x = window.center.x
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true

        /*let window = UIApplication.shared.delegate!.window!!
        let viewWidth = window.frame.size.width
        let ySpacing  = window.frame.size.height - 50 - (self.navigationController?.toolbar.frame.height)!
        
        bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: viewWidth, height: 50)))
        bannerView.frame = CGRect(x: 0, y: ySpacing, width: viewWidth, height: 50)
        bannerView.center.x = window.center.x
        window.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())*/
        
        if self.tableView.contentOffset.y == 0 {
            self.tableView.contentOffset = CGPoint(x: 0.0, y: searchController.searchBar.frame.size.height)
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        semestersTable.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchBarStyle = .minimal
        
        reloadTitle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTitle()
        valueToPass = nil
        
        if semestersListArray.count == 0 {
            animateIn()
        }
        
        //semestersTable.frame = CGRect(x: semestersTable.frame.origin.x, y: semestersTable.frame.origin.y, width: semestersTable.frame.size.width, height: semestersTable.frame.size.height - 50)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        reloadTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        
        if semestersListArray.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No courses available\n\nPress the + icon to add your courses"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.numberOfLines = 3
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            searchController.searchBar.isHidden = true
            return 0
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            searchController.searchBar.isHidden = false
            return semestersListArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSearch.count
        }
        
        var coursesInSemester = 0

        if courses.count > 0 {
            for course in courses{
                if course.semester+String(course.year) == semestersListArray[section] {
                    coursesInSemester += 1
                }
            }
        }
        
        return coursesInSemester
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CourseTableViewCell", owner: self, options: nil)?.first as! CourseTableViewCell
        
        var coursesArray:[Course] = []
        
        for course in courses {
            if course.semester+String(course.year) == semestersListArray[indexPath.section] {
                if !course.semester.isEmpty {
                    coursesArray.append(course)
                }
            }
        }
        
        coursesArray.sort { (c1, c2) -> Bool in
            if c1.name > c2.name {
                return false
            }else{
                return true
            }
        }
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.course = filteredSearch[indexPath.row]
            cell.courseTitleLabel?.text = filteredSearch[indexPath.row].name
            cell.gradeTitleLabel?.text = filteredSearch[indexPath.row].grade + "  " + String(format:"%.2f", gradeToValue(filteredSearch[indexPath.row].grade))
            cell.creditsLabel?.text = String(filteredSearch[indexPath.row].credits) + " credits"
        } else {
            
            var spaces = "  "
            
            if ( coursesArray[indexPath.row].grade == "A" || coursesArray[indexPath.row].grade == "B" || coursesArray[indexPath.row].grade == "C" || coursesArray[indexPath.row].grade == "D" || coursesArray[indexPath.row].grade == "F" ){
                spaces = "   "
            }
            
            cell.course = coursesArray[indexPath.row]
            cell.courseTitleLabel?.text = coursesArray[indexPath.row].name
            cell.gradeTitleLabel?.text = coursesArray[indexPath.row].grade + spaces + String(format:"%.2f", gradeToValue(coursesArray[indexPath.row].grade))
            cell.creditsLabel?.text = String(coursesArray[indexPath.row].credits) + " credits"
            self.tableView.footerView(forSection: indexPath.section)?.textLabel?.textAlignment = NSTextAlignment.center
        }
        
        let customview = UIView()
        customview.frame = CGRect(x: 5, y: 32.5, width: 10, height: 10)
        customview.backgroundColor = getSemesterColor(semester: cell.course.semester)//.random()
        customview.layer.cornerRadius = 5
        customview.layer.masksToBounds = true
        //cell.addSubview(customview)
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive && searchController.searchBar.text != "" {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        valueToPass = (tableView.cellForRow(at: indexPath!) as! CourseTableViewCell).course
        performSegue(withIdentifier: "showCourseDetails", sender: nil)
        
        tableView.deselectRow(at: indexPath!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }
        
        if tableView.numberOfRows(inSection: section) == 0 {
            return nil
        }
        
        var semestersYearArray: [String] = []

        for course in courses {
            if !course.semester.isEmpty {
                if !semestersYearArray.contains(course.semester + " " + String(course.year)) {
                    semestersYearArray.append(course.semester + " " + String(course.year))
                }
            }
        }

        var sms: [String] = []
        var zmz: [Course] = []

        for course in courses {
            if (course.semester + " " + String(course.year)) == semestersYearArray[section] {
                if !sms.contains(course.name) {
                    sms.append(course.name)
                    zmz.append(course)
                }
            }
        }

        var semesterGPA: Float = 0.0
        var semesterCredits = 0

        for c in zmz {
            semesterCredits += c.credits
        }

        for c in zmz {
            semesterGPA += (Float(c.credits) / Float(semesterCredits)) * gradeToValue(c.grade)
        }

        let headerView = UIView()

        let semesterLabel = UILabel()
        semesterLabel.frame = CGRect(x: 15, y: 2.5, width: 150, height: 30)
        semesterLabel.text = semestersYearArray[section]
        semesterLabel.textAlignment = .left
        semesterLabel.font = UIFont(name: "Avenir", size: 15)
        headerView.addSubview(semesterLabel)

        let gpaLabel = UILabel()
        gpaLabel.frame = CGRect(x: (tableView.tableHeaderView?.frame.size.width)! - 200, y: 2.5, width: 185, height: 30)
        gpaLabel.text = "GPA: " + String(format: "%.2f", semesterGPA) + " - " + String(semesterCredits) + " credits"
        gpaLabel.textAlignment = .right
        gpaLabel.font = UIFont(name: "Avenir", size: 15)
        headerView.addSubview(gpaLabel)
        
        //semesterLabel.backgroundColor = getSemesterColor(semester: semestersYearArray[section].components(separatedBy: " ")[0])
        //semesterLabel.layer.cornerRadius = 7.5
        //semesterLabel.layer.masksToBounds = true
        //headerView.backgroundColor = getSemesterColor(semester: semestersYearArray[section].components(separatedBy: " ")[0])
        //headerView.layer.cornerRadius = 0
        //headerView.layer.masksToBounds = true
        
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 20
        }
        return 35
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let cellIndex = tableView.cellForRow(at: indexPath) as! CourseTableViewCell
            
            UndoView.shared.showUndoViewForCourse(courseName: cellIndex.courseTitleLabel.text!)

            for currentCourse in courses {
                if currentCourse.name == cellIndex.courseTitleLabel?.text {
                    let index = courses.index(where: { (item) -> Bool in
                        (item.name == currentCourse.name) && (item.credits == currentCourse.credits) && (item.semester == currentCourse.semester) && (item.year == currentCourse.year)
                    })
                    justDeletedCourse = courses[index!]
                    courses.remove(at: index!)
                }
            }
            
            var customData = [JSON]()
            
            for c in courses {
                customData.append(JSON(["name":c.name, "grade": c.grade, "credits": c.credits, "semester": c.semester, "year": c.year]))
            }
            
            let jsonSave = customData.description
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let path = dir.appendingPathComponent("Courses.json")
                
                do {
                    try jsonSave.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {}
            }
            
            reloadTitle()
            
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                let indexSet = IndexSet(integer: indexPath.section)
                super.tableView.deleteSections(indexSet , with: .automatic)
            }else{
                tableView.deleteRows(at: [indexPath], with: .automatic)
                super.tableView( tableView, viewForHeaderInSection: indexPath.section)
            }
            
            //Hackiest hack in the hacking world. This is digusting. 0.175s seems to be the ideal time interval to reload the table.
            super.tableView.perform(#selector(super.tableView.reloadData), with: nil, afterDelay: 0.175)
            
            /*DispatchQueue.main.async {
                //tableView.beginUpdates()
                //let sectionIndex = IndexSet(integer: indexPath.section)
                //tableView.reloadSections(sectionIndex, with: UITableViewRowAnimation.left)
                //super.tableView(tableView, viewForHeaderInSection: indexPath.section)
                //tableView.endUpdates()
                
                //UIView.performWithoutAnimation {
                //    tableView.reloadData()
                //}
            }*/
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete Course"
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCourseDetails" {
            let viewController = segue.destination as! CourseDetailsController
            viewController.courseDetails = valueToPass
        }else if segue.identifier == "newCourse" {
            let viewController = segue.destination as! CourseDetailsController
            viewController.courseDetails = nil
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSearch = courses.filter({( course : Course) -> Bool in
            return course.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

}

extension CoursesTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension CoursesTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
