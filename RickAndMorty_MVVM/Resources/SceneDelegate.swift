//
//  SceneDelegate.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Create tabBarController
        let tabBarController = UITabBarController()
        
        // Create VCs and navigation controllers for tabBarController
        
        let characterVC = CharacterViewController()
        let locationVC = LocationViewController()
        let episodeVC = EpisodeViewController()
        let arrayVC = [characterVC, locationVC, episodeVC]
        
        for controller in arrayVC {
            controller.navigationItem.largeTitleDisplayMode = .always
        }
        
        characterVC.title = "Character"
        locationVC.title = "Location"
        episodeVC.title = "Episode"
        
        characterVC.tabBarItem = UITabBarItem(title: "Character", image: UIImage(systemName: "person"), tag: 0)
        locationVC.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "globe"), tag: 1)
        episodeVC.tabBarItem = UITabBarItem(title: "Episode", image: UIImage(systemName: "tv"), tag: 2)
        
        let firstNavigationController = UINavigationController(rootViewController: characterVC)
        let secondNavigationController = UINavigationController(rootViewController: locationVC)
        let thirdNavigationController = UINavigationController(rootViewController: episodeVC)
        let arrayNavController = [firstNavigationController, secondNavigationController, thirdNavigationController]
        
        for controller in arrayNavController {
            controller.navigationBar.prefersLargeTitles = true
        }
        tabBarController.setViewControllers(arrayNavController, animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        locationVC.loadViewIfNeeded()
        episodeVC.loadViewIfNeeded()
    }

   

}

