//
//  CoursesManager.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 4/17/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyJSON

var courses             = [Course]()
var yearsArray:[String] = []
var gradesArray         = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
var semestersArray      = ["Fall", "Spring", "Summer"]
var currentYear         = 2017
let userDefaults        = UserDefaults.standard

class Course : NSObject {
    let name    :String
    let grade   :String
    let credits :NSInteger
    let semester:String
    let year    :NSInteger
    
    init(name:String, grade:String, credits:NSInteger, semester:String, year:NSInteger){
        self.name       = name
        self.grade      = grade
        self.credits    = credits
        self.semester   = semester
        self.year       = year
    }
    
}

func sortCourses() -> Void {
    courses.sort { (course1, course2) -> Bool in
        if course1.semester.lowercased() == "fall" && course2.semester.lowercased() == "fall"{
            return course1.year > course2.year
        }else if course1.semester.lowercased() == "fall" && course2.semester.lowercased() == "summer"{
            if course1.year > course2.year {
                return true
            }else if course1.year <= course2.year {
                return false
            }
        }else if course1.semester.lowercased() == "fall" && course2.semester.lowercased() == "spring"{
            if course1.year > course2.year {
                return true
            }else if course1.year <= course2.year {
                return false
            }
        }else if course1.semester.lowercased() == "spring" && course2.semester.lowercased() == "fall"{
            if course1.year >= course2.year {
                return true
            }else if course1.year < course2.year {
                return false
            }
        }else if course1.semester.lowercased() == "spring" && course2.semester.lowercased() == "summer"{
            if course1.year > course2.year {
                return true
            }else if course1.year <= course2.year {
                return false
            }
        }else if course1.semester.lowercased() == "spring" && course2.semester.lowercased() == "spring"{
            return course1.year > course2.year
        }else if course1.semester.lowercased() == "summer" && course2.semester.lowercased() == "fall"{
            if course1.year >= course2.year {
                return true
            }else if course1.year < course2.year {
                return false
            }
        }else if course1.semester.lowercased() == "summer" && course2.semester.lowercased() == "summer"{
            return course1.year > course2.year
        }else if course1.semester.lowercased() == "summer" && course2.semester.lowercased() == "spring"{
            if course1.year >= course2.year {
                return true
            }else if course1.year < course2.year {
                return false
            }
        }
        
        return true
    }
    
}

func gradeToValue(_ grade: String) -> Float {
    switch grade {
    case "A+":
        return userDefaults.float(forKey: "A+")
    case "A":
        return userDefaults.float(forKey: "A")
    case "A-":
        return userDefaults.float(forKey: "A-")
    case "B+":
        return userDefaults.float(forKey: "B+")
    case "B":
        return userDefaults.float(forKey: "B")
    case "B-":
        return userDefaults.float(forKey: "B-")
    case "C+":
        return userDefaults.float(forKey: "C+")
    case "C":
        return userDefaults.float(forKey: "C")
    case "C-":
        return userDefaults.float(forKey: "C-")
    case "D+":
        return userDefaults.float(forKey: "D+")
    case "D":
        return userDefaults.float(forKey: "D")
    case "D-":
        return userDefaults.float(forKey: "D-")
    case "F":
        return userDefaults.float(forKey: "F")
    default:
        return 0.0
    }
}

func getSemesterColor(semester: String) -> UIColor {
    
    var theChosenHollyColor = UIColor()
    
    switch semester.lowercased() {
    case "fall":
        theChosenHollyColor = .init(red: 0.1, green: 0.3, blue: 0.9, alpha: 0.5)
    case "spring":
        theChosenHollyColor = .init(red: 0.3, green: 0.9, blue: 0.3, alpha: 0.5)
    case "summer":
        theChosenHollyColor = .init(red: 0.9, green: 0.3, blue: 0.1, alpha: 0.5)
    default:
        theChosenHollyColor = .black
    }
    
    return theChosenHollyColor
    
}

func getCoursesArrayFromJSON() -> Void {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let coursesFile = dir.appendingPathComponent("Courses.json")
        
        do {
            let data = try Data(contentsOf: coursesFile)
            let jsonData = JSON(data: data).arrayValue
            
            for courseData in jsonData {
                courses.append(Course(name: courseData["name"].stringValue, grade: courseData["grade"].stringValue, credits: courseData["credits"].intValue, semester: courseData["semester"].stringValue, year: courseData["year"].intValue))
            }
            
        } catch {}
        
    } else {
        courses = []
        print("Failed to get json file.")
    }
}

func getCurrentYear() -> Int {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return Int(formatter.string(from: date))!
}

