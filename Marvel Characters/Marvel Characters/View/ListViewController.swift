//
//  ListViewController.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import UIKit
import SwiftData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIColorGlobalAppearance {

    weak var coordinator: AppCoordinator?
    var container: ModelContainer?
    private var tableView = UITableView()
    private var searchBar = UISearchBar()
    private var vm: ListViewModel
    
    init(vm: ListViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configuring the appearance conforms the protocol
        configureAppearance()
        
        //inializating the SwiftData Container
        container = try? ModelContainer(for: MarvelCharacterStorage.self)
        title = "Marvel Characters"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       // setUpBindings()
        setUpSearchBar()
        setUpTableView()
        setUpEmptyStateLabel()
        
//        vm = ListViewModel(coordinator: coordinator!)
        
        vm.onCharactersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateUI()
            }}
        
        vm.onFetchError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
                self?.showEmptyState(message: "Erro ao carregar os dados.")
            }
        }
        vm.fetchCharacters()

    }
    
    private func setUpSearchBar() {
           searchBar.delegate = self
           searchBar.placeholder = "Search Characters"
           
           searchBar.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(searchBar)
           
           NSLayoutConstraint.activate([
               searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           ])
       }
    
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private func updateUI() {
        tableView.reloadData()
        
        if vm.filteredCharacters.isEmpty {
            showEmptyState(message: "Nenhum personagem encontrado. Tente novamente ou verifique sua conexão.")
        } else {
            hideEmptyState()
        }
    }

    private func showEmptyState(message: String) {
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
        tableView.isHidden = true
    }

    private func hideEmptyState() {
        emptyStateLabel.isHidden = true
        tableView.isHidden = false
    }
    
    

    //UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let character = vm.filteredCharacters[indexPath.row]
        cell.textLabel?.text = character.name
        
        if vm.isCharacterFavorited(character) {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "star.fill"))
            cell.accessoryView?.tintColor = .systemYellow
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
    
    // UIViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = vm.filteredCharacters[indexPath.row]
        vm.didSelectCharacter(selectedCharacter, index: indexPath.row)
    }
    
    //Search bar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changing \(searchText)")
        vm.filterCharacters(with: searchText)
        self.showEmptyState(message: "Erro ao carregar os dados.")

    
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        vm.filterCharacters(with: "")
    }
    
    //Swipe Action
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "Favoritar") { [weak self] (action, view, completionHandler) in
            let character = self?.vm.filteredCharacters[indexPath.row]
            print("\(character?.name ?? "") favoritado!")
            
            
            self?.vm.favoriteCharacter(by: character?.id ?? 0)

            
            completionHandler(true)
        }
        
        favoriteAction.backgroundColor = .systemPink
        favoriteAction.image = UIImage(systemName: "suit.heart.fill")
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let character = vm.filteredCharacters[indexPath.row]
        
        let unfavCharacter = UIContextualAction(style: .normal, title: "Desfavoritar") { [weak self] (action, view, completionHandler) in
            self?.vm.unfavoriteCharacter(by: character.id ?? 0)
            completionHandler(true)
        }
        
        unfavCharacter.image = UIImage(systemName: "suit.heart.slash.fill")
        unfavCharacter.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [unfavCharacter])
        
        return configuration
    }
}
