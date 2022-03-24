//
//  ViewController.swift
//  ColorExtractionKitExample
//
//  Created by Toshiharu Imaeda on 2022/03/24.
//

import UIKit
import ColorExtractionKit

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var resultView: UIView!
  
  @IBAction func didTapPickColorOfTopButton(_ sender: Any) {
    guard let cgImage = image.cgImage else {
      return
    }
    resultView.backgroundColor = cgImage.getPixelColor(.init(x: cgImage.width / 2, y: 0))
  }
  
  @IBAction func didTapPickColorOfBottomButton(_ sender: Any) {
    guard let cgImage = image.cgImage else {
      return
    }
    resultView.backgroundColor = cgImage.getPixelColor(.init(x: cgImage.width / 2, y: cgImage.height - 1))
  }
  
  private let image: UIImage = .init(named: "sample")!

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    imageView.image = image
    resultView.layer.cornerRadius = 5
    resultView.layer.masksToBounds = true
    resultView.layer.borderColor = UIColor.lightGray.cgColor
    resultView.layer.borderWidth = 2
  }

}
