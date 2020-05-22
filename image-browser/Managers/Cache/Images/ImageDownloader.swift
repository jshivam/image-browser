//
//  ImageDownloader.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    private let imageCache = NSCache<NSString, UIImage>()

    func dowload(url: URL, completion: @escaping (UIImage?, URL?) -> Void) {

        let cache =  URLCache.shared
        let request = URLRequest(url: url)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, url)
        }
        else if let cachedResponse = cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
            if let urlString = cachedResponse.response.url?.absoluteString {
                self.imageCache.setObject(image, forKey: urlString as NSString)
            }
            DispatchQueue.main.async {
                completion(image, cachedResponse.response.url)
            }
        }
        else {
            DispatchQueue.global(qos: .background).async {

                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            if let urlString = response.url?.absoluteString {
                                self.imageCache.setObject(image, forKey: urlString as NSString)
                            }
                            completion(image, response.url)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, nil)
                        }
                    }
                }).resume()
            }
        }
    }
}


extension UIImageView {

    struct AssociatedKeys {
        static var urlKey = "urlKey"
    }

    private var downloader: ImageDownloader {
        return ImageDownloader.shared
    }

    var url: URL? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.urlKey) as? URL else { return nil }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.urlKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func loadImage(url: URL) {
        self.url = url
        image = nil
        downloader.dowload(url: url) { [weak self] (image, downloadedURL) in
            if let `self` = self,
                let downloadedURL = downloadedURL,
                let latestRequestURL = self.url, latestRequestURL == downloadedURL {
                self.image = image
            } else {
                self?.url = nil
            }
        }
    }

    private func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 1,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}
