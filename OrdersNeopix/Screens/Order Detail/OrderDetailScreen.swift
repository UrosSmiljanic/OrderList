//
//  OrderDetailScreen.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

import UIKit
import MapKit

class OrderDetailScreen: UIViewController {

// Variables for collection view and for API call

    let cellId = "cell"
    var collectionView: UICollectionView!
    var orderDetails: OrdersDetail?
    var userInfo: UserInfo?
    let userInfoUrl = "http://mobile-test.neopixdev.com/venues"

// Declaration of views for the upper part of the screen

    let venueNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 16)
        label.textColor = .white
        return label
    }()
    
    let logoImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "avatar")
        return view
    }()
    
    let attributeArrow: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.image = #imageLiteral(resourceName: "icon-arrow-info")
        return view
    }()
    
    let leftStatusLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "545784")
        return view
    }()
    
    let rightStatusLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "545784")
        return view
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 10)
        label.textColor = .white
        label.contentMode = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let orderNumber: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Metropolis-Bold", size: 10)
        label.textColor = UIColor(hexString: "545784")
        label.text = "order number".uppercased()
        return label
    }()
    
    let orderNumberValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "000286"
        return label
    }()
    
    let requestedOn: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 10)
        label.textColor = UIColor(hexString: "545784")
        label.textAlignment = .center
        label.text = "requested on".uppercased()
        return label
    }()
    
    let requestedOnDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let acceptedOn: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 10)
        label.textColor = UIColor(hexString: "545784")
        label.textAlignment = .right
        label.text = "accepted on".uppercased()
        return label
    }()
    
    let acceptedOnDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "N/A"
        return label
    }()

// Declaration of container view that holds collection view and bottom bar view that contains the accept button and total amount label

    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        return view
    }()

// VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.showSpinner(onView: view)

        navigationController?.navigationBar.barStyle = .black

        let url = "http://mobile-test.neopixdev.com/orders/\(OrdersListScreen.orderId!)"
        
        fetchGenericData(urlString: url) { (data: OrdersDetail) in
            self.orderDetails = data
            
            DispatchQueue.main.async {
                self.venueNameLabel.text = data.data.name

                self.setupNavigationBar()

                self.orderNumberValue.text = data.data.orderNumber

                let timeInterval = Double((data.data.createdOn))
                let myNSDate = Date(timeIntervalSince1970: timeInterval)
                self.requestedOnDate.text = myNSDate.toString(dateFormat: "dd/mm/yyyy")
                
                switch data.data.status {
                case "accepted":
                    self.statusLabel.text = "  ACCEPTED  "
                    self.statusLabel.backgroundColor = UIColor(hexString: "3BBD8E")
                case "declined":
                    self.statusLabel.text = "  DECLINED  "
                    self.statusLabel.backgroundColor = UIColor(hexString: "E84D60")
                case "partiallyAccepted":
                    self.statusLabel.text = "  PARTIALLY ACCEPTED  "
                    self.statusLabel.backgroundColor = UIColor(hexString: "4D7CFE")
                default:
                    self.statusLabel.text = "  PENDING  "
                    self.statusLabel.backgroundColor = UIColor(hexString: "F2BF10")
                }
                
                self.collectionView.reloadData()

                self.setupView()

                self.removeSpinner()
            }
        }
    }