func getYearsArray() -> Void {
    currentYear = getCurrentYear()
    
    for i in stride(from: (currentYear - 50), to: (currentYear + 51), by: 1) {
        yearsArray.append(String(i))
    }
    
    yearsArray.reverse()
}

func getCumulativeGPA() -> String {
    var yearsGPA:Float = 0.0
    var yearsCredits = 0
    
    semestersListArray = []
    for course in courses{
        if !course.semester.isEmpty {
            if !semestersListArray.contains(course.semester+String(course.year)) {
                semestersListArray.append(course.semester+String(course.year))
            }
        }
    }
    
    for c in courses{
        yearsCredits += c.credits
    }
    
    for c in courses{
        yearsGPA += (Float(c.credits)/Float(yearsCredits)) * gradeToValue(c.grade)
    }
    
    return String(format: "%.2f", yearsGPA)
}

func getTotalCreditsFinished() -> Int {
    var credits = 0
    
    for course in courses {
        credits += course.credits
    }
    
    return credits
}

func saveCoursesToJSON() -> Void {
    var customData = [JSON]()
    
    for c in courses {
        customData.append(JSON(["name":c.name, "grade": c.grade, "credits": c.credits, "semester": c.semester, "year": c.year]))
    }
    
    let jsonSave = customData.description
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let path = dir.appendingPathComponent("Courses.json")
        
        do {
            try jsonSave.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        }catch {}
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    convenience init(HEX: UInt32, alpha: CGFloat) {
        self.init(red: CGFloat((HEX & 0xFF0000) >> 16)/256.0, green: CGFloat((HEX & 0xFF00) >> 8)/256.0, blue: CGFloat(HEX & 0xFF)/256.0, alpha: alpha)
    }
    
    func fieryOrange(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "FF9500", hexColor2: "FF5E3A")
    }
    
    func blueOcean(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "2BC0E4", hexColor2: "EAECC6")
    }
    
    func deepBlue(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "085078", hexColor2: "85D8CE")
    }
    
    func maceWindu(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "614385", hexColor2: "516395")
    }
    
    func mojitoBlast(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "1D976C", hexColor2: "93F9B9")
    }
    
    func lovelyPink(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "DD5E89", hexColor2: "F7BB97")
    }
    
    func haze(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "8e9eab", hexColor2: "eef2f3")
    }
    
    func beach(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "70e1f5", hexColor2: "ffd194")
    }
    
    func metalic(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "D6CEC3", hexColor2: "E4DDCA")
    }
    
    func orangeMango(targetedView:UIView) -> UIView {
        return self.theGradientBackground(backgroundView: targetedView, hexColor1: "F09819", hexColor2: "EDDE5D")
    }
    
    //MARK: cutomize gradient background
    func theGradientBackground(backgroundView: UIView, hexColor1: String, hexColor2:String) -> UIView {
        
        let color1: UIColor = self.convertHexStringToColor(hexString: hexColor1)
        let color2: UIColor = self.convertHexStringToColor(hexString: hexColor2)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        return backgroundView
    }
    
    //MARK: simple delightful colors
    
    //MARK: blues
    func indigoColor() -> UIColor {
        return self.rgbCalculation(redColor: 75, greenColor: 0, blueColor: 130, alphaValue: 1)
    }
    
    func midnightBlue() -> UIColor {
        return self.rgbCalculation(redColor: 25, greenColor: 25, blueColor: 112, alphaValue: 1)
    }
    
    func lightSkyBlue() -> UIColor {
        return self.rgbCalculation(redColor: 135, greenColor: 206, blueColor: 250, alphaValue: 1)
    }
    
    func deepSkyBlue() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 178, blueColor: 238, alphaValue: 1)
    }
    
    func navy() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 0, blueColor: 128, alphaValue: 1)
    }
    
    func royalblue() -> UIColor {
        return self.rgbCalculation(redColor: 72, greenColor: 118, blueColor: 255, alphaValue: 1)
    }
    
    //MARK: turquoise
    func turquoise() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 245, blueColor: 255, alphaValue: 1)
    }
    
    func darkerTurquoise() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 197, blueColor: 205, alphaValue: 1)
    }
    
    //MARK: green
    func springGreen() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 255, blueColor: 127, alphaValue: 1)
    }
    
    func darkerSpringGreen() -> UIColor {
        return self.rgbCalculation(redColor: 0, greenColor: 205, blueColor: 102, alphaValue: 1)
    }
    
    func mint() -> UIColor {
        return self.rgbCalculation(redColor: 189, greenColor: 252, blueColor: 201, alphaValue: 1)
    }
    
    func limeGreen() -> UIColor {
        return self.rgbCalculation(redColor: 50, greenColor: 205, blueColor: 50, alphaValue: 1)
    }
    
    func forestGreen() -> UIColor {
        return self.rgbCalculation(redColor: 34, greenColor: 139, blueColor: 34, alphaValue: 1)
    }
    
    //MARK: reds
    func rosyBrown() -> UIColor {
        return self.rgbCalculation(redColor: 188, greenColor: 143, blueColor: 143, alphaValue: 1)
    }
    
    func darkerRosyBrown() -> UIColor {
        return self.rgbCalculation(redColor: 238, greenColor: 180, blueColor: 180, alphaValue: 1)
    }
    
    func lightCoral() -> UIColor {
        return self.rgbCalculation(redColor: 240, greenColor: 128, blueColor: 128, alphaValue: 1)
    }
    
    func indianRed() -> UIColor {
        return self.rgbCalculation(redColor: 205, greenColor: 92, blueColor: 92, alphaValue: 1)
    }
    
    func darkerIndianRed() -> UIColor {
        return self.rgbCalculation(redColor: 238, greenColor: 99, blueColor: 99, alphaValue: 1)
    }
    
    func fireBrick() -> UIColor {
        return self.rgbCalculation(redColor: 178, greenColor: 34, blueColor: 34, alphaValue: 1)
    }
    
    //MARK: grays
    func silver() -> UIColor {
        return self.rgbCalculation(redColor: 192, greenColor: 192, blueColor: 192, alphaValue: 1)
    }
    
    func dimgray() -> UIColor {
        return self.rgbCalculation(redColor: 105, greenColor: 105, blueColor: 105, alphaValue: 1)
    }
    
    //MARK: redish or pinkish
    func crimson() -> UIColor {
        return self.rgbCalculation(redColor: 220, greenColor: 20, blueColor: 60, alphaValue: 1)
    }
    
    func lavenderBlush () -> UIColor {
        return self.rgbCalculation(redColor: 255, greenColor: 240, blueColor: 245, alphaValue: 1)
    }
    
    func greyishPink() -> UIColor {
        return self.rgbCalculation(redColor: 205, greenColor: 140, blueColor: 149, alphaValue: 1)
    }
    
    //MARK: HEX
    func convertHexToRGB(hex:UInt32) -> UIColor {
        return self.changeHexColorCodeToRGB(hex: hex, alpha: 1)
    }
    
    func convertHexStringToColor (hexString: String) -> UIColor {
        //var hexColorString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        var hexColorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexColorString.hasPrefix("#") {
            
            
            //hexColorString = hexColorString.substringFromIndex(hexColorString.startIndex.advancedBy(1))
            
            hexColorString = hexColorString.substring(from: hexColorString.startIndex)
        }
        
        if hexColorString.characters.count != 6 {
            NSException.raise(NSExceptionName(rawValue: "convertHexStringToColor Exception"), format: "Error: Invalid hex color string. Please ensure hex color string has 6 elements. Common error: Hashtag symbol is also included as part of the hex color string, that is not required. Ex. #4286f4 should be 4286f4", arguments: getVaList(["nil"]))
        }
        
        var hexColorRGBValue:UInt32 = 0
        Scanner(string: hexColorString).scanHexInt32(&hexColorRGBValue)
        
        return self.changeHexColorCodeToRGB(hex: hexColorRGBValue, alpha: 1)
    }
    
    
    //MARK: Private helper methods
    private
    func changeHexColorCodeToRGB(hex:UInt32, alpha: CGFloat) -> UIColor {
        
        return UIColor(   red: CGFloat((hex & 0xFF0000) >> 16)/255.0,
                          green: CGFloat((hex & 0xFF00) >> 8)/255.0,
                          blue: CGFloat((hex & 0xFF))/255.0,
                          alpha: alpha)
    }
    
    func rgbCalculation(redColor:CGFloat, greenColor: CGFloat, blueColor: CGFloat, alphaValue:CGFloat) -> UIColor {
        
        return UIColor(red: redColor/255, green: greenColor/255, blue: blueColor/255, alpha: alphaValue)
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

class RadialGradientLayer: CALayer {
    
    var center: CGPoint {
        return CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    var radius: CGFloat {
        return (bounds.width + bounds.height)/2
    }
    
    var colors: [UIColor] = [UIColor.black, UIColor.lightGray] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            return
        }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
}



class RadialGradientView: UIView {
    
    private let gradientLayer = RadialGradientLayer()
    
    var colors: [UIColor] {
        get {
            return gradientLayer.colors
        }
        set {
            gradientLayer.colors = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
    }
    
}
