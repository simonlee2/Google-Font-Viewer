//
//  FontManager.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/30/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import PromiseKit

typealias Cancel = () -> Void

class FontManager {
    var postScriptNameMapping: [String: String]
    let queue = DispatchQueue(label: "font", qos: .background, attributes: [.concurrent])
    
    init(postScriptNameMapping: [String: String] = [:]) {
        self.postScriptNameMapping = postScriptNameMapping
    }
    
    /// Fetch an instance of UIFont for a font described by `GoogleFont`. 
    /// A fresh font file will be downloaded and the font will be registered if the `FontManager` has not seen the font before.
    ///
    /// - Parameters:
    ///   - font: `GoogleFont` describing the font
    ///   - size: font size
    /// - Returns: A pair of `Promise<UIFont?>` and `Cancel`. The cancel function is provided to allow caller to cancel the promise chain.
    func font(for font: GoogleFont, size: CGFloat) -> (Promise<UIFont?>, Cancel) {
        if let postScriptName = postScriptNameMapping[font.name] {
            return (Promise(value: UIFont(name: postScriptName, size: size)), {})
        }
        
        return downloadAndRegisterFont(font: font, size: size)
    }
}

extension FontManager {
    
    
    /// Download font file from Google, register a CGFont,
    /// then return a corresponding UIFont if possible.
    ///
    /// - Parameters:
    ///   - font: describes the font
    ///   - size: font size
    /// - Returns: A pair of `Promise<UIFont?>` and `Cancel`. The cancel function is provided to allow caller to cancel the promise chain.
    internal func downloadAndRegisterFont(font: GoogleFont, size: CGFloat) -> (Promise<UIFont?>, Cancel) {
        let (downloadPromise, cancel) = downloadFont(font: font)
        
        let downloadAndRegisterPromise = downloadPromise.then { [weak self] data in
            self?.registerFont(font, data: data as CFData)
        }.then { postScriptName -> UIFont? in
            guard let postScriptName = postScriptName else { return nil }
            
            return UIFont(name: postScriptName, size: size)
        }
        
        return (downloadAndRegisterPromise, cancel)
    }

    
    /// Download font file from Google
    ///
    /// - Parameter font: `GoogleFont` that describes the font
    /// - Returns: A pair of `Promise<Data>` and `Cancel` for further operations on `Data` or cancellation
    internal func downloadFont(font: GoogleFont) -> (Promise<Data>, Cancel) {
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
    
    
    /// Register a CGFont for use in the app.
    ///
    /// - Parameters:
    ///   - font: `GoogleFont` that describes the font
    ///   - data: `CFData` representation of the font file
    /// - Returns: `nil` if the registration fails, or the font's postscript name if successful
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
