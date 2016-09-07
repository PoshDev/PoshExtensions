// PoshExtensions.swift
// The MIT License (MIT)
// Copyright (c) 2016 Posh Development, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject
// to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
// ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import CoreLocation

// MARK: - Hex Representation of Color -

extension UIColor {

    convenience init(hexValue: Int){
        self.init(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


// MARK: - Autolayout Shortcuts -

extension UIView {

    func applyShadowWithColor(_ color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize(width: 1, height: 2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.25;
    }

    // CenterX and CenterY

    func addCenterXConstraintsToView(_ view: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }

    func addCenterYConstraintsToView(_ view: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }

    func addCenterXConstraintsToView(_ view: UIView, offset: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: -offset))
    }

    func addCenterYConstraintsToView(_ view: UIView, offset: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -offset))
    }

    // sides

    func addTopConstraintToView(_ view: UIView) {
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(top)
    }

    func addBottomConstraintToView(_ view: UIView) {
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraint(bottom)
    }

    func addLeftConstraintToView(_ view: UIView) {
        let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        self.addConstraint(left)
    }

    func addRightConstraintToView(_ view: UIView) {
        let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        self.addConstraint(right)
    }

    // pin to all subviews

    func pinSubviewToAllEdges(_ subview: UIView) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: subview, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: subview, attribute: .right, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        self.addConstraints([left, right, top, bottom])
    }

    // Height and Width

    func addHeightConstraintToView(_ view: UIView, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value))
    }

    func addWidthConstraintToView(_ view: UIView, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value))
    }

    // Equal Width and Height

    func addEqualHeightsConstraintsToViews(_ views: [UIView]) {
        for (i, view) in views.enumerated() {
            if i < views.count - 1 {
                self.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: views[i + 1], attribute: .height, multiplier: 1.0, constant: 0.0))
            }
        }
    }

    func addEqualWidthConstraintsToViews(_ views: [UIView]) {
        for (i, view) in views.enumerated() {
            if i < views.count - 1 {
                self.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: views[i + 1], attribute: .width, multiplier: 1.0, constant: 0.0))
            }
        }
    }

    // Visual Format

    func addConstraintsWithFormatStrings(_ strings: [String], views: [String : UIView]) {
        for string in strings {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: string, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }
}

extension UIImage {

    // image Stetching

    class func stretchableImageFromImage(_ image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }

    // recoloring

    class func recoloredImageFromImage(_ image: UIImage, newColor: UIColor) -> UIImage {

        let imageRect = CGRect(origin: CGPoint.zero, size: image.size)

        //////// Begin ////////
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, image.scale)

        let context = UIGraphicsGetCurrentContext()

        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0, y: -(imageRect.size.height))

        context?.clip(to: imageRect, mask: image.cgImage!)
        context?.setFillColor(newColor.cgColor)
        context?.fill(imageRect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        ///////// End /////////

        return newImage!
    }
}

extension Date {

    // returns date in form: Ex: Nov 27, 3:32 PM
    func currentTimeStampString() -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    // TODO: test this?
    // returns the time if within the last day, 'Yesterday' if made yesterday, a MM/DD/YY is before that or future
    func readableLocalTimestamp() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        var dateString = dateFormatter.string(from: self)

        print(dateString)
        if dateString.localizedCaseInsensitiveContainsString("yesterday") {
            dateString = "Yesterday"
        } else if dateString.localizedCaseInsensitiveContainsString("today") {
            dateString.removeSubrange(dateString.range(of: "Today, ")!)
        } else {
            // remove the time
            let newFormatter = DateFormatter()
            newFormatter.timeStyle = .none
            newFormatter.dateStyle = .short
            dateString = newFormatter.string(from: self)
            print("new dateString: \(dateString)")
        }
        return dateString
    }

    func roundedUpDay() -> Date {
        let calendar  = NSCalendar.currents
        let units: Calendar.Component = [Calendar.Component.year, Calendar.Component.monthSymbols, Calendar.Component.firstWeekday]
        let components = calendar.components(units, from: self)
        components.day += 1
        return calendar.date(from: components)!
    }

    func roundedDownDay() -> Date {
        let calendar  = NSCalendar.current
        let units: Calendar = [Calendar.year, Calendar.monthSymbols, Calendar.firstWeekday]
        let components = (calendar as NSCalendar).components(units, from: self)
        return calendar.date(from: components)!
    }
}

extension String {
    var nullIfEmpty: String? {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.characters.count == 0 ? nil : trimmed
    }

