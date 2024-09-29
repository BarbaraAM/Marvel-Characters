//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 26/09/24.
//

import UIKit

class CharacterDetailViewController: UIViewController, UIColorGlobalAppearance {
    
    private let vm: CharacterDetailViewModel
    private var labelsContainerViews: [UIView] = []
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
    private let fontSize: CGFloat = 16.0
    
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
        setupScrollView()
        setupContentView()
        setupCharacterImageView()
        setupNameLabel()
        setupDescriptionLabel()
        setupLabels()
        setupShareButton()
        setupStackView()
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
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        
        print("is favorited? \(vm.isFavorited)")
    }

    
    private func bindViewModel() {
        nameLabel.text = vm.name
        descriptionLabel.text = vm.description
        comicsLabel.text = " \(vm.comics)"
        seriesLabel.text = " \(vm.series)"
        storiesLabel.text = " \(vm.stories)"
        eventsLabel.text = " \(vm.events)"
        resourceURILabel.text = " \(vm.resourceURI)"
        urlsLabel.text = " \(vm.urls)"
        
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
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .systemRed
        button.layer.masksToBounds = true
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


//UI Configs
extension CharacterDetailViewController {
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupCharacterImageView() {
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNameLabel() {
        nameLabel.font = UIFont.responsiveAvenirBlackTitleFont(size: 24)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.responsiveAvenirRegularTitleFont(size: 19)
    }
    
    private func setupLabels() {
        labelsContainerViews = [
            createLabelContainer(title: "Comics", text: vm.comics),
            createLabelContainer(title: "Series", text: vm.series),
            createLabelContainer(title: "Stories", text: vm.stories),
            createLabelContainer(title: "Events", text: vm.events),
            createLabelContainer(title: "Resource URI", text: vm.resourceURI),
            createLabelContainer(title: "URLs", text: vm.urls)
        ]
    }
    
    private func createLabelContainer(title: String, text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            default:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        
        let titleLabel = UILabel()
        titleLabel.text = "\(title)"
        titleLabel.font = UIFont.responsiveAvenirBlackTitleFont(size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = " \(text)"
        textLabel.font = UIFont.responsiveAvenirItalicTextFont(size: 16)
        textLabel.numberOfLines = 3
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        textLabel.addGestureRecognizer(tapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        return containerView
    }
    
    @objc private func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        
        if label.numberOfLines == 3 {
            label.numberOfLines = 0
        } else {
            label.numberOfLines = 3
        }
    }
    
    
    private func setupShareButton() {
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.layer.cornerRadius = 25
    }
    
    private func setupStackView() {
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, shareButton])
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        nameStackView.alignment = .center
        
        let labelsStackView = UIStackView(arrangedSubviews: labelsContainerViews)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 16
        labelsStackView.alignment = .fill
        
        let mainStackView = UIStackView(arrangedSubviews: [
            nameStackView,
            characterImageView,
            descriptionLabel,
            labelsStackView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .fill
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            characterImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            characterImageView.widthAnchor.constraint(lessThanOrEqualTo: mainStackView.widthAnchor)
        ])
    }
}

