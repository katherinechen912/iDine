import SwiftUI

struct OrderHistoryView: View {
    @Environment(Order.self) var order
    
    var body: some View {
        ZStack {
            // Reuses your signature animated aura.
            AppBackground()
            
            if order.orderHistory.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(order.orderHistory) { record in
                        // This is effectively our 'HistoryItemRow'.
                        historyRow(for: record)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Order History")
    }
    
    // Breakdown of a single historical entry row.
    private func historyRow(for record: OrderRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(record.items.count) Items")
                    .font(.headline)
            }
            Spacer()
            Text("$\(record.totalPrice)")
                .font(.title3.bold())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath").font(.system(size: 60)).foregroundColor(.gray)
            Text("No history yet").font(.headline).foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        OrderHistoryView()
            .environment(Order())
    }
}
