//
//  Extention+UIImage.swift
//  WeatherApiApp
//
//  Created by Adrian Inculet on 27.10.2025.
//

import Foundation
import UIKit

extension UIImage {
    static var cloudImage: UIImage {
        return UIImage(named: "cloud")!
    }
    static var cloudSunnyImage: UIImage {
        return UIImage(named: "cloudSunny")!
    }
    static var snowyImage: UIImage {
        UIImage(named: "snowy")!
    }
    static var sunnyImage: UIImage {
        return UIImage(named: "sunny")!
    }
    static var windImage: UIImage {
        return UIImage(named: "wind")!
    }
}
