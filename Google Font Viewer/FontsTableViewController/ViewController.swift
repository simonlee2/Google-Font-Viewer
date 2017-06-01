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
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            // round corners
            confirmButton.layer.cornerRadius = 5.0
            
            // add border outline
            confirmButton.layer.borderWidth = 2.0
            confirmButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recommendWifiView: UIView! {
        didSet {
            recommendWifiView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        }
    }
    
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
            self.dataSource = FontsTableViewDataSource(fonts: Fonts.shared.fontFamilies)
            self.tableView.prefetchDataSource = self.dataSource
            self.tableView.dataSource = self.dataSource
        }.catch { error in
            print(error)
        }
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.recommendWifiView.alpha = 0
        }
    }
}
