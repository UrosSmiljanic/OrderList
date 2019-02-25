//
//  test.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 21/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// Setting for collection view cell with additional collection view inside the cell

import UIKit

class OrderDetailsCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cell"
    var orderDetails: OrdersDetail?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderDetails?.data.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! itemCell
        
        cell.itemImage.load(url: URL(string: (orderDetails?.data.products[indexPath.item].image)!)!)
        cell.itemName.text = orderDetails?.data.products[indexPath.item].name
        cell.priceLabel.text = String(format: "$%.02f", locale: Locale.current, Double((orderDetails?.data.products[indexPath.item].totalPrice)!))
        cell.quantityValueLabel.text = String((orderDetails?.data.products[indexPath.item].quantity)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(itemListCollectionView)
        itemListCollectionView.fillSuperView()
        
        itemListCollectionView.dataSource = self
        itemListCollectionView.delegate = self
        itemListCollectionView.backgroundColor = UIColor.lightGray
        itemListCollectionView.register(itemCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    let itemListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
}

class itemCell: BaseCollectionViewCell {
    
    let itemImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let itemName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = UIColor(hexString: "252631")
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity:"
        label.font = UIFont(name: "Metropolis-Medium", size: 12)
        label.textColor = UIColor(hexString: "8790A3")
        return label
    }()
    
    let quantityValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 12)
        label.textColor = UIColor(hexString: "252631")
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 14)
        label.textColor = UIColor(hexString: "252631")
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(itemImage)
        itemImage.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: (contentView.frame.height / 2) - 16, left: 22, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        addSubview(itemName)
        itemName.anchor(top: contentView.topAnchor, leading: itemImage.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 16, left: 12, bottom: 0, right: 0))
        
        addSubview(quantityLabel)
        quantityLabel.anchor(top: itemName.bottomAnchor, leading: itemImage.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 6, left: 12, bottom: 0, right: 0))
        
        addSubview(quantityValueLabel)
        quantityValueLabel.anchor(top: itemName.bottomAnchor, leading: quantityLabel.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 6, left: 5, bottom: 0, right: 0))
        
        addSubview(priceLabel)
        priceLabel.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailling: contentView.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 12))
        
    }
}
