//
//  CGImageExtensions.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/03/24.
//

import Foundation
import UIKit

public extension CGImage {
  
  func getPixelColor(_ point: CGPoint) -> UIColor? {
    guard let dataProvider = dataProvider,
          let pixelData = dataProvider.data,
          let layout = bitmapInfo.componentLayout,
          let data = CFDataGetBytePtr(dataProvider.data)
    else {
      return nil
    }
    
    let x = Int(point.x)
    let y = Int(point.y)
    let w = width
    let h = height
    let index = w * y + x
    let numBytes = CFDataGetLength(pixelData)
    let numComponents = bitsPerPixel / bitsPerComponent
    if numBytes != w * h * numComponents {
      print("Unexpected size: \(numBytes) != \(w)x\(h)x\(numComponents)")
      return nil
    }
    
    let isAlphaMultiplied = bitmapInfo.isAlphaPremultiplied
    switch numComponents {
    case 1:
      return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index]))
      
    case 3:
      let c0 = CGFloat(data[3*index]) / 255
      let c1 = CGFloat(data[3*index+1]) / 255
      let c2 = CGFloat(data[3*index+2]) / 255
      if layout == .bgr {
        return UIColor(red: c2, green: c1, blue: c0, alpha: 1.0)
      }
      return UIColor(red: c0, green: c1, blue: c2, alpha: 1.0)
      
    case 4:
      let c0 = CGFloat(data[4*index]) / 255
      let c1 = CGFloat(data[4*index+1]) / 255
      let c2 = CGFloat(data[4*index+2]) / 255
      let c3 = CGFloat(data[4*index+3]) / 255
      var r: CGFloat = 0
      var g: CGFloat = 0
      var b: CGFloat = 0
      var a: CGFloat = 0
      switch layout {
      case .abgr:
        a = c0
        b = c1
        g = c2
        r = c3
      case .argb:
        a = c0
        r = c1
        g = c2
        b = c3
      case .bgra:
        b = c0
        g = c1
        r = c2
        a = c3
      case .rgba:
        r = c0
        g = c1
        b = c2
        a = c3
      default:
        break
      }
      
      if isAlphaMultiplied && a > 0 {
        r = r / a
        g = g / a
        b = b / a
      }
      
      return UIColor(red: r, green: g, blue: b, alpha: a)
      
    default:
      return nil
    }
  }
}
