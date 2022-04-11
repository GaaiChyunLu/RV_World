import SwiftUI

@main
struct BrowserApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ChooseAnchorView(userData: UserData())
//            StayPointView(userData: UserData())
        }
    }
}