// setting up custom Navigation Bar
    struct System {
        static func clearNavigationBar(forBar navBar: UINavigationBar) {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
        }
    }

    fileprivate func setupNavigationBar() {
        let venueName = UIView()
        venueName.frame = CGRect(x: 0, y: 0, width: 184, height: 32)
        venueName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleVenueNamePressed)))
        venueName.isUserInteractionEnabled = true

        venueName.addSubview(logoImage)
        logoImage.anchor(top: venueName.topAnchor, leading: venueName.leadingAnchor, bottom: venueName.bottomAnchor, trailling: nil, size: .init(width: 32, height: 32))

        venueName.addSubview(venueNameLabel)
        venueNameLabel.anchor(top: venueName.topAnchor, leading: logoImage.trailingAnchor, bottom: venueName.bottomAnchor, trailling: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0))

        venueName.addSubview(attributeArrow)
        attributeArrow.anchor(top: venueName.topAnchor, leading: venueNameLabel.trailingAnchor, bottom: venueName.bottomAnchor, trailling: venueName.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))

        navigationItem.titleView = venueName

        let cancelButton = UIButton(type: .custom)
        cancelButton.isUserInteractionEnabled = true
        cancelButton.setImage(#imageLiteral(resourceName: "icon-close"), for: .normal)
        cancelButton.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)

        cancelButton.addTarget(self, action: #selector(handleCancelButtonPressed), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)

        let menuButton = UIButton(type: .custom)
        menuButton.isUserInteractionEnabled = true
        menuButton.setImage(#imageLiteral(resourceName: "icon-more"), for: .normal)
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)

        menuButton.addTarget(self, action: #selector(handleMenuButtonPressed), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)

        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
    }

// Handle goBack button and menu button

    @objc func handleCancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleMenuButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Decline Order", style: .destructive, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }

// Handling touch on Venue name by adding custom made action sheet

    @objc func handleVenueNamePressed() {
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 125.0))
        view.backgroundColor = .clear
        let dismissButton = UIButton(type: .custom)
        dismissButton.setImage(#imageLiteral(resourceName: "ic_close"), for: .normal)
        
        dismissButton.addTarget(self, action: #selector(handleCancelButtonPressed), for: .touchUpInside)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 6, left: 6, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Metropolis-Bold", size: 24)
        titleLabel.textColor = UIColor(hexString: "252631")
        titleLabel.textAlignment = .left
        titleLabel.text = "Venue Info"
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: dismissButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailling: view.trailingAnchor, padding: .init(top: 6, left: 6, bottom: 0, right: 0))
        
        actionSheet.view.addSubview(view)

        if let primaryName = orderDetails?.data.primaryContactName, let primaryPhone =  orderDetails?.data.primaryContactPhone {

            let primaryContact = primaryName + " " + primaryPhone
            let firstPhoneImage = #imageLiteral(resourceName: "icon-phone-primary")
            let firstPhoneNum = UIAlertAction(title: primaryContact, style: .default, handler: { (_) in
                primaryPhone.makeACall()
            })
            firstPhoneNum.setValue(firstPhoneImage.withRenderingMode(.alwaysOriginal), forKey: "image")
            firstPhoneNum.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            actionSheet.addAction(firstPhoneNum)
        }

        if let secondaryName = orderDetails?.data.secondaryContactName, let secondaryPhone =  orderDetails?.data.secondaryContactPhone {

            let secondaryContact = secondaryName + " " + secondaryPhone
            let secondPhoneImage = #imageLiteral(resourceName: "icon-phone-secondary")
            let secondPhoneNum = UIAlertAction(title: secondaryContact, style: .default, handler: { (_) in
                secondaryPhone.makeACall()
            })
            secondPhoneNum.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            secondPhoneNum.setValue(secondPhoneImage.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(secondPhoneNum)
        }

        if let location = orderDetails?.data.address {
            let locationImage = #imageLiteral(resourceName: "icon-location")
            let location = UIAlertAction(title: location, style: .default, handler: { (_) in
                
                // Deffining destination and leading you to Neopix cause API doesn't have coordinates
                let latitude: CLLocationDegrees = 43.313735
                let longitude: CLLocationDegrees = 21.887875

                let regionDistance: CLLocationDistance = 1000
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)

                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]

                let placemark = MKPlacemark(coordinate: coordinates)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "Neopix"
                mapItem.openInMaps(launchOptions: options)
            })
            location.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            location.setValue(locationImage.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(location)
        }
        
        actionSheet.view.tintColor = UIColor(hexString: "252631")
        
        present(actionSheet, animated: true, completion: nil)

    }
    
