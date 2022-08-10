//
//  HorizontalCollectionViewCell.swift
//  ProjetoMarvel
//
//  Created by c94289a on 22/11/21.
//

import UIKit
import Kingfisher

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    private var gradient: Bool = false
    private lazy var imageItem: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage()
        image.layer.cornerRadius = 15
        image.isAccessibilityElement = false
        
        return image
    }()
    
    private lazy var viewAccessibilityImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0)
        view.isHidden = true
        view.isAccessibilityElement = false
        
        return view
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.isAccessibilityElement = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    override func layoutSubviews(){
        if gradient == false {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor,UIColor.black.withAlphaComponent(0.0).cgColor]
            gradientLayer.frame = bounds
            gradientLayer.startPoint = CGPoint(x: 1.2, y: 1.2)
            gradientLayer.endPoint = CGPoint(x: 1.2, y: 0.0)
            gradientLayer.cornerRadius = 15
            imageItem.layer.insertSublayer(gradientLayer, at: 0)
            gradient = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyAccessibility(heroName: String) {
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = .button
        contentView.accessibilityLabel = heroName
        contentView.accessibilityHint = "Double click for more information about the character \(heroName)"
    }
    
    private func setupLayout() {
        contentView.addSubview(viewAccessibilityImage)
        contentView.addSubview(imageItem)
        contentView.addSubview(labelName)
        
        setupConstraints()
    }
    
    func updateCell(hero: Results) {
        guard let name = hero.name else { return }
        labelName.text = name
        
        if let path = hero.thumbnail?.path,
           let imageExtension = hero.thumbnail?.imageExtension {
            if UIAccessibility.isVoiceOverRunning {
                imageItem.isHidden = true
                viewAccessibilityImage.isHidden = false
            } else {
                viewAccessibilityImage.isHidden = true
                imageItem.isHidden = false
                
                let url = "\(path)/standard_fantastic.\(imageExtension)"
                guard let heroUrlImage = URL(string: url) else { return }
                imageItem.kf.setImage(with: heroUrlImage,
                                               placeholder: UIImage(named: "placeholder"),
                                               options: [
                                                .transition(ImageTransition.fade(0.5)),
                                                .cacheOriginalImage
                                               ],
                                               progressBlock: nil,
                                               completionHandler: nil)
            }

       }
        
        applyAccessibility(heroName: name)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageItem.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            viewAccessibilityImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewAccessibilityImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewAccessibilityImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewAccessibilityImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 153.0),
            labelName.heightAnchor.constraint(equalToConstant: 20.0),
            labelName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
