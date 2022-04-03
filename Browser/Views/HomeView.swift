import SwiftUI

struct HomeView: View {
    @ObservedObject var userData: UserData
    
    @State private var showImport: Bool = false
    @State private var updateLocationTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var calculateStayPointsTimer = Timer.publish(every: 3600, on: .main, in: .common).autoconnect()
    
    @State var timeInterval: Double = NSDate().timeIntervalSince1970
    
    var locationManager = LocationManager()
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    var body: some View {
        VStack {
            VStack {
                Text("latitude: \(latitude)")
                
                Text("longitude: \(longitude)")
            }
            .onReceive(updateLocationTimer) { _ in
                latitude = locationManager.lastLocation?.coordinate.latitude ?? 0
                longitude = locationManager.lastLocation?.coordinate.longitude ?? 0
                let timeStamp = NSDate().timeIntervalSince1970
                userData.points.append(Point(latitude: latitude, longitude: longitude, timeStamp: timeStamp))
                userData.stayPoints = GetStayPoint(points: userData.points)
            }
//            Text("")
//                .onReceive(calculateStayPointsTimer) { _ in
//                    userData.stayPoints = GetStayPoint(points: userData.points)
//                }
            
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
                            print(url)
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
        
        self.userData.stayPoints = GetStayPoint(points: csvPoints)

        for i in 0 ..< self.userData.stayPoints.count {
            print(self.userData.stayPoints[i].point.latitude)
            print(self.userData.stayPoints[i].point.longitude)
            print(timeIntervalChangeToTimeStr(time: self.userData.stayPoints[i].arriveTime))
            print(timeIntervalChangeToTimeStr(time: self.userData.stayPoints[i].leaveTime))
            print(self.userData.stayPoints[i].typeCode)
            print()
        }
    }
    
    func timeStrChangeTotimeInterval(dateTime: String) -> Double{
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
