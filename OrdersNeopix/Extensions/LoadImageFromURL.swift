//
//  LoadImageFromURL.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// An extension that asynchronous download images from URL

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
