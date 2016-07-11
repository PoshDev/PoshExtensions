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

    // slightly darkened colors


    func colorByDarkeningWithValue(value: CGFloat) -> UIColor {

        let numberOfComponenets = CGColorGetNumberOfComponents(self.CGColor)
        let isGreyscale = numberOfComponenets == 2

        let oldComponents = CGColorGetComponents(self.CGColor)
        var newComponents: [CGFloat] = [0.0, 0.0, 0.0, 0.0]

        if isGreyscale {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[3] = oldComponents[1];
        } else {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value
            newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value
            newComponents[3] = oldComponents[3]
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColorCreate(colorSpace, newComponents)

        return UIColor(CGColor: newColor!)
    }
}


// MARK: - Autolayout Shortcuts -

extension UIView {

    func applyShadowWithColor(color: UIColor) {
        self.layer.shadowColor = color.CGColor
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSizeMake(1, 2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.25;
    }

    // CenterX and CenterY

    func addCenterXConstraintsToView(view: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
    }

    func addCenterYConstraintsToView(view: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }

    func addCenterXConstraintsToView(view: UIView, offset: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -offset))
    }

    func addCenterYConstraintsToView(view: UIView, offset: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -offset))
    }

    // Height and Width

    func addHeightConstraintToView(view: UIView, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: value))
    }

    func addWidthConstraintToView(view: UIView, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: value))
    }

    // Equal Width and Height

    func addEqualHeightsConstraintsToViews(views: [UIView]) {
        for (i, view) in views.enumerate() {
            if i < views.count - 1 {
                self.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: views[i + 1], attribute: .Height, multiplier: 1.0, constant: 0.0))
            }
        }
    }

    func addEqualWidthConstraintsToViews(views: [UIView]) {
        for (i, view) in views.enumerate() {
            if i < views.count - 1 {
                self.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: views[i + 1], attribute: .Width, multiplier: 1.0, constant: 0.0))
            }
        }
    }

    // Visual Format

    func addConstraintsWithFormatStrings(strings: [String], views: [String : UIView]) {
        for string in strings {
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(string, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }
}

extension UIImage {

    // image Stetching

    class func stretchableImageFromImage(image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return image.resizableImageWithCapInsets(capInsets, resizingMode: .Stretch)
    }

    // recoloring

    class func recoloredImageFromImage(image: UIImage, newColor: UIColor) -> UIImage {

        let imageRect = CGRect(origin: CGPointZero, size: image.size)

        //////// Begin ////////
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, image.scale)

        let context = UIGraphicsGetCurrentContext()

        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0, -(imageRect.size.height))

        CGContextClipToMask(context, imageRect, image.CGImage)
        CGContextSetFillColorWithColor(context, newColor.CGColor)
        CGContextFillRect(context, imageRect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        ///////// End /////////

        return newImage
    }
}

extension NSDate {

    // returns date in form: Ex: Nov 27, 3:32 PM
    func currentTimeStampString() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(self)
    }

    // TODO: test this?
    // returns the time if within the last day, 'Yesterday' if made yesterday, a MM/DD/YY is before that or future
    func readableLocalTimestamp() -> String {

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.doesRelativeDateFormatting = true

        var dateString = dateFormatter.stringFromDate(self)

        print(dateString)
        if dateString.localizedCaseInsensitiveContainsString("yesterday") {
            dateString = "Yesterday"
        } else if dateString.localizedCaseInsensitiveContainsString("today") {
            dateString.removeRange(dateString.rangeOfString("Today, ")!)
        } else {
            // remove the time
            let newFormatter = NSDateFormatter()
            newFormatter.timeStyle = .NoStyle
            newFormatter.dateStyle = .ShortStyle
            dateString = newFormatter.stringFromDate(self)
            print("new dateString: \(dateString)")
        }
        return dateString
    }

    func roundedUpDay() -> NSDate {
        let calendar  = NSCalendar.currentCalendar()
        let units: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let components = calendar.components(units, fromDate: self)
        components.day += 1
        return calendar.dateFromComponents(components)!
    }

    func roundedDownDay() -> NSDate {
        let calendar  = NSCalendar.currentCalendar()
        let units: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let components = calendar.components(units, fromDate: self)
        return calendar.dateFromComponents(components)!
    }
}

extension String {
    var nullIfEmpty: String? {
        let trimmed = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.characters.count == 0 ? nil : trimmed
    }

    static func commaSeparatedList(list: [String], conjunction: String = "and", oxfordComma: Bool = true) -> String {
        print(list.count)
        return list.enumerate().reduce("", combine: { (lhs: String, rhs: (Int, String)) -> String in
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
}