    static func commaSeparatedList(_ list: [String], conjunction: String = "and", oxfordComma: Bool = true) -> String {
        print(list.count)
        return list.enumerated().reduce("", { (lhs: String, rhs: (Int, String)) -> String in
            let (rhsIndex, rhsString) = rhs
            if lhs.characters.count == 0 {
                return rhsString
            }
            if rhsString.characters.count == 0 {
                return lhs
            }
            if rhsIndex == list.count - 1 {
                if !oxfordComma || list.count == 2 {
                    return lhs + " \(conjunction) " + rhsString
                } else {
                    return lhs + ", \(conjunction) " + rhsString
                }
            } else {
                return lhs + ", " + rhsString
            }
        })
    }

    // Extracts the first capture group from the string so long as the entire string matches the regex
    // i.e.  NSRegularExpression(pattern: "^(\\d*\\.?\\d*)%?$", options: [.CaseInsensitive])
    //       would extract "5.43" from "$5.43"
    func extractMatch(_ regex: NSRegularExpression) -> String? {
        let result = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        let capturedRange = result!.rangeAt(1)
        if !NSEqualRanges(capturedRange, NSMakeRange(NSNotFound, 0)) {
            let theResult = (self as NSString).substring(with: result!.rangeAt(1))
            return theResult
        } else {
            return nil
        }
    }
}

extension Array {

    mutating func appendAsQueueWithLength(_ newElement: Element, length: Int) {
        if self.count < length {
            self.append(newElement)
        } else {
            self.removeFirst()
            self.append(newElement)
        }
        assert(self.count <= length)
    }
}

// Calculates the average value of all elements in array
//extension _ArrayType where Iterator.Element == Double {
//
//    func getAverage() -> Double {
//        var average: Double = 0.0
//        self.forEach({average += $0})
//        return average / Double(self.count)
//    }
//}
//
//extension _ArrayType where Iterator.Element == Int {
//
//    func getAverage() -> Int {
//        var average: Double = 0.0
//        self.forEach({average += Double($0)})
//        return Int(round(average / Double(self.count)))
//    }
//}

extension CLLocationManager {
    func enableBackgroundLocation() {
        if #available(iOS 9.0, *) {
            self.allowsBackgroundLocationUpdates = true
        } else {
            // background location enabled by default
        }
    }
}

extension UITextField {

    func applyAttributedPlaceHolderForTextField() {
        let attributedPlaceholder = NSMutableAttributedString()
        let attributedText = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSForegroundColorAttributeName : UIColor.lightGray, NSFontAttributeName : self.font ?? UIFont.systemFont(ofSize: 17.0)])
        attributedPlaceholder.append(attributedText)
        self.attributedPlaceholder = attributedPlaceholder
    }
}

// Extension to get last n elements of array
extension Collection {
    func last(_ count:Int) -> [Self.Iterator.Element] {
        let selfCount = self.count as! Int

        if selfCount == 0 {
            return []
        }

        if count == 0 {
            return []
        }

        if selfCount <= count - 1 {
            return Array(self)
        } else {
            if count == 1 {
                Array(self).last
            }

            return Array(self.reversed()[0...count - 1].reversed())
        }
    }
}

extension UInt {
    // http://stackoverflow.com/questions/3312935/nsnumberformatter-and-th-st-nd-rd-ordinal-number-endings
    var shortOrdinal: String {
        let ones = self % 10;
        let tens = (self / 10) % 10;
        let suffix: String
        if tens == 1 {
            suffix = "th";
        } else if ones == 1 {
            suffix = "st";
        } else if ones == 2 {
            suffix = "nd";
        } else if ones == 3 {
            suffix = "rd";
        } else {
            suffix = "th";
        }
        return String(format: "%d%@", self, suffix)
    }
}

extension UITableViewCell {

    // regulatory
    static var nib: UINib {
        let className = self.className
        return UINib(nibName: className, bundle: Bundle.main)
    }

    static var cellReuseIdentifier: String {
        return self.className
    }

    static var className: String {
        return self.classForCoder().description().components(separatedBy: ".")[1]
    }
    
}

extension UICollectionViewCell {

    // regulatory
    static var nib: UINib {
        let className = self.className
        return UINib(nibName: className, bundle: Bundle.main)
    }

    static var cellReuseIdentifier: String {
        return self.className
    }

    static var className: String {
        return self.classForCoder().description().components(separatedBy: ".")[1]
    }
    
}

extension UITableViewHeaderFooterView {

    // regulatory
    static var nib: UINib {
        let className = self.className
        return UINib(nibName: className, bundle: Bundle.main)
    }

    static var cellReuseIdentifier: String {
        return self.className
    }

    static var className: String {
        return self.classForCoder().description().components(separatedBy: ".")[1]
    }
    
}
