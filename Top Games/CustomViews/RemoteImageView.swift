//
//  RemoteImageView.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit
import URITemplate

class RemoteImageView: UIImageView {

    var dataTask: URLSessionTask?
    
    func setImage(uriTemplate: URITemplate?, width: Int? = nil, height: Int? = nil, placeholderImage: UIImage?) {
        let w = (width ?? Int(self.frame.width)) * Int(UIScreen.main.scale)
        let h = (height ?? Int(self.frame.height)) * Int(UIScreen.main.scale)
        if let urlString = uriTemplate?.expand(["width": w, "height": h]) {
            setImage(url: URL(string: urlString), placeholderImage: placeholderImage)
        }
    }
    
    func setImage(url: URL?, placeholderImage: UIImage?) {
        self.image = placeholderImage
        guard let url = url else { return }
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: sessionConfiguration)
        dataTask = session.dataTask(with: url) { [weak self] (data, urlResponse, error) in
            session.finishTasksAndInvalidate()
            DispatchQueue.main.async { [weak self] in
                guard let data = data, let image = UIImage(data: data) else { return }
                self?.image = image
                self?.contentScaleFactor = UIScreen.main.scale
            }
        }
        dataTask?.resume()
    }
    
    func cancelRequest() {
        dataTask?.cancel()
    }

}
