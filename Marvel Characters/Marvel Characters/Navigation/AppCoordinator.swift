//
//  AppCoordinator.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import UIKit

//herda e define navegaçoes especificas
protocol AppCoordinating: Coordinator {
    var listViewModel: ListViewModel? { get set }
    func showMainScreen()
    func showCharacterDetail(for character: MarvelCharacterDecoder, at index: Int, filteredCharacters: [MarvelCharacterDecoder])
    func shareCharacterImage(image: UIImage)
    func showErrorMessage(_ message: String)


}


class AppCoordinator: AppCoordinating {
    var listViewModel: ListViewModel?

    
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
    func showCharacterDetail(for character: MarvelCharacterDecoder, at index: Int, filteredCharacters: [MarvelCharacterDecoder]) {
        guard let listViewModel = listViewModel else {
            print("ListViewModel is nil")
            return
        }
        
        let detailViewModel = CharacterDetailViewModel(character: character, listVM: listViewModel, index: index, filteredCharacters: filteredCharacters, coordinator: self)
        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
        navigationControler.pushViewController(detailViewController, animated: true)
    }
    
    func shareCharacterImage(image: UIImage) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            //popover for ipad
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.navigationControler.view
                popoverController.sourceRect = CGRect(x: self.navigationControler.view.bounds.midX, y: self.navigationControler.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.navigationControler.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        navigationControler.present(alertController, animated: true)
    }
}

extension AppCoordinator {
    
    private func makeListViewController() -> UIViewController {
        let listViewModel = ListViewModel(coordinator: self)
          self.listViewModel = listViewModel
          let listViewController = ListViewController(vm: listViewModel)
          listViewController.coordinator = self
          return listViewController
      }
}
        
