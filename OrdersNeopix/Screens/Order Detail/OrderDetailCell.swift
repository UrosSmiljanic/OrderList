//
//  test.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 21/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

import UIKit

class CustomizedCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cell"
    var orderDetails: OrdersDetail?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderDetails?.data.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! itemCell
        
        cell.nameLabel.text = orderDetails?.data.products[indexPath.item].name
        
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
        itemListCollectionView.backgroundColor = .white
        itemListCollectionView.register(itemCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    let itemListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
}

class itemCell: BaseCollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
       addSubview(nameLabel)
        nameLabel.fillSuperView()
    }
}
