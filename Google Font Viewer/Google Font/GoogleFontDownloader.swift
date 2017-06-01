//
//  GoogleFontManager.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/29/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

typealias SortType = GoogleFontAPI.Endpoints.SortType

class GoogleFontDownloader {
    var api: GoogleFontAPI
    var fontMapping: [String: GoogleFontFamily]
    
    init(api: GoogleFontAPI = GoogleFontAPI(), fontMapping: [String: GoogleFontFamily] = [:]) {
        self.api = api
        self.fontMapping = fontMapping
    }
    
    func font(family: String, variant: String) -> GoogleFont? {
        return fontMapping[family]?.font(withVariant: variant)
    }
    
    func fetchAllFamilies(sortType: SortType? = nil) -> Promise<[GoogleFontFamily]> {
        return fetchAllFamiliesJSON(sortType: sortType).then { json in
            self.parseItemsFromJSON(json)
        }.then { items -> [GoogleFontFamily] in
            let fonts = items.map(GoogleFontFamily.init)
            fonts.forEach { font in
                self.fontMapping[font.family] = font
            }
            return fonts
        }
    }
    
    private func fetchAllFamiliesJSON(sortType: SortType? = nil) -> Promise<JSON> {
        // Note: Not using PromiseKit's responseJSON() because it returns Promise<Any>
        return Promise { fulfill, reject in
            api.request(endpoint: .webfonts(sortType)).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        fulfill(JSON(data))
                    } else {
                        reject(Errors.invalidData)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    private func parseItemsFromJSON(_ json: JSON) -> [JSON] {
        return json["items"].arrayValue
    }
}
