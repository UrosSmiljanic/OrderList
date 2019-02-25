//
//  FetchGenericData.swift
//  OrdersNeopix
//
//  Created by Uros Smiljanic on 19/02/2019.
//  Copyright © 2019 Uros Smiljanic. All rights reserved.
//

// Fetching data function that accepts urlString and uses a data model that defined according to received JSON

import Foundation

func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
    
    let url = URL(string: urlString)
    
    URLSession.shared.dataTask(with: url!) { (data, resp, err) in
        
        guard let data = data else { return }
        
        do {
            let obj = try JSONDecoder().decode(T.self, from: data)
            completion(obj)
        } catch let jsonErr {
            print("Failed to decode json", jsonErr)
        }
        
        }.resume()
    
}
