//
//  CharacterItem.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit

class CharacterItem: UITableViewCell {
    
    private var imageViewL: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var tittleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    
    func configure(charater: MarvelCharacter) {
        
        tittleLabel.text = charater.name
        descriptionLabel.text = charater.description
        getImageView("\(charater.thumbnail.path).\(charater.thumbnail.extension)")
    }
    
    
}
private extension CharacterItem {
    
    func setUpView() {
        addSubview(imageViewL)
        addSubview(tittleLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageViewL.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageViewL.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageViewL.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageViewL.widthAnchor.constraint(equalToConstant: 70),
            imageViewL.heightAnchor.constraint(equalToConstant: 90),
            
            tittleLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor),
            tittleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: tittleLabel.bottomAnchor, constant: 3),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func getImageView(_ urlBase: String) {
        ApiClient().downloadImage(urlBase: urlBase) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageViewL.image = image
            }
        }
    }
}
