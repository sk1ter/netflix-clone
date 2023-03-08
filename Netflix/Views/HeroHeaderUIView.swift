//
//  HeroHeaderUIView.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 08/03/23.
//

import UIKit

class HeroHeaderUIView: UIView {

    private let heroImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.image = UIImage(named: "hero")
          return imageView
      }()
    
    private var playButton: UIButton!
    private var downloadButton: UIButton!


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playButton = makeButton(text: "Play")
        downloadButton = makeButton(text: "Download")
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeButton(text: String) -> UIButton {
        let button = UIButton()
         button.setTitle(text, for: .normal)
         button.layer.borderColor = UIColor.white.cgColor
         button.layer.borderWidth = 1
         button.layer.cornerRadius = 5
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }

}
