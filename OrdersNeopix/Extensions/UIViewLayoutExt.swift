//
//  UIViewLayoutExt.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// Auto layout extension that reduces duplicated lines of code

import UIKit

extension UIView {
    
    func fillSuperView() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailling: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorWidth(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func anchorHeight(to view: UIView) {
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func centerView(size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        if size.width != 0 {
            widthAnchor.constraint(equalTo: widthAnchor, constant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailling: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        // enables auto layout
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailling = trailling {
            trailingAnchor.constraint(equalTo: trailling, constant: -padding.right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
}
