//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Kenneth Oliver Rathbun on 4/24/24.
//

import Foundation
import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    
    @State private var searchQuery = ""
    
    var filteredUsers: [User] {
        if searchQuery.isEmpty {
            return users
        }
        
        let filteredUsers = users.compactMap { user in
            let userContainsQuery = user.name.range(of: searchQuery, options: .caseInsensitive) != nil
            
            return userContainsQuery ? user : nil
        }
        
        return filteredUsers
    }
    
    init(minJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minJoinDate
        }, sort: sortOrder)
    }
    
    var body: some View {
        List {
            ForEach(users) { user in
                HStack {
                    Text(user.name)
                    
                    Spacer()
                    
                    Text(String(user.jobs.count))
                        .fontWeight(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
            .onDelete(perform: deleteUsers)
            
            Button("Add sample", systemImage: "plus") {
                addSample()
            }
        }
        .searchable(text: $searchQuery)
        .overlay {
            if filteredUsers.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
    
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)
        
        modelContext.insert(user1)
        
        user1.jobs.append(job1)
        user1.jobs.append(job2)
    }
    
    func deleteUsers(at offsets: IndexSet) {
        for offset in offsets {
            let user = users[offset]
            modelContext.delete(user)
        }
    }
}

#Preview {
    UsersView(minJoinDate: .distantPast, sortOrder: [
        SortDescriptor(\User.name)
    ])
    .modelContainer(for: User.self)
}
