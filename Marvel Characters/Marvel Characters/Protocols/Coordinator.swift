//
//  Coordinator.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import Foundation
import UIKit

//Coordinator base das funcionalidades do app
protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationControler: UINavigationController { get set }
    var type: CoordinatorType { get set }
    var finishDelegate: CoordinatorFinish? { get set }
    
    func start()
}

enum CoordinatorType {
    case app, characters
}

protocol CoordinatorFinish: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

extension Coordinator {
    //finish coordinator
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
