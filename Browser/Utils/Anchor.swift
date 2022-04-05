import Foundation

//public class City: ObservableObject {
//    @Published var Chengdu = Point(latitude: 30.660897, longitude: 104.088089)
//    @Published var Beijing = Point(latitude: 39.940193, longitude: 116.460954)
//    @Published var Shanghai = Point(latitude: 31.242941, longitude: 121.497142)
//    @Published var Xiamen = Point(latitude: 24.478001, longitude: 118.117939)
//}

struct Cities {
    let Chengdu = Point(latitude: 30.660897, longitude: 104.088089)
}

struct Anchor: Identifiable, Hashable {
    let name: String
    let id = UUID()
}
