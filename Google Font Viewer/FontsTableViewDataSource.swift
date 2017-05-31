//
//  FontsTableViewDataSource.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/31/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit

class FontsTableViewDataSource: NSObject, UITableViewDataSource {
    var families: [String] = []
    var cancels: [(() -> Void)?]
    
    init(families: [String] = []){
        self.families = families
        self.cancels = Array(repeating: nil, count: families.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FontTableViewCell
        
        cell.configure(for: families[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
}

extension FontsTableViewDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let (promise, cancel) = Fonts.shared.font(for: families[indexPath.row], size: 20)
            promise.then { uifont in
                print("Prefetched \(String(describing: uifont?.fontName))")
            }.catch{ error in
                print(error)
            }
            
            cancels[indexPath.row] = cancel
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            if let cancel = cancels[indexPath.row] {
                cancel()
            }
        }
    }
}
