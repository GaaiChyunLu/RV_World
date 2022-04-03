import SwiftUI

struct Test: View {
    @ObservedObject var userData: UserData
    @State var JSONString: String = "waiting"
    var body: some View {
        Text(JSONString)
            .onAppear {
                CoordinateToTypeCode()
            }
    }
    
    func CoordinateToTypeCode() {
        let url: URL = URL(string: "https://restapi.amap.com/v3/place/around?key=\(self.userData.webAPIKey)&location=30.757786,103.9295&keywords=&types=&radius=&offset=1&page=1&extensions=base")!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("text/plain", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data,
               let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode,
               let strData = String(bytes: data, encoding: .utf8) {
                self.JSONString = strData
            }
        }
        .resume()
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(userData: UserData())
    }
}