// Setup for main controller view

    func setupView() {
        
        let navigationBarView = UIImageView()
        navigationBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 177)
        navigationBarView.image = #imageLiteral(resourceName: "base")
        navigationBarView.contentMode = .redraw
        
        view.addSubview(navigationBarView)

        view.addSubview(statusLabel)
        statusLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailling: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: (view.frame.size.width - statusLabel.intrinsicContentSize.width) / 2, bottom: 0, right: (view.frame.size.width - statusLabel.intrinsicContentSize.width) / 2), size: .init(width: 0, height: 16))
        view.addSubview(leftStatusLine)
        leftStatusLine.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailling: statusLabel.leadingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 12), size: .init(width: 0, height: 1))
        view.addSubview(rightStatusLine)
        rightStatusLine.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: statusLabel.trailingAnchor, bottom: nil, trailling: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 12, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
        view.addSubview(orderNumber)
        orderNumber.anchor(top: statusLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 12, left: 16, bottom: 0, right: 0), size: .init(width: (view.frame.width / 3) - 16, height: 30))
        view.addSubview(orderNumberValue)
        orderNumberValue.anchor(top: orderNumber.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: (view.frame.width / 3) - 16, height: 30))
        
        view.addSubview(requestedOn)
        requestedOn.anchor(top: statusLabel.bottomAnchor, leading: orderNumber.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 3, height: 30))
        view.addSubview(requestedOnDate)
        requestedOnDate.anchor(top: requestedOn.bottomAnchor, leading: orderNumber.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 3, height: 30))
        
        view.addSubview(acceptedOn)
        acceptedOn.anchor(top: statusLabel.bottomAnchor, leading: requestedOn.trailingAnchor, bottom: nil, trailling: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 16), size: .init(width: view.frame.width / 3, height: 30))
        view.addSubview(acceptedOnDate)
        acceptedOnDate.anchor(top: acceptedOn.bottomAnchor, leading: requestedOn.trailingAnchor, bottom: nil, trailling: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: view.frame.width / 3, height: 30))

        if orderDetails?.data.status == "accepted" {
            view.addSubview(bottomBarView)
            bottomBarView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailling: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 70))
        } else {
            view.addSubview(bottomBarView)
            bottomBarView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailling: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 140))
        }

        setupBottomBarView()
        
        view.addSubview(headerContainer)
        headerContainer.anchor(top: navigationBarView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailling: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 48))
        
        setupHeaderContainer()
        
        view.addSubview(containerView)
        containerView.anchor(top: headerContainer.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: bottomBarView.topAnchor, trailling: view.safeAreaLayoutGuide.trailingAnchor)
    }

// Declaration views for header view with buttons for included products and notes
    
    let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "383A52")
        return view
    }()
    
    let includedProducts: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Included Products"
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let notes: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Notes"
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = UIColor(hexString: "9899A6")
        label.textAlignment = .center
        return label
    }()
    
    let leftYellowView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F2BF10")
        return view
    }()

    let rightYellowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F2BF10")
        view.isHidden = true
        return view
    }()

    fileprivate func setupHeaderContainer() {
        headerContainer.addSubview(includedProducts)
        includedProducts.anchor(top: headerContainer.topAnchor, leading: headerContainer.leadingAnchor, bottom: headerContainer.bottomAnchor, trailling: nil, size: .init(width: view.frame.width / 2, height: 0))
        
        headerContainer.addSubview(notes)
        notes.anchor(top: headerContainer.topAnchor, leading: includedProducts.trailingAnchor, bottom: headerContainer.bottomAnchor, trailling: headerContainer.trailingAnchor)
        
        headerContainer.addSubview(leftYellowView)
        leftYellowView.anchor(top: nil, leading: headerContainer.leadingAnchor, bottom: headerContainer.bottomAnchor, trailling: notes.leadingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 0, height: 5))
        
        headerContainer.addSubview(rightYellowView)
        rightYellowView.anchor(top: nil, leading: includedProducts.trailingAnchor, bottom: headerContainer.bottomAnchor, trailling: headerContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15), size: .init(width: 0, height: 5))
        
        includedProducts.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handeShowIncludedProducts)))
        notes.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowNotes)))
    }

