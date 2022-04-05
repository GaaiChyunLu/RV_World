import Foundation

public class UserData: ObservableObject {
    @Published var webAPIKey = "73df26a3aa615bf9f294bbcba69afe44"
    @Published var selectedCityNum = 3
    @Published var csvDataList: CsvDataList?
    @Published var points: [Point] = []
    @Published var stayPoints: [StayPoint] = []
    @Published var selectedAnchors: [Anchor] = []
}
