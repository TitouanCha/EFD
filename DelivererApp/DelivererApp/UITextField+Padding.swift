//
//  UITextField+Padding.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 17/12/2025.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
