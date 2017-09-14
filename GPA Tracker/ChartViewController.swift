//
//  ChartViewController.swift
//  GPA Tracker
//
//  Created by Rabih Mteyrek on 8/6/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: ViewController, ChartViewDelegate {

    @IBOutlet var barChart: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.chartDescription?.enabled = false
        if courses.count > 0 {
            updateChartWithData()
            barChart.animate(yAxisDuration: 1.0)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if courses.count > 0 {
            updateChartWithData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateChartWithData() {
        //var dataEntries: [BarChartDataEntry] = []

        let semesterCount = semestersListArray

        let groupSpace = 0.1
        let barSpace = 0.05
        let barWidth = 0.25

        let startYear = courses.reversed()[0].year
        let endYear = courses[0].year
        let groupCount = (endYear - startYear) + 1

        //print("start year " + String(startYear) + " end year :" + String(endYear))

        let yVals1 = NSMutableArray.init()
        let yVals2 = NSMutableArray.init()
        let yVals3 = NSMutableArray.init()


        for i in 0..<(groupCount*3) {//semesterCount.count {

            var semestersYearArray: [String] = []

            let newCourses = courses.reversed()

            for course in newCourses {
                if !course.semester.isEmpty {
                    if !semestersYearArray.contains(course.semester + " " + String(course.year)) {
                        semestersYearArray.append(course.semester + " " + String(course.year))
                    }
                }
            }

            var sms: [String] = []
            var zmz: [Course] = []

            for course in newCourses {
                if (course.semester + " " + String(course.year)) == semestersYearArray[i] {
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

            let space = Double(zmz[0].year)

            //let endIndex = semesterCount[i].index(semesterCount[i].endIndex, offsetBy: -4)
            //let newString = semesterCount[i].substring(to: endIndex)
            if zmz[0].semester == "Fall" {
                yVals1.add(BarChartDataEntry(x: space, y: Double(semesterGPA)))
            } else if zmz[0].semester == "Spring" {
                yVals2.add(BarChartDataEntry(x: space, y: Double(semesterGPA)))
            } else if zmz[0].semester == "Summer" {
                yVals3.add(BarChartDataEntry(x: space, y: Double(semesterGPA)))
            }
        }

        var set1 = BarChartDataSet.init()
        var set2 = BarChartDataSet.init()
        var set3 = BarChartDataSet.init()

        set1 = BarChartDataSet.init(values: yVals1 as? [ChartDataEntry], label: "Fall")
        set1.setColor(UIColor.init(colorLiteralRed: 45 / 255, green: 155 / 255, blue: 228 / 255, alpha: 1.0))
        set2 = BarChartDataSet.init(values: yVals2 as? [ChartDataEntry], label: "Spring")
        set2.setColor(UIColor.init(colorLiteralRed: 53 / 255, green: 220 / 255, blue: 118 / 255, alpha: 1.0))
        set3 = BarChartDataSet.init(values: yVals3 as? [ChartDataEntry], label: "Summer")
        set3.setColor(UIColor.init(colorLiteralRed: 250 / 255, green: 75 / 255, blue: 56 / 255, alpha: 1.0))

        let dataSets = NSMutableArray.init()
        dataSets.add(set1)
        dataSets.add(set2)
        dataSets.add(set3)

        let chartData = BarChartData(dataSets: dataSets as? [IChartDataSet])

        //barChart.legend.enabled = false
        barChart.drawBarShadowEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.centerAxisLabelsEnabled = true
        //barChart.xAxis.drawLabelsEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.drawGridBackgroundEnabled = false
        //barChart.leftAxis.drawGridLinesEnabled = false
        //barChart.rightAxis.drawGridLinesEnabled = false
        barChart.leftAxis.spaceTop = 0.35
        barChart.leftAxis.axisMinimum = 0
        //barChart.xAxis.labelFont = UIFont.init(name: "HelveticaNeue", size: 16)!
        barChart.xAxis.granularity = 1.0
        chartData.highlightEnabled = false

        barChart.rightAxis.enabled = false

        chartData.barWidth = barWidth

        barChart.xAxis.axisMinimum = Double(startYear)
        barChart.xAxis.axisMaximum = Double(startYear) + (chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount))

        //print(chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace))

        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)

        barChart.data = chartData

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
