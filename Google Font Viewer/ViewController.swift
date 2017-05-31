//
//  ViewController.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: FontsTableViewDataSource?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up navigation bar
        let navBar = self.navigationController?.navigationBar
        navBar?.setValue(true, forKey: "hidesShadow")
        self.navigationItem.title = "Fonts"
        
        // Set up table view
        self.tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        Fonts.shared.fetchAllFamilies().then { _ -> Void in
            self.dataSource = FontsTableViewDataSource(families: Fonts.shared.fontFamilies)
            self.tableView.prefetchDataSource = self.dataSource
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }.catch { error in
            print(error)
        }
        
    }
}
