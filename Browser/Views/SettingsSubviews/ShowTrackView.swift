import SwiftUI

struct ShowTrackView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: GPSLog.entity(), sortDescriptors: [])
    
    var GPSLogs: FetchedResults<GPSLog>
    
    var body: some View {
        List {
            ForEach(GPSLogs, id: \.id) { log in
                Text("\(log.latitude), \(log.longitude)")
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationBarTitle("Show Track", displayMode: .inline)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { GPSLogs[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ShowTrackView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTrackView()
    }
}
