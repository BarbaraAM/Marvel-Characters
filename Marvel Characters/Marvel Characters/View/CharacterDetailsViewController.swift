//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import UIKit

class CharacterDetailViewController: UIViewController, UIColorGlobalAppearance {
    
    private let vm: CharacterDetailViewModel
    private let characterImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let comicsLabel = UILabel()
    private let seriesLabel = UILabel()
    private let storiesLabel = UILabel()
    private let eventsLabel = UILabel()
    private let resourceURILabel = UILabel()
    private let urlsLabel = UILabel()
    
    init(viewModel: CharacterDetailViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        
        setupUI()
        bindViewModel()
        setupFavoriteButton()
        updateFavoriteButton()
        

        
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, shareButton])
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        nameStackView.alignment = .center
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            characterImageView,
            nameStackView,
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
        stackView.alignment = .fill
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            characterImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            characterImageView.widthAnchor.constraint(lessThanOrEqualTo: stackView.widthAnchor)
        ])
        
        shareButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    
    private func setupFavoriteButton() {
        
        let favoriteButton = UIBarButtonItem(
            image: vm.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteStatus)
        )
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func updateFavoriteButton() {
        vm.updateFavoriteStatus()
        navigationItem.rightBarButtonItem?.image = vm.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        print("is favorited? \(vm.isFavorited)")
    }

    
    private func bindViewModel() {
        nameLabel.text = vm.name
        descriptionLabel.text = vm.description
        comicsLabel.text = "Comics: \(vm.comics)"
        seriesLabel.text = "Series: \(vm.series)"
        storiesLabel.text = "Stories: \(vm.stories)"
        eventsLabel.text = "Events: \(vm.events)"
        resourceURILabel.text = "Resource URI: \(vm.resourceURI)"
        urlsLabel.text = "URLs:\n\(vm.urls)"
        
        if let imageUrl = vm.imageUrl {
            loadImage(from: imageUrl)
        }
    }
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url, completion: { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to load image: \(error)")
                self.setPlaceholderImage()
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                self.setPlaceholderImage()
                return
            }
            
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        })
        
        task.resume()
    }
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal) 
        button.tintColor = .red
        button.addTarget(self, action: #selector(shareCharacterImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setPlaceholderImage() {
        DispatchQueue.main.async {
            self.characterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    @objc private func toggleFavoriteStatus() {
         vm.toggleFavoriteStatus()
         updateFavoriteButton()
     }
    
    @objc private func shareCharacterImage() {
        DispatchQueue.main.async {
            self.vm.didTapShare()
        }
    }
}

