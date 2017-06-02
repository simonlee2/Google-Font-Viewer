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
    let queue = DispatchQueue(label: "font", qos: .background, attributes: [.concurrent])
    
    init(postScriptNameMapping: [String: String] = [:]) {
        self.postScriptNameMapping = postScriptNameMapping
    }
    
    func font(for font: GoogleFont, size: CGFloat) -> (Promise<UIFont?>, () -> Void) {
        if let postScriptName = postScriptNameMapping[font.name] {
            return (Promise(value: UIFont(name: postScriptName, size: size)), {})
        }
        
        return downloadAndRegisterFont(font: font, size: size)
//
//        let (promise, cancel) = downloadFont(font: font)
//        
//        return (promise.then { [weak self] data in
//            self?.registerFont(font, data: data as CFData)
//        }.then { postScriptName -> UIFont? in
//            guard let postScriptName = postScriptName else { return nil }
//            
//            return UIFont(name: postScriptName, size: size)
//        }, cancel)
        
    }
    
}

extension FontManager {
    internal func fetchFontFromMapping(for font: GoogleFont, size: CGFloat) -> Promise<UIFont?> {
        if let postScriptName = postScriptNameMapping[font.name] {
            return Promise(value: UIFont(name: postScriptName, size: size))
        } else {
            return Promise(value: nil)
        }
    }
    
    internal func downloadAndRegisterFont(font: GoogleFont, size: CGFloat) -> (Promise<UIFont?>, () -> Void) {
        let (downloadPromise, cancel) = downloadFont(font: font)
        
        let downloadAndRegisterPromise = downloadPromise.then { [weak self] data in
            self?.registerFont(font, data: data as CFData)
        }.then { postScriptName -> UIFont? in
            guard let postScriptName = postScriptName else { return nil }
            
            return UIFont(name: postScriptName, size: size)
        }
        
        return (downloadAndRegisterPromise, cancel)
    }

    internal func downloadFont(font: GoogleFont) -> (Promise<Data>, () -> Void) {
        let request = Alamofire.request(font.externalDocumentURL)
        return (Promise { fulfill, reject in
            request.responseData(queue: queue) { response in
                switch response.result {
                case .success:
                    fulfill(response.data!)
                case .failure(let error):
                    reject(error)
                }
            }
        }, request.cancel)
    }
    
    internal func registerFont(_ font: GoogleFont, data: CFData) -> String? {
    
        let provider = CGDataProvider(data: data)
        let cgfont = CGFont(provider!)
        var error: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterGraphicsFont(cgfont, &error) else {
            print(error ?? "Error registering \(font)")
            return nil
        }
        
        guard let postScriptName = cgfont.postScriptName as String? else {
            CTFontManagerUnregisterGraphicsFont(cgfont, nil)
            return nil
        }
        
        postScriptNameMapping[font.name] = postScriptName
        
        return postScriptName
    }
}
