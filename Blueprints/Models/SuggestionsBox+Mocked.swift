import Foundation

extension SuggestionsBox {
    enum Mocked {
        static var daysLikeToday: SuggestionsBox {
            SuggestionsBox(title: "Days like today", prints: [
                Blueprint.Mocked.cap,
                Blueprint.Mocked.mark,
                Blueprint.Mocked.kratos,
                Blueprint.Mocked.wayne,
            ], forUser: "zheref")
        }
    }
}
