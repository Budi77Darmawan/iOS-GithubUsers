//
//  SearchBarExt.swift
//  Github Users
//
//  Created by Budi Darmawan on 17/05/21.
//

import Foundation
import UIKit

extension UISearchBar {
    private var textField: UITextField? {
        let subViews = self.subviews.flatMap { $0.subviews }
        if #available(iOS 13, *) {
            if let _subViews = subViews.last?.subviews {
                return (_subViews.filter { $0 is UITextField }).first as? UITextField
            } else {
                return nil
            }
            
        } else {
            return (subViews.filter { $0 is UITextField }).first as? UITextField
        }
        
    }
    
    private var searchIcon: UIImage? {
        let subViews = subviews.flatMap { $0.subviews }
        return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
    }

    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                break
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    var style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium
                    var backgroundColor: UIColor = UIColor.white
                    
                    if #available(iOS 11.0, *) {
                        style = UIActivityIndicatorView.Style.medium
                        backgroundColor = UIColor.clear
                    }
                    
                    let _activityIndicator = UIActivityIndicatorView(style: style)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = backgroundColor

                    if #available(iOS 11.0, *) {
                        self.setImage(UIImage(), for: .search, state: .normal)
                    }

                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    _activityIndicator.center = CGPoint(x: leftViewSize.width, y: leftViewSize.height)
                }
            } else {
                if #available(iOS 11.0, *) {
                    let _searchIcon = searchIcon
                    self.setImage(_searchIcon, for: .search, state: .normal)
                }
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
