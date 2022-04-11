import SwiftUI

struct CacheView: View {
    @ObservedObject var userData: UserData
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: GPSLog.entity(), sortDescriptors: [])
    
    var GPSLogs: FetchedResults<GPSLog>
    
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Button("Clear GPS Log") {

                self.showingAlert = true
            }
            .alert(isPresented: $showingAlert, content: {
                .init(title: Text("All GPS Logs will be Deleted"),
                      message: Text("You cannot undo this operation."),
                      primaryButton: .cancel(),
                      secondaryButton: .destructive(Text("Delete"), action: DeleteAllGPSLogs))
                      })
        }
        .navigationBarTitle("Cache", displayMode: .inline)
    }
    
    private func DeleteAllGPSLogs() {
        userData.points = [Point]()
        for i in 0 ..< GPSLogs.count {
            viewContext.delete(GPSLogs[i])
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct CacheView_Previews: PreviewProvider {
    static var previews: some View {
        CacheView(userData: UserData())
    }
}
