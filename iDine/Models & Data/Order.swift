import SwiftUI
import Observation

// 1. Define what a "Past Order" looks like.
struct OrderRecord: Identifiable {
    let id = UUID()
    let date: Date
    let items: [MenuItem]
    let totalPrice: Int
}

@Observable
class Order {
    var items = [MenuItem]()
    var favorites = [MenuItem]()
    
    // 2. The archive of all completed orders.
    var orderHistory = [OrderRecord]()
    
    var userName: String = ""
    var guestCount: Int = 1
    var isLoggedIn: Bool = false

    var total: Int {
        items.count > 0 ? items.reduce(0) { $0 + $1.price } : 0
    }

    // MARK: - Cart Operations
    func add(item: MenuItem) {
        items.append(item)
    }
    
    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    // 3. NEW: Logic to move current items into history.
    func finalizeOrder() {
        let newRecord = OrderRecord(date: Date(), items: items, totalPrice: self.total)
        // Inserts at the beginning of the array so latest shows first.
        orderHistory.insert(newRecord, at: 0)
    }
    
    // MARK: - Favorite Operations
    func isFavorite(_ item: MenuItem) -> Bool {
        return favorites.contains { $0.id == item.id }
    }
    
    func toggleFavorite(_ item: MenuItem) {
        if isFavorite(item) {
            if let index = favorites.firstIndex(where: { $0.id == item.id }) {
                favorites.remove(at: index)
            }
        } else {
            favorites.append(item)
        }
    }
}
