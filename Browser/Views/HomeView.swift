import SwiftUI
import CoreData

struct HomeView: View {
    @ObservedObject var userData: UserData
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GPSLog.entity(), sortDescriptors: [])
    
    var GPSLogs: FetchedResults<GPSLog>
    
    @State private var showImport: Bool = false
    @State private var updateLocationTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var locationManager = LocationManager()
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    @State private var upDateCoreData: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                Text("latitude: \(latitude)")
                
                Text("longitude: \(longitude)")
            }
            .onReceive(updateLocationTimer) { _ in
                if upDateCoreData {
                    for i in 0 ..< GPSLogs.count {
                        let latitude = GPSLogs[i].latitude
                        let longitude = GPSLogs[i].longitude
                        let timestamp = GPSLogs[i].timestamp
                        userData.points.append(Point(latitude: latitude, longitude: longitude, timeStamp: timestamp))
                    }
                    upDateCoreData = false
                }
                
                latitude = locationManager.lastLocation?.coordinate.latitude ?? 0
                longitude = locationManager.lastLocation?.coordinate.longitude ?? 0
                let timestamp = NSDate().timeIntervalSince1970
                userData.points.append(Point(latitude: latitude, longitude: longitude, timeStamp: timestamp))
                
                let point = GPSLog(context: self.viewContext)
                point.id = UUID()
                point.latitude = latitude
                point.longitude = longitude
                point.timestamp = timestamp
                try? self.viewContext.save()
            }
            
//            Button("print") {
//                for i in 0 ..< userData.points.count {
//                    print(timeIntervalChangeToTimeStr(time: userData.points[i].timeStamp))
//                }
//                
//            }
            
            HStack {
                Image(systemName: "pause.circle")
                    .foregroundColor(.blue)
                    .font(.homeTitle)
                
                Text("RV World")
                    .font(.system(size: 50))
            }
            .padding()
            
            Stepper(value: $userData.selectedCityNum, in: 1...5) {
                Text("Number of positions: \(userData.selectedCityNum)", tableName: "LocalizableWithVariable")
                    .font(.headline)
            }
            .padding(.horizontal, 80)
            
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        showImport.toggle()
                    }, label: {
                        Text("Select File")
                            .padding(5)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    })
                    .fileImporter(isPresented: $showImport, allowedContentTypes: [.text], onCompletion: { result in
                        switch result {
                        case .success(let url):
                            do {
                                _ = url.startAccessingSecurityScopedResource()
                                let fileData = try Data(contentsOf: url)
                                if let text = String(data: fileData, encoding: .utf8) {
                                    userData.csvDataList = CsvDataList(csvText: text)
                                    InsertCsvToStayPoints()
                                }
                                url.stopAccessingSecurityScopedResource()
                            }
                            catch let error {
                                print(error)
                            }
                        case .failure(let error):
                            print(error)
                        }
                        $showImport.wrappedValue = false
                    })
                    .padding()
                }
            }
        }
    }
    
    func InsertCsvToStayPoints() {
        var csvPoints = [Point]()
        var node = self.userData.csvDataList?.head
        
        while node?.next != nil {
            let latitude = Double(node?.csvData.latitude ?? "0") ?? 0
            let longitude = Double(node?.csvData.longitude ?? "0") ?? 0
            let csvDateTime = node?.csvData.dateTime ?? "1971-1-1 00:00:00"
            let timeStamp = timeStrChangeTotimeInterval(dateTime: csvDateTime)
            
            csvPoints.append(Point(latitude: latitude, longitude: longitude, timeStamp: timeStamp))
            node = node?.next
        }
        
        self.userData.csvStayPoints = GetStayPoint(points: csvPoints)

        for i in 0 ..< self.userData.csvStayPoints.count {
            print(self.userData.csvStayPoints[i].point.latitude)
            print(self.userData.csvStayPoints[i].point.longitude)
            print(timeIntervalChangeToTimeStr(time: self.userData.csvStayPoints[i].arriveTime))
            print(timeIntervalChangeToTimeStr(time: self.userData.csvStayPoints[i].leaveTime))
            print(self.userData.csvStayPoints[i].typeCode)
            print()
        }
    }
    
    func timeStrChangeTotimeInterval(dateTime: String) -> Double {
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = format.date(from: dateTime)
        return date!.timeIntervalSince1970
    }
    
    func timeIntervalChangeToTimeStr(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userData: UserData())
    }
}
