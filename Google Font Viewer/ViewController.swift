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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
