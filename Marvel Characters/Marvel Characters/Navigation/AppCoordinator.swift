//
//  AppCoordinator.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import UIKit

//herda e define navegaçoes especificas
protocol AppCoordinating: Coordinator {
    func showMainScreen()
    func showCharacterDetail(for character: MarvelCharacter)
}

class AppCoordinator: AppCoordinating {
    
    func showMainScreen() {
        
        let listVC = makeListViewController()
        navigationControler.viewControllers = [listVC]
  
    }
    
    var childCoordinators: [Coordinator] = []
    
    var navigationControler: UINavigationController
    
    var type: CoordinatorType = .app
    
    var finishDelegate: CoordinatorFinish?
    
    private var tabBarController : UITabBarController
    
    init(_ navigationControler: UINavigationController) {
        self.navigationControler = navigationControler
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        showMainScreen()
    }
    
    //navigate to character screen
    func showCharacterDetail(for character: MarvelCharacter) {
        let detailViewModel = CharacterDetailViewModel(character: character)
        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
        navigationControler.pushViewController(detailViewController, animated: true)
    }
}

extension AppCoordinator {
    
    private func makeListViewController() -> UIViewController {
        let list = ListViewController()
        list.coordinator = self
        return list
    }
    
}
        
