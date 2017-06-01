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
    
    init(families: [String] = []){
        self.families = families
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FontTableViewCell
        
        
        let family = families[indexPath.row]
        let task = Fonts.shared.task(for: family, size: 20)
        cell.configure(for: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
}

extension FontsTableViewDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let family = families[indexPath.row]
            let task = Fonts.shared.task(for: family, size: 20)
            
            task?.promise.then { uifont -> Void in
                if uifont == nil {
                    print("Failed to prefetch \(family)")
                }
            }.catch{ error in
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let family = families[indexPath.row]
            Fonts.shared.removeTask(for: family)
        }
    }
}
