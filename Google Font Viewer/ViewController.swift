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

class ViewController: UITableViewController {
    var families: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Fonts.shared.fetchAllFamilies().then { _ -> Void in
            self.families = Fonts.shared.fontFamilies
            self.tableView.reloadData()
        }.catch { error in
            print(error)
        }
    
//        Fonts.shared.font(for: "Noto Sans", size: 12).then { uifont -> Void in
//            if let notoSans = uifont {
//                print(notoSans)
//            }
//            print("no font found")
//        }.catch { error in
//            print(error)
//        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FontTableViewCell
        
        cell.configure(for: families[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
}

class FontTableViewCell: UITableViewCell {
    let fontSize: CGFloat = 20
    
    func configure(for family: String) {
        Fonts.shared.font(for: family, size: fontSize).then { uifont -> Void in
            self.textLabel?.font = uifont
            self.textLabel?.text = family
            UIView.animate(withDuration: 0.3) {
                self.textLabel?.alpha = 1
            }
        }.catch { error in
            print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        textLabel?.alpha = 0
    }
}

