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
        let task = Fonts.shared.tasks[family] ?? Fonts.shared.task(for: family, variant: "regular", size: 30)
        Fonts.shared.tasks[family] = task
        print("Configuring \(indexPath) for \(family)")
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
            let task = Fonts.shared.tasks[family] ?? Fonts.shared.task(for: family, variant: "regular", size: 30)
            Fonts.shared.tasks[family] = task
            
            task.promise.then { uifont -> Void in
                if uifont == nil {
                    print("Failed to get \(family)")
                }
                
//                print("Prefetched \(String(describing: uifont?.fontName))")
            }.catch{ error in
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let family = families[indexPath.row]
            if let task = Fonts.shared.tasks[family] {
                task.cancel?()
                Fonts.shared.tasks[family] = nil
            }
        }
    }
}
