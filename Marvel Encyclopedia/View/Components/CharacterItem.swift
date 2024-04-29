//
//  CharacterItem.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit
import Combine

class CharacterItem: UITableViewCell {
    private var cancellables = Set<AnyCancellable>()
    private var imageViewL: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,
                                 weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12,
                                 weight: .regular)
        label.numberOfLines = 5
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
    
    
    func configure(charater: Character) {
        
        tittleLabel.text = charater.name
        if charater.description.isEmpty {
            descriptionLabel.text = "Without description"
        } else {
            descriptionLabel.text = charater.description
        }
        let base = charater.thumbnail!.path.replacingOccurrences(of: "http:", with: "https:")
        getImageView("\(base).\(charater.thumbnail!.extension)")
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
            imageViewL.widthAnchor.constraint(equalToConstant: 90),
            imageViewL.heightAnchor.constraint(equalToConstant: 120),
            
            tittleLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor, constant: 10),
            tittleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageViewL.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: tittleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func getImageView(_ urlBase: String) {
        
        DownloadImageFromAPI().execute(urlBase: urlBase).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { image in
            DispatchQueue.main.async {
                self.imageViewL.image = image

            }
        }.store(in: &cancellables)
    }
}
