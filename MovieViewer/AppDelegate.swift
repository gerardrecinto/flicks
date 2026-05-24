//
//  AppDelegate.swift
//  MovieViewer
//
//  Created by Gerard Recinto on 1/31/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nowPlayingNavigationController =  storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "now_playing")
        let topRatedNavigationController =  storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "top_rated")

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }






}

