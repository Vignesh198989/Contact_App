//
//  ImageDownloader.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import UIKit.UIImage

final class ImageDownloader {
    
    static let sharedImageDownloader = ImageDownloader()
    private var networkManager: NetworkManager?
    private let queue = DispatchQueue(label: "queue.imagedownload", attributes: .concurrent)
    private init() {
        configure()
    }
    
    func configure(networkManager: NetworkManager = ContactsNetworkManager.sharedNetworkManager) {
        self.networkManager = networkManager
    }
    
    func download(path: String, placeHolderImage: UIImage?, completion: @escaping (UIImage) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                return
            }

            let info = RequestInfo(path: path, parameters: nil, method: .get)
            self.networkManager?.download(requestInfo: info, completion: { (responseData, error) in
                if let data = responseData, let image = UIImage.init(data: data) {
                    self.queue.sync {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } else if let placeHolderImage = placeHolderImage {
                    DispatchQueue.main.async {
                        completion(placeHolderImage)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(UIImage())
                    }
                }
            })
        }
    }
}