// Functions for switching between Included Products and Notes

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 2
        return pc
    }()

    @objc func handeShowIncludedProducts() {
        includedProducts.textColor = .white
        notes.textColor = UIColor(hexString: "9899A6")
        rightYellowView.isHidden = true
        leftYellowView.isHidden = false

        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }

    @objc func handleShowNotes() {
        includedProducts.textColor = UIColor(hexString: "9899A6")
        notes.textColor = .white
        rightYellowView.isHidden = false
        leftYellowView.isHidden = true

        collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }

// Declaration views for bottom view with the accept button

    let accepOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexString: "4973E6")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Metropolis-Bold", size: 14)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("ACCEPT ORDER", for: .normal)

        button.addTarget(self, action: #selector(handleAcceptOrder), for: .touchUpInside)
        
        return button
    }()

    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
        label.textColor = UIColor(hexString: "252631")
        label.text = "Total Amount:"
        label.textAlignment = .left
        return label
    }()
    
    let totalAmountValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Metropolis-Bold", size: 20)
        label.textColor = UIColor(hexString: "252631")
        label.textAlignment = .right
        return label
    }()
    
    fileprivate func setupBottomBarView() {
        if orderDetails?.data.status == "accepted" {
            bottomBarView.addSubview(totalAmountLabel)
            totalAmountLabel.anchor(top: nil, leading: bottomBarView.leadingAnchor, bottom: bottomBarView.bottomAnchor, trailling: nil, padding: .init(top: 0, left: 22, bottom: 22, right: 0))

            totalAmountValue.text = String(format: "$%.02f", locale: Locale.current, Double((orderDetails?.data.totalAmount)!))

            bottomBarView.addSubview(totalAmountValue)
            totalAmountValue.anchor(top: nil, leading: nil, bottom: bottomBarView.bottomAnchor, trailling: bottomBarView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 22, right: 22))
        } else {
            bottomBarView.addSubview(accepOrderButton)
            accepOrderButton.anchor(top: nil, leading: bottomBarView.leadingAnchor, bottom: bottomBarView.bottomAnchor, trailling: bottomBarView.trailingAnchor, padding: .init(top: 0, left: 22, bottom: 22, right: 22), size: .init(width: 0, height: 52))

            bottomBarView.addSubview(totalAmountLabel)
            totalAmountLabel.anchor(top: nil, leading: accepOrderButton.leadingAnchor, bottom: accepOrderButton.topAnchor, trailling: nil, padding: .init(top: 0, left: 0, bottom: 22, right: 0))

            totalAmountValue.text = String(format: "$%.02f", locale: Locale.current, Double((orderDetails?.data.totalAmount)!))

            bottomBarView.addSubview(totalAmountValue)
            totalAmountValue.anchor(top: nil, leading: nil, bottom: accepOrderButton.topAnchor, trailling: accepOrderButton.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 22, right: 0))
        }
    }

    @objc func handleAcceptOrder() {
        print("API POST call")

        dismiss(animated: true, completion: nil)
    }

// Setup for collection view
    
    fileprivate func setuUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OrderDetailsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.yellow

        collectionView.isPagingEnabled = true
        
        containerView.addSubview(collectionView)
        
        collectionView.fillSuperView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setuUpCollectionView()
    }
}

// An extension for declaring behavior of collection view

