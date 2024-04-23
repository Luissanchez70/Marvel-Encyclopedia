//
//  ResourcesItem.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 23/4/24.
//

import Foundation
import UIKit

class ResourcesItem: UITableViewCell {
    
    private var imageViewL: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16,
                                 weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12,
                                 weight: .regular)
        label.numberOfLines = 2
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
    
    
    func configure(character: Comic) {
        guard let title = character.title,
              let description = character.description,
              let thumbnail = character.thumbnail else { return }
        
        tittleLabel.text = title
        if description.isEmpty {
            descriptionLabel.text = "Without description"
        } else {
            descriptionLabel.text = description
        }
        let path = "\(thumbnail.path).\(thumbnail.extension)"
        let base = path.replacingOccurrences(of: "http:", with: "https:")
        getImageView(base)
    }
    
    func configure(character: Series) {
        guard let title = character.title,
              let description = character.description,
              let thumbnail = character.thumbnail else { return }
        
        tittleLabel.text = title
        if description.isEmpty {
            descriptionLabel.text = "Without description"
        } else {
            descriptionLabel.text = description
        }
        let path = "\(thumbnail.path).\(thumbnail.extension)"
        let base = path.replacingOccurrences(of: "http:", with: "https:")
        getImageView(base)
    }
    
    
    
}
private extension ResourcesItem {
    
    func setUpView() {
        addSubview(imageViewL)
        addSubview(tittleLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageViewL.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageViewL.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageViewL.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageViewL.widthAnchor.constraint(equalToConstant: 50),
            imageViewL.heightAnchor.constraint(equalToConstant: 50),
            
            tittleLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor, constant: 10),
            tittleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: tittleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func getImageView(_ urlBase: String) {
        
        ApiClient().downloadImage(urlBase: urlBase) { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageViewL.image = image
            }
        }
    }
}
