//
//  HeaderView.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 20/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// Settings for Header view for Orders List Screen

import UIKit

class HeaderView: UICollectionReusableView {
    
    let totalAmountView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    
    let orderIcon: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "icon-total-full")
        return view
    }()
    
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Total Amount For Accepted Orders".uppercased()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(totalAmountView)
        totalAmountView.fillSuperView()
        
        totalAmountView.addSubview(orderIcon)
        orderIcon.anchor(top: totalAmountView.topAnchor, leading: totalAmountView.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 16, left: 22, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        totalAmountView.addSubview(totalAmountLabel)
        totalAmountLabel.anchor(top: orderIcon.topAnchor, leading: orderIcon.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 223, height: 0))
        
        totalAmountView.addSubview(amountLabel)
        amountLabel.anchor(top: nil, leading: orderIcon.trailingAnchor, bottom: orderIcon.bottomAnchor, trailling: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
