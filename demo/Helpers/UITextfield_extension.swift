///**
/**
kjn589
UITextfield_extension.swift
Created by: KOMAL BADHE on 06/02/19
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
import UIKit
enum Direction
{
    case Left
    case Right
}

extension UITextField{
  
    func AddImage(direction:Direction,imageName:String,Frame:CGRect,backgroundColor:UIColor)
    {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        
        if Direction.Left == direction
        {
            imageView.frame.origin.x = 15;
            View.addSubview(imageView)
            View.frame.size.width = Frame.size.width + 35;
            self.leftViewMode = .always
            
            self.leftView = View
        }
        else
        {
            View.addSubview(imageView)
            self.rightViewMode = .always
           
            self.rightView = View
        }
    }
    @IBInspectable var updatePlaceholderColor: UIColor {
        get {
            guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor else { return UIColor.clear }
            return currentAttributedPlaceholderColor
        }
        set {
            guard let currentAttributedString = attributedPlaceholder else { return }
            let attributes = [NSAttributedString.Key.foregroundColor : newValue]
            attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
        }
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    
    
}
