import SwiftUI
import MapKit

struct StayPointView: View {
    @ObservedObject var userData: UserData
    
    @State private var mapLatitude: CLLocationDegrees = 0
    @State private var mapLongitude: CLLocationDegrees = 0
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Button("Calculate Stay Points") {
                        userData.userStayPoints = GetStayPoint(points: userData.points)
                    }
                }
                
                ForEach(0 ..< userData.userStayPoints.count, id: \.self) { i in
                    NavigationLink(destination: MapView(latitude: self.$mapLatitude, longitude: self.$mapLongitude)) {
                        Text("Stay Point \(i)")
                    }
                    .onAppear() {
                        self.mapLatitude = userData.userStayPoints[i].point.latitude
                        self.mapLongitude = userData.userStayPoints[i].point.longitude
                    }
                }
                
            }
            .navigationTitle("Stay Point")
        }
    }
}

struct StayPointView_Previews: PreviewProvider {
    static var previews: some View {
        StayPointView(userData: UserData())
    }
}
