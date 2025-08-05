//
//  ContentView.swift
//  WalletApp
//
//  Created by macbook on 8/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var balance: Double = 1250.75
    @State private var transactions: [Transaction] = [
        Transaction(id: UUID(), title: "Coffee Shop", amount: -4.50, date: Date(), category: .food),
        Transaction(id: UUID(), title: "Salary", amount: 2500.00, date: Date().addingTimeInterval(-86400), category: .income),
        Transaction(id: UUID(), title: "Gas Station", amount: -45.00, date: Date().addingTimeInterval(-172800), category: .transport),
        Transaction(id: UUID(), title: "Grocery Store", amount: -85.30, date: Date().addingTimeInterval(-259200), category: .shopping)
    ]
    @State private var creditCards: [CreditCard] = [
        CreditCard(
            id: UUID(),
            cardName: "Groceries",
            cardNumber: "•••• •••• •••• 1234",
            maskedNumber: "•••• •••• •••• 1234",
            fullNumber: "4111111111111234",
            expiryDate: "12/25",
            cvv: "123",
            cardType: .visa,
            isDefault: true,
            cardholderName: "John Doe"
        ),
        CreditCard(
            id: UUID(),
            cardName: "Bills",
            cardNumber: "•••• •••• •••• 5678",
            maskedNumber: "•••• •••• •••• 5678",
            fullNumber: "5555555555555678",
            expiryDate: "09/26",
            cvv: "456",
            cardType: .mastercard,
            isDefault: false,
            cardholderName: "John Doe"
        )
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(balance: $balance, transactions: $transactions, creditCards: $creditCards)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CardsView(creditCards: $creditCards)
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Cards")
                }
                .tag(1)
            
            TransactionsView(transactions: $transactions)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

// MARK: - Home View
struct HomeView: View {
    @Binding var balance: Double
    @Binding var transactions: [Transaction]
    @Binding var creditCards: [CreditCard]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Balance Card
                    BalanceCard(balance: balance)
                    
                    // Credit Cards Preview
                    CreditCardsPreview(creditCards: creditCards)
                    
                    // Quick Actions
                    QuickActionsView()
                    
                    // Recent Transactions
                    RecentTransactionsView(transactions: transactions)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Balance Card
struct BalanceCard: View {
    let balance: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Current Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityLabel("Current balance label")
            
