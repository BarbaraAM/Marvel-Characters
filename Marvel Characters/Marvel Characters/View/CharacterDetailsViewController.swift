//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewModel
    private let characterImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let comicsLabel = UILabel()
    private let seriesLabel = UILabel()
    private let storiesLabel = UILabel()
    private let eventsLabel = UILabel()
    private let resourceURILabel = UILabel()
    private let urlsLabel = UILabel()
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        
        comicsLabel.numberOfLines = 0
        comicsLabel.font = UIFont.systemFont(ofSize: 16)
        
        seriesLabel.numberOfLines = 0
        seriesLabel.font = UIFont.systemFont(ofSize: 16)
        
        storiesLabel.numberOfLines = 0
        storiesLabel.font = UIFont.systemFont(ofSize: 16)
        
        eventsLabel.numberOfLines = 0
        eventsLabel.font = UIFont.systemFont(ofSize: 16)
        
        resourceURILabel.numberOfLines = 0
        resourceURILabel.font = UIFont.systemFont(ofSize: 16)
        
        urlsLabel.numberOfLines = 0
        urlsLabel.font = UIFont.systemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            characterImageView,
            nameLabel,
            descriptionLabel,
            comicsLabel,
            seriesLabel,
            storiesLabel,
            eventsLabel,
            resourceURILabel,
            urlsLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func bindViewModel() {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        comicsLabel.text = "Comics: \(viewModel.comics)"
        seriesLabel.text = "Series: \(viewModel.series)"
        storiesLabel.text = "Stories: \(viewModel.stories)"
        eventsLabel.text = "Events: \(viewModel.events)"
        resourceURILabel.text = "Resource URI: \(viewModel.resourceURI)"
        urlsLabel.text = "URLs:\n\(viewModel.urls)"
        
        if let imageUrl = viewModel.imageUrl {
            loadImage(from: imageUrl)
        }
    }
    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.characterImageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}

