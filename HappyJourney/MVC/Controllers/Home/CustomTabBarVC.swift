//
//  CustomTabBarVC.swift
//  Internacia
//
//  Created by Admin on 19/10/22.
//

import UIKit

class CustomTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
}

extension CustomTabBarVC : UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController{
            for controller in navigationController.viewControllers {
                if let messagesViewController = controller as? EmptyVC {
//                    let navControl = getRootNavigation()
//                    navControl?.
                    navigationController.pushViewController(messagesViewController, animated: true)
                }
            }
        }
    }
}
