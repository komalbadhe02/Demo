///**
/**
kjn589
Common_utils.swift
Created by: KOMAL BADHE on 07/02/19
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
import UIKit
import SystemConfiguration
//Mark: Check internet connection
func isConnectedToNetwork() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

func showAlert(message : String,viewController : UIViewController) {
    let alert = UIAlertController(title: "",
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    viewController.present(alert, animated: true, completion: nil)
}

func isValidEmailID(txtEmail : String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    if emailTest.evaluate(with: txtEmail) {
        return true
    }
    else{
        return false
    }
}
func isValidName(txtName: String) -> Bool {
    let firstNameRegex = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
    let firstNameTest = NSPredicate(format: "SELF MATCHES %@", firstNameRegex)
    let result = firstNameTest.evaluate(with: txtName)
    if result == false {
        return false
    }
    return result
}
func isValidMobileNo(mobileNo : String) -> Bool {
    let noRegex = "[0-9]{10,12}"
    let noTest = NSPredicate(format: "SELF MATCHES %@", noRegex)
    let result = noTest.evaluate(with: mobileNo)
    if result == false {
        return false
    }
    return result
}


func heightForLabel(text:String, fontName:String, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = UIFont(name: fontName, size: 14)
    label.text = text
    label.sizeToFit()
    return label.frame.height
}
func alertWithMessage(title : String , message : String ,  viewController : Any)  {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    (viewController as? UIViewController)?.present(alert, animated: true, completion: nil)
}
//func md5Conversion(_ string: String) -> String {
//    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//    CC_MD5_Init(context)
//    CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
//    CC_MD5_Final(&digest, context)
//    context.deallocate(capacity: 1);
//    //context.deallocate(capacity: 1)
//    var hexString = ""
//    for byte in digest {
//        hexString += String(format:"%02x", byte)
//    }
//    return hexString
//}
func returnImageHeight(imageSize : CGSize,screenSize : CGSize) -> CGFloat {
    let height : CGFloat =  (imageSize.height * screenSize.width)/imageSize.width;
    return height
}


func compareDate(_ date: Date, isBetweenDate beginDate: Date, andDate endDate: Date) -> Bool {
    if date.compare(beginDate) == .orderedAscending {
        return false
    }
    if date.compare(endDate) == .orderedDescending {
        return false
    }
    return true
}
func convertStringToDateConversion(dateInString : String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let availableDate = dateFormatter.date(from: dateInString)
    return availableDate!
}
func convertDateToString(date : Date)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let dateInString = dateFormatter.string(from: date);
    return dateInString;
}
func addSpaceButton() -> UIBarButtonItem {
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    //  spaceButton.
    return spaceButton;
}
func getYesterdayDate() -> Date {
    let currentCalendar = NSCalendar.current
    let dateComponents = NSDateComponents()
    dateComponents.day = -1
    let yesterdayDate = currentCalendar.date(byAdding: dateComponents as DateComponents, to: NSDate() as Date);
    return yesterdayDate!;
}
func validateDeliveryDate(deliveryFromDate : String,deliveryToDate : String,selectedDate : String) -> Bool {
    let toDate = convertStringToDateConversion(dateInString: deliveryToDate);
    let fromDate = convertStringToDateConversion(dateInString:deliveryFromDate );
    let sendGiftDate = convertStringToDateConversion(dateInString: selectedDate);
    if compareDate(sendGiftDate, isBetweenDate: toDate, andDate: fromDate) {
        return true
    }
    else{
        return false
    }
}
func getTextfieldCharactersLength(txtfield : UITextField)->Int{
    return (txtfield.text?.trimmingCharacters(in: .whitespaces).description.count)!;
}

func getInitialLetterBgColor(initialLetter : String)->UIColor{
    let arrayForColorCodes : NSArray = getPlistArray(key: "ColorCodes")
    
    if arrayForColorCodes.count != 0  {
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", initialLetter)
        let filteredArr = (arrayForColorCodes as NSArray).filtered(using: searchPredicate) as NSArray
        if filteredArr.count != 0 {
            let dict : NSDictionary = filteredArr.object(at: 0) as! NSDictionary;
            let redValue : CGFloat = NumberFormatter().number(from: dict.value(forKey: "Red") as! String) as! CGFloat / 255.0
            let greenValue : CGFloat = NumberFormatter().number(from: dict.value(forKey: "Green") as! String) as! CGFloat / 255.0
            let blueValue : CGFloat = NumberFormatter().number(from: dict.value(forKey: "Blue") as! String) as! CGFloat / 255.0
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1);
        }
    }
    return UIColor.red;
}

func getPlistArray(key : String) -> NSArray {
    var dictRoot: NSDictionary?
    var arrayObj: NSArray?
    
    if let path = Bundle.main.path(forResource: "MenuFile", ofType: "plist") {
        dictRoot = NSDictionary(contentsOfFile: path)
    }
    if dictRoot != nil
    {
        arrayObj = dictRoot?.value(forKey: key) as? NSArray;
    }
    return arrayObj!;
}


func getAlertController(message : String, title:String)-> UIAlertController  {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    return alert;
}


func getUIButton(btnTitle : String ) -> UIButton {
    
    let button = UIButton(type: .custom)
    button.setTitle(btnTitle, for: .normal)
    button.layer.backgroundColor = UIColor.red.cgColor
    button.frame.size.width = 100;
    button.layer.cornerRadius = 4.0
    return button;
}