            Text("$\(balance, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .accessibilityLabel("Balance amount: $\(balance, specifier: "%.2f")")
            
            HStack(spacing: 20) {
                Button(action: {
                    // Add money action
                }) {
                    Label("Add Money", systemImage: "plus.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .accessibilityHint("Add money to your wallet")
                
                Button(action: {
                    // Send money action
                }) {
                    Label("Send Money", systemImage: "arrow.up.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .accessibilityHint("Send money to another person")
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Credit Cards Preview
struct CreditCardsPreview: View {
    let creditCards: [CreditCard]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Credit Cards")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(creditCards.count) cards")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(creditCards.prefix(3)) { card in
                        CreditCardPreviewCard(card: card)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct CreditCardPreviewCard: View {
    let card: CreditCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: card.cardType.icon)
                    .font(.title2)
                    .foregroundColor(card.cardType.color)
                
                Spacer()
                
                if card.isDefault {
                    Text("DEFAULT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.blue)
                        )
                }
            }
            
            Text(card.cardName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Text(card.maskedNumber)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            HStack {
                Text("Expires: \(card.expiryDate)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text(card.cardholderName)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(16)
        .frame(width: 200, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(card.cardType.gradient)
        )
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Cards View
struct CardsView: View {
    @Binding var creditCards: [CreditCard]
    @State private var showingAddCard = false
    @State private var selectedCard: CreditCard?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(creditCards) { card in
                        CreditCardRow(card: card) {
                            selectedCard = card
                        }
                    }
                    .onDelete(perform: deleteCards)
                } header: {
                    Text("Your Cards")
                } footer: {
                    Text("Your card information is encrypted and stored securely on your device.")
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCard = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new credit card")
                }
            }
            .sheet(isPresented: $showingAddCard) {
                AddCardView(creditCards: $creditCards)
            }
            .sheet(item: $selectedCard) { card in
                CardDetailView(card: card)
            }
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        creditCards.remove(atOffsets: offsets)
    }
}

struct CreditCardRow: View {
    let card: CreditCard
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: card.cardType.icon)
                    .font(.title2)
                    .foregroundColor(card.cardType.color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(card.cardName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if card.isDefault {
                            Text("DEFAULT")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(card.maskedNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Add Card View
struct AddCardView: View {
    @Binding var creditCards: [CreditCard]
    @Environment(\.dismiss) private var dismiss
    
    @State private var cardName = ""
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var selectedCardType: CardType = .visa
    @State private var isDefault = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Card Information") {
                    TextField("Card Name", text: $cardName)
                        .accessibilityLabel("Card name")
                    
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .accessibilityLabel("Card number")
                    
                    HStack {
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numberPad)
                            .accessibilityLabel("Expiry date")
                        
                        TextField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                            .accessibilityLabel("CVV")
                    }
                    
                    TextField("Cardholder Name", text: $cardholderName)
                        .accessibilityLabel("Cardholder name")
                }
                
                Section("Card Type") {
                    Picker("Card Type", selection: $selectedCardType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.displayName)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Toggle("Set as Default Card", isOn: $isDefault)
                        .accessibilityLabel("Set as default card")
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCard()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !cardName.isEmpty && 
        !cardNumber.isEmpty && 
        !expiryDate.isEmpty && 
        !cvv.isEmpty && 
        !cardholderName.isEmpty
    }
    
    private func saveCard() {
        let newCard = CreditCard(
            id: UUID(),
            cardName: cardName,
            cardNumber: formatCardNumber(cardNumber),
            maskedNumber: maskCardNumber(cardNumber),
            fullNumber: cardNumber,
            expiryDate: expiryDate,
            cvv: cvv,
            cardType: selectedCardType,
            isDefault: isDefault,
            cardholderName: cardholderName
        )
        
        if isDefault {
            // Remove default from other cards
            for i in creditCards.indices {
                creditCards[i].isDefault = false
            }
        }
        
        creditCards.append(newCard)
        dismiss()
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(char)
        }
        return formatted
    }
    
    private func maskCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        let lastFour = String(cleaned.suffix(4))
        return "•••• •••• •••• \(lastFour)"
    }
}

// MARK: - Card Detail View
struct CardDetailView: View {
    let card: CreditCard
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullNumber = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Card Display
                    CreditCardDetailCard(card: card, showingFullNumber: $showingFullNumber)
                    
                    // Card Details
                    VStack(spacing: 16) {
                        DetailRow(title: "Card Name", value: card.cardName)
                        DetailRow(title: "Card Number", value: showingFullNumber ? card.fullNumber : card.maskedNumber)
                        DetailRow(title: "Expiry Date", value: card.expiryDate)
                        DetailRow(title: "CVV", value: showingFullNumber ? card.cvv : "•••")
                        DetailRow(title: "Cardholder", value: card.cardholderName)
                        DetailRow(title: "Card Type", value: card.cardType.displayName)
                        DetailRow(title: "Default Card", value: card.isDefault ? "Yes" : "No")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding()
            }
            .navigationTitle("Card Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CreditCardDetailCard: View {
    let card: CreditCard
    @Binding var showingFullNumber: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: card.cardType.icon)
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    showingFullNumber.toggle()
                }) {
                    Image(systemName: showingFullNumber ? "eye.slash" : "eye")
                        .foregroundColor(.white)
                }
                .accessibilityLabel(showingFullNumber ? "Hide card details" : "Show card details")
            }
            
            Text(card.cardName)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(showingFullNumber ? card.fullNumber : card.maskedNumber)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expires")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(card.expiryDate)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("CVV")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(showingFullNumber ? card.cvv : "•••")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            
            Text(card.cardholderName)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(card.cardType.gradient)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Quick Actions
struct QuickActionsView: View {
    let actions = [
        QuickAction(title: "Scan QR", icon: "qrcode.viewfinder", color: .blue),
        QuickAction(title: "Pay Bills", icon: "creditcard.fill", color: .green),
        QuickAction(title: "Invest", icon: "chart.line.uptrend.xyaxis", color: .orange),
        QuickAction(title: "Cards", icon: "creditcard", color: .purple)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(actions) { action in
                    QuickActionCard(action: action)
                }
            }
        }
    }
}

struct QuickActionCard: View {
    let action: QuickAction
    
    var body: some View {
        Button(action: {
            // Handle action
        }) {
            VStack(spacing: 12) {
                Image(systemName: action.icon)
                    .font(.title2)
                    .foregroundColor(action.color)
                
                Text(action.title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(action.title) quick action")
    }
}

// MARK: - Recent Transactions
struct RecentTransactionsView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Transactions")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 12) {
                ForEach(transactions.prefix(3)) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Icon
            Image(systemName: transaction.category.icon)
                .font(.title3)
                .foregroundColor(transaction.category.color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(transaction.category.color.opacity(0.1))
                )
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(transaction.amount >= 0 ? .green : .red)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(transaction.title), \(transaction.amount >= 0 ? "received" : "spent") $\(abs(transaction.amount), specifier: "%.2f")")
    }
}

// MARK: - Transactions View
struct TransactionsView: View {
    @Binding var transactions: [Transaction]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var biometricEnabled = false
    @State private var autoLockEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Security") {
                    Toggle("Face ID / Touch ID", isOn: $biometricEnabled)
                        .accessibilityLabel("Enable biometric authentication")
                    
                    Toggle("Auto-Lock", isOn: $autoLockEnabled)
                        .accessibilityLabel("Enable auto-lock when app is backgrounded")
                    
                    NavigationLink("Change Passcode") {
                        Text("Change Passcode")
                    }
                }
                
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .accessibilityLabel("Enable notifications")
                    
                    NavigationLink("Privacy Settings") {
                        Text("Privacy Settings")
                    }
                }
                
                Section("Data & Storage") {
                    NavigationLink("Export Data") {
                        Text("Export Data")
                    }
                    
                    NavigationLink("Backup & Restore") {
                        Text("Backup & Restore")
                    }
                }
                
                Section("Support") {
                    NavigationLink("Help & Support") {
                        Text("Help & Support")
                    }
                    
                    NavigationLink("About") {
                        Text("About Wallet App")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Data Models
struct Transaction: Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let category: TransactionCategory
}

struct CreditCard: Identifiable {
    let id: UUID
    let cardName: String
    let cardNumber: String
    let maskedNumber: String
    let fullNumber: String
    let expiryDate: String
    let cvv: String
    let cardType: CardType
    var isDefault: Bool
    let cardholderName: String
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

enum TransactionCategory: CaseIterable {
    case food, transport, shopping, income, entertainment
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .income: return "dollarsign.circle.fill"
        case .entertainment: return "tv.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .shopping: return .purple
        case .income: return .green
        case .entertainment: return .pink
        }
    }
}

enum CardType: String, CaseIterable {
    case visa = "visa"
    case mastercard = "mastercard"
    case amex = "amex"
    case discover = "discover"
    
    var displayName: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .amex: return "American Express"
        case .discover: return "Discover"
        }
    }
    
    var icon: String {
        switch self {
        case .visa: return "creditcard.fill"
        case .mastercard: return "creditcard.fill"
        case .amex: return "creditcard.fill"
        case .discover: return "creditcard.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .visa: return .blue
        case .mastercard: return .red
        case .amex: return .green
        case .discover: return .orange
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .visa:
            return LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .mastercard:
            return LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .amex:
            return LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .discover:
            return LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    ContentView()
}
