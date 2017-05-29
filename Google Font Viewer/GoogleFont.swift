//
//  GoogleFont.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GoogleFont {
    let family: String
    let category: String
    let variants: [String]
    let subsets: [String]
    let version: String
    let kind: String
    var files: [String: String]
    let lastModified: String
    
    init(_ json: JSON) {
        family = json["family"].stringValue
        category = json["category"].stringValue
        variants = json["variants"].arrayValue.map({$0.stringValue})
        subsets = json["subsets"].arrayValue.map({$0.stringValue})
        version = json["version"].stringValue
        kind = json["kind"].stringValue
        files = Dictionary(json["files"].dictionaryValue.map({($0, $1.stringValue)}))
        lastModified = json["lastModified"].stringValue
    }
}

extension Dictionary {
    init<S: Sequence>
        (_ seq: S) where S.Iterator.Element == Element {
        self.init()
        for (k,v) in seq {
            self[k] = v
        }
    }
}
