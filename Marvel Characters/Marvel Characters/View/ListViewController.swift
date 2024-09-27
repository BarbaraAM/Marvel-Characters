//
//  ListViewController.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import UIKit
import SwiftData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    weak var coordinator: AppCoordinator?
    var container: ModelContainer?
    private var tableView = UITableView()
    private var searchBar = UISearchBar()
    private var vm: CharacterVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inializating the SwiftData Container
        container = try? ModelContainer(for: MarvelCharacter.self)
        title = "Marvel Characters"
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setUpSearchBar()
        setUpTableView()
        
        vm = CharacterVM(coordinator: coordinator!)
        
        vm.onCharactersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }}
        
        vm.onFetchError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
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
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    

    //UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let character = vm.filteredCharacters[indexPath.row]
        cell.textLabel?.text = character.name
        
        return cell
    }
    
    // UIViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = vm.filteredCharacters[indexPath.row]
        vm?.didSelectCharacter(selectedCharacter)
    }
    
    //Search bar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changing \(searchText)")
        vm.filterCharacters(with: searchText)
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        vm.filterCharacters(with: "")
    }
}
