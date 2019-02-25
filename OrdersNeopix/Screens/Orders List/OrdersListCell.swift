//
//  OrdersListCell.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// Setting for collection view cell for Orders List Screen

import UIKit

class OrdersListCell: BaseCollectionViewCell {
    
    let venueImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let venueName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = UIColor(hexString: "252631")
        return label
    }()
    
    let calendarImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "icon-date")
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Medium", size: 12)
        label.textColor = UIColor(hexString: "8790A3")
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 14)
        label.textColor = UIColor(hexString: "252631")
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Metropolis-Bold", size: 10)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()

        backgroundColor = .white
        
        addSubview(venueImage)
        venueImage.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: (contentView.frame.height / 2) - 16, left: 22, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        addSubview(venueName)
        venueName.anchor(top: contentView.topAnchor, leading: venueImage.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 16, left: 12, bottom: 0, right: 0))
        
        addSubview(calendarImage)
        calendarImage.anchor(top: venueName.bottomAnchor, leading: venueImage.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 6, left: 12, bottom: 0, right: 0), size: .init(width: 16, height: 16))
        
        addSubview(dateLabel)
        dateLabel.anchor(top: venueName.bottomAnchor, leading: calendarImage.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 10, left: 5, bottom: 0, right: 0))
        
        addSubview(priceLabel)
        priceLabel.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailling: contentView.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 12))
        
        addSubview(statusLabel)
        statusLabel.anchor(top: priceLabel.bottomAnchor, leading: nil, bottom: nil, trailling: contentView.trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 12), size: .init(width: 0, height: 16))
    }
}
