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
    let manager = GoogleFontManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fontManager = FontManager()
        
        manager.fetchAllFamilies().then { families -> Void in
            if let font = self.manager.font(family: "Noto Sans", variant: "regular") {
                
                fontManager.font(for: font, size: 12).then { uifont in
                    print("success? \(String(describing: uifont))")
                }.catch { error in
                    print(error)
                }
            }
            
            
        }.catch { error in
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

