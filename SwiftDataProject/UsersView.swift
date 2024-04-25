//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Kenneth Oliver Rathbun on 4/24/24.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    
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
        List(filteredUsers) { user in
            Text(user.name)
        }
        .searchable(text: $searchQuery)
        .overlay {
            if filteredUsers.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    UsersView(minJoinDate: .distantPast, sortOrder: [
        SortDescriptor(\User.name)
    ])
    .modelContainer(for: User.self)
}
