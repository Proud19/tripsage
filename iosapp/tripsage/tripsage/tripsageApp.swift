//
//  tripsageApp.swift
//  tripsage
//
//  Created by Proud Mpala on 5/7/24.
//

import SwiftUI
import BackgroundTasks

@main
struct tripsageApp: App {
    @StateObject private var locationManager = LocationManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainEntryView()
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.startUpdatingLocation()
                }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Scheduling the app refresh")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.tripsage.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        scheduleAppRefresh()
        return true
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        LocationManager.shared.startUpdatingLocation()
        NetworkManager.shared.checkForUpdates { result in
            switch result {
            case .success(let updates):
                print("Updates: \(updates)")
                task.setTaskCompleted(success: true)
            case .failure(let error):
                print("Failed to fetch updates: \(error.localizedDescription)")
                task.setTaskCompleted(success: false)
            }
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.tripsage.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // 15 minutes
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule app refresh: \(error.localizedDescription)")
        }
        print("Successfully scheduled app refresh")
    }
}