extension OrderDetailScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrderDetailsCell
        
        switch indexPath.item {
        case 0:
            cell.orderDetails = orderDetails
            cell.itemListCollectionView.reloadData()
        case 1:
            if orderDetails?.data.notes.count == 0 {
                setupEmptyNotesView(cell)
                break
            }
            setupNotesView(cell)
        default:
            print("Error")
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

// Functions for setting up Notes View
    
    fileprivate func setupEmptyNotesView(_ cell: OrderDetailsCell) {
        let notesView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let imageView: UIImageView = {
            let view = UIImageView()
            view.frame = CGRect(x: 0, y: 0, width: 200, height: 156)
            view.image = #imageLiteral(resourceName: "il-notes-empty")
            return view
        }()
        
        let noteTitle: UILabel = {
            let label = UILabel()
            label.text = "No notes included in this order"
            label.textAlignment = .center
            label.font = UIFont(name: "Metropolis-Bold", size: 18)
            label.textColor = UIColor(hexString: "252631")
            return label
        }()
        
        let noteMessage: UILabel = {
            let label = UILabel()
            label.text = "Your notes will appear here as soon as someone leaves one."
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = UIFont(name: "Metropolis-Medium", size: 14)
            label.textColor = UIColor(hexString: "8790A3")
            return label
        }()
        
        cell.addSubview(notesView)
        notesView.fillSuperView()
        notesView.addSubview(imageView)
        imageView.anchor(top: notesView.topAnchor, leading: notesView.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 64, left: (notesView.frame.width / 2) + 100, bottom: 0, right: 0))
        notesView.addSubview(noteTitle)
        noteTitle.anchor(top: imageView.bottomAnchor, leading: notesView.leadingAnchor, bottom: nil, trailling: notesView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        notesView.addSubview(noteMessage)
        noteMessage.anchor(top: noteTitle.bottomAnchor, leading: notesView.leadingAnchor, bottom: nil, trailling: notesView.trailingAnchor, padding: .init(top: 20, left: 24, bottom: 0, right: 24))
    }
    
    fileprivate func setupNotesView(_ cell: OrderDetailsCell) {

        let notesView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let notesContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hexString: "F0F4F9")
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            return view
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont(name: "Metropolis-Medium", size: 14)
            label.textColor = UIColor(hexString: "252631")
            return label
        }()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .right
            label.font = UIFont(name: "Metropolis-Bold", size: 11)
            label.textColor = UIColor(hexString: "8790A3")
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.text = "Bottoms Up"
            label.font = UIFont(name: "Metropolis-SemiBold", size: 14)
            label.textColor = UIColor(hexString: "252631")
            return label
        }()
        
        let noteAvatar: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFill
            return view
        }()

        fetchGenericData(urlString: self.userInfoUrl) { (data: UserInfo) in
            self.userInfo = data

            DispatchQueue.main.async {
                noteAvatar.load(url: URL(string: (self.userInfo?.data[0].logo)!)!)
            }
        }
        
        cell.addSubview(notesView)
        notesView.fillSuperView()

        notesView.addSubview(notesContainerView)
        notesContainerView.anchor(top: notesView.topAnchor, leading: notesView.leadingAnchor, bottom: nil, trailling: notesView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 104))

        notesContainerView.addSubview(messageLabel)
        messageLabel.anchor(top: nil, leading: notesContainerView.leadingAnchor, bottom: notesContainerView.bottomAnchor, trailling: notesContainerView.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 12, right: 12), size: .init(width: 0, height: 50))
        
        notesContainerView.addSubview(dateLabel)
        dateLabel.anchor(top: notesContainerView.topAnchor, leading: nil, bottom: nil, trailling: notesContainerView.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 12))
        
        notesContainerView.addSubview(noteAvatar)
        noteAvatar.anchor(top: notesContainerView.topAnchor, leading: messageLabel.leadingAnchor, bottom: nil, trailling: nil, padding: .init(top: 6, left: 0, bottom: 0, right: 0),size: .init(width: 32, height: 32))
        
        notesContainerView.addSubview(nameLabel)
        nameLabel.anchor(top: dateLabel.topAnchor, leading: noteAvatar.trailingAnchor, bottom: nil, trailling: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        
        messageLabel.text = orderDetails?.data.notes[0].message
        messageLabel.setLineHeight(lineHeight: 1.4)

        let timeInterval = Double((orderDetails?.data.notes[0].date)!)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        dateLabel.text = myNSDate.toString(dateFormat: "dd/mm/yyyy")
    }

}
