//
//  ExtensionUIImageView.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 13.12.2022.
//

import Foundation
import UIKit

extension UIImageView{
    func loadFrom(URLAddress: String){
         guard let url = URL(string: URLAddress) else {
             return
         }
      
         DispatchQueue.main.async { [weak self] in
             if let imageData = try? Data(contentsOf: url) {
                 if let loadedImage = UIImage(data: imageData) {
                         self?.image = loadedImage
                 }
             }
         }
     }
}
