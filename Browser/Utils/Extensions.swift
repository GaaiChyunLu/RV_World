import SwiftUI

extension Font {
    static let homeTitle: Font = system(size: 120, weight: .bold)
}

extension Date {
    func GetTimeInMinute() -> Int {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        return hour * 60 + minute
    }
}
