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

class GoogleFontManager {
    var api: GoogleFontAPI
    
    init(api: GoogleFontAPI = GoogleFontAPI()) {
        self.api = api
    }
    
    func fetchAllFontsJSON(sortType: SortType? = nil) -> Promise<JSON> {
        return Promise { fulfill, reject in
            api.request(endpoint: .webfonts(sortType)).responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    fulfill(JSON(data))
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func fetchAllFonts(sortType: SortType? = nil) -> Promise<[GoogleFont]> {
        return fetchAllFontsJSON(sortType: sortType).then { json in
            self.parseItemsFromJSON(json)
        }.then { items in
            items.map(GoogleFont.init)
        }
    }
    
    func parseItemsFromJSON(_ json: JSON) -> [JSON] {
        return json["items"].arrayValue
    }
}
