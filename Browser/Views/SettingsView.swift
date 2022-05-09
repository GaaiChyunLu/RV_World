import SwiftUI

struct SettingsView: View {
    @ObservedObject var userData: UserData
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink(destination: ShowTrackView(userData: userData)) {
                        Text("Show Track")
                    }
                    
                    NavigationLink(destination: SetKValueView(userData: userData)) {
                        Text("Set K Value")
                    }
                    
                    NavigationLink(destination: ImportModelView()) {
                        Text("Import Model")
                    }
                })
                
                Section(content: {
                    NavigationLink(destination: SystemSettingView(userData: userData)) {
                        Text("System Settings")
                    }
                })
                
                Section(content: {
                    NavigationLink(destination: CacheView(userData: userData)) {
                        Text("Cache")
                    }
                })
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userData: UserData())
    }
}
