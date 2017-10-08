import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
}

func formatToDate (dateString:String) -> Date {
    //let dateString = "Thu, 22 Oct 2015 07:45:17 +0000" //For reference
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
    dateFormatter.locale = Locale.init(identifier: "en_GB")
    
    let dateObj:Date = dateFormatter.date(from: dateString)!
    dateFormatter.dateFormat = "MM-dd-yyyy"
    
    return dateObj
}

func formatFromDate (dateObj:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
    return "\(dateFormatter.string(from: dateObj))"
}

