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
        
        cell.configure(for: families[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
}
