//
//  ViewController.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let client = GoogleFontAPI()
        client.request(endpoint: .webfonts(nil)).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    let fonts = JSON(data)["items"].arrayValue.map(GoogleFont.init)
                    print(String(reflecting: fonts[0]))
                }
            case .failure:
                print(response.result.error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

