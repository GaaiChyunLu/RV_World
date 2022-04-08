import SwiftUI

@main
struct BrowserApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            ChooseAnchorView(userData: UserData())
            StayPointView(userData: UserData())
        }
    }
}
