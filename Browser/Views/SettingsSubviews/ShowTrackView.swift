import SwiftUI
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.commaSeparatedText]
    }
    
    var content: String
    
    init(content: String) {
        self.content = content
    }
    
    init(filePath: String) {
        self.content = try! String(contentsOfFile: filePath, encoding: .utf8)
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let value = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.content = value
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: content.data(using: .utf8)!)
    }
}

struct DisplayPoint: Hashable, Identifiable {
    let id = UUID()
    var latitude: Double?
    var longitude: Double?
    var timeStamp: String?
    init(latitude: Double, longitude: Double, timeStamp: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = timeStamp
    }
    init() {}
}

struct DisplayPoints: Hashable, Identifiable {
    let id = UUID()
    var displayPoints: [DisplayPoint]
    init(displayPoints: [DisplayPoint]) {
        self.displayPoints = displayPoints
    }
}

struct ShowTrackView: View {
    @ObservedObject var userData: UserData
    
    var gpsLogs: [DisplayPoints] {
        let sortedPoints = userData.points.sorted(by: { return $0.timeStamp < $1.timeStamp })
        var displayPoints = [DisplayPoint]()
        for point in sortedPoints {
            var resPoint = DisplayPoint()
            resPoint.latitude = point.latitude
            resPoint.longitude = point.longitude
            resPoint.timeStamp = timeIntervalChangeToTimeStr(time: point.timeStamp)
            displayPoints.append(resPoint)
        }
        var timeStampFlags = [String]()
        var gpsLogs = [DisplayPoints]()
        for point in displayPoints {
            let date = String(point.timeStamp!.prefix(13))
            if !timeStampFlags.contains(date) {
                timeStampFlags.append(date)
                gpsLogs.append(DisplayPoints(displayPoints: []))
            }
            gpsLogs[gpsLogs.count - 1].displayPoints.append(point)
        }
        return gpsLogs
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: GPSLog.entity(), sortDescriptors: [])
    
    var GPSLogs: FetchedResults<GPSLog>
    
    @State var document = CSVDocument(content: "")
    @State var showExport: Bool = false
    
    @State var showSheet: Bool = false
    
    var body: some View {
        List {
            ForEach(gpsLogs, id: \.id) { track in
                Section {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text(String(track.displayPoints[0].timeStamp!.prefix(14)) + "00~" + "\(Int(track.displayPoints[0].timeStamp!.dropFirst(11).prefix(2))! + 1)" + ":00")
                            .foregroundColor(.primary)
                    })
                    .sheet(isPresented: $showSheet, content: {
                        VStack(alignment: .leading) {
                            Button("Back") {
                                showSheet.toggle()
                            }
                            .padding()
                            TrackMapView(points: track.displayPoints)
                        }
                    })
                }
            }
        }
        .navigationBarTitle("Show Track", displayMode: .inline)
        
        
        Button(action: {
            var text: String = ""
            for log in GPSLogs {
                text += "\(log.latitude),\(log.longitude),\(timeIntervalChangeToTimeStr(time: log.timestamp))\n"
            }
            self.document = CSVDocument(content: text)
            self.showExport.toggle()
        }, label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export Track")
            }
        })
        .padding()
        .fileExporter(isPresented: $showExport,
                      document: self.document,
                      contentType: .commaSeparatedText,
                      defaultFilename: "track") { result in
            switch result {
            case .success:
                print("Export successfully.")
            case .failure:
                print("Export error.")
            }
        }
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
        ShowTrackView(userData: UserData())
    }
}
