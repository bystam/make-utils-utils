//
//  AppDelegate.swift
//  UtilsUtils
//
//  Created by Fredrik Bystam on 2018-10-04.
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let pushConsumer: AppPushConsumer = AppPushConsumer()
    private let urlSchemeConsumer: AppURLSchemeConsumer = AppURLSchemeConsumer()

    private var coordinator: RootCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let context = RootContext(sessionAtLaunch: AppSession.persisted(),
                                  pushTriggers: pushConsumer,
                                  urlSchemeTriggers: urlSchemeConsumer)

        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = RootCoordinator(window: window, context: context)

        coordinator.start()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        urlSchemeConsumer.consume(url: url)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushConsumer.consume(payload: userInfo)
    }
}
