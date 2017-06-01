//
//  FontManager.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/30/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import PromiseKit

class FontManager {
    var postScriptNameMapping: [String: String]
    
    init(postScriptNameMapping: [String: String] = [:]) {
        self.postScriptNameMapping = postScriptNameMapping
    }
    
    func font(for font: GoogleFont, size: CGFloat) -> (Promise<UIFont?>, () -> Void) {
        if let postScriptName = postScriptNameMapping[font.name] {
            return (Promise(value: UIFont(name: postScriptName, size: size)), {})
        }
        
        let (promise, cancel) = downloadFont(font: font)
        
        return (promise.then { [weak self] data in
            self?.registerFont(font, data: data as CFData)
        }.then { [weak self] _ -> UIFont? in
            if let postScriptName = self?.postScriptNameMapping[font.name] {
                return UIFont(name: postScriptName, size: size)
            } else {
                return nil
            }
        }, cancel)
    }
    
}

extension FontManager {

    internal func downloadFont(font: GoogleFont) -> (Promise<Data>, () -> Void) {
        let request = Alamofire.request(font.externalDocumentURL)
        return (Promise { fulfill, reject in
            request.responseData(queue: DispatchQueue(label: "font")) { response in
                switch response.result {
                case .success:
                    fulfill(response.data!)
                case .failure(let error):
                    reject(error)
                }
            }
        }, request.cancel)
    }
    
    internal func registerFont(_ font: GoogleFont, data: CFData) -> Bool {
        let provider = CGDataProvider(data: data)
        let cgfont = CGFont(provider!)
        var error: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterGraphicsFont(cgfont, &error) else {
            print(error ?? "Error registering \(font)")
            return false
        }
        
        guard let postScriptName = cgfont.postScriptName as String? else {
            CTFontManagerUnregisterGraphicsFont(cgfont, nil)
            return false
        }
        
        postScriptNameMapping[font.name] = postScriptName
        
        return true
    }
}
