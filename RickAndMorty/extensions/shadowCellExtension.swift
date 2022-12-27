//
//  shadowCellExtension.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 10.12.2022.
//

import Foundation
import UIKit

extension UIView{
    
    func showShadow(){
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.yellow.cgColor
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width:0,height:5)
    }
    
}
