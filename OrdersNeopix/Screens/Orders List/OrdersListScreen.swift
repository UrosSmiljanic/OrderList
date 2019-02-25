//
//  ViewController.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

import UIKit

class OrdersListScreen: UIViewController {

    // Variables for collection view and for API call

    static var orderId: String!
    
    let cellId = "ordersCell"
    let headerId = "totalAmount"
    var collectionView: UICollectionView!

    var orders: OrdersModel?
    let url = "http://mobile-test.neopixdev.com/orders"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showSpinner(onView: view)

        view.backgroundColor = UIColor(hexString: "F0F2F3")
        
        setupNavigationBar()

        fetchGenericData(urlString: url) { (data: OrdersModel) in
            self.orders = data
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
                self.removeSpinner()
            }
        }
    }

    fileprivate func setuUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 5, right: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OrdersListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailling: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 12, right: 12))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setuUpCollectionView()
        
    }
    
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"))
    
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Orders"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

extension OrdersListScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        
        header.amountLabel.text = String(format: "$%.02f", locale: Locale.current, orders?.meta.totalAmount ?? 0.0)

        header.amountLabel.font = UIFont(name: "Metropolis-Bold", size: 18)
        header.amountLabel.textColor = UIColor(hexString: "252631")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 72)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrdersListCell
        
        if let url = orders?.data[indexPath.item].image {
            cell.venueImage.load(url: URL(string: url)!)
        }
        
        cell.venueName.text = orders?.data[indexPath.item].name
        
        let timeInterval = Double((orders?.data[indexPath.item].date)!)
        
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        
        cell.dateLabel.text = myNSDate.toString(dateFormat: "dd/mm/yyyy")
        
        cell.priceLabel.text = String(format: "$%.02f", locale: Locale.current, Double((orders?.data[indexPath.item].amount)!))
        
        switch orders?.data[indexPath.item].status.rawValue {
        case "accepted":
            cell.statusLabel.text = "  ACCEPTED  "
            cell.statusLabel.backgroundColor = UIColor(hexString: "3BBD8E")
        case "declined":
            cell.statusLabel.text = "  DECLINED  "
            cell.statusLabel.backgroundColor = UIColor(hexString: "E84D60")
        case "partiallyAccepted":
            cell.statusLabel.text = "  PARTIALLY ACCEPTED  "
            cell.statusLabel.backgroundColor = UIColor(hexString: "4D7CFE")
        default:
            cell.statusLabel.text = "  PENDING  "
            cell.statusLabel.backgroundColor = UIColor(hexString: "F2BF10")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let id = orders?.data[indexPath.item].id {
            OrdersListScreen.orderId = String(id)
        }
        
        let vc = UINavigationController(rootViewController: OrderDetailScreen())
        present(vc, animated: true, completion: nil)
    }
}
