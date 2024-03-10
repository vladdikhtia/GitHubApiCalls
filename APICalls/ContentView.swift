//
//  ContentView.swift
//  APICalls
//
//  Created by Vladyslav Dikhtiaruk on 10/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var userLog: String = "vladdikhtia"
    @State private var user: GitHubUser?
    var body: some View {
        NavigationStack{
            Form {
                TextField("GitHub Name", text: $userLog)
                    .textCase(.lowercase)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.circle)
                    
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                }
                
                Section("Name") {
                    Text(user?.login ?? "Login Placeholder")
                        .font(.title)
                }
                Section("Bio") {
                    Text(user?.bio ?? "Bio Placeholder")
                        .font(.subheadline)
                }
                
            }
            
            .navigationTitle("GitHub User")
            
        }
//        .onChange(of: userLog, fetchUser)
        
//        .task {
//            do {
//                user = try await getUser()
//            } catch GHError.invalidURL {
//                print("invalid URL")
//            } catch GHError.invalidResponse {
//                print("Invalid Response")
//            } catch GHError.invalidData {
//                print("Invalid Data sa")
//            } catch {
//                print("Unexpected error")
//            }
//        }
        .onSubmit {
            fetchUser()
        }
        
        
        
    }
    func fetchUser() {
        Task {
            do {
                user = try await getUser()
            } catch GHError.invalidURL {
                print("invalid URL")
            } catch GHError.invalidResponse {
                print("Invalid Response")
            } catch GHError.invalidData {
                print("Invalid Data sa")
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/\(userLog)"
        
        guard let url = URL(string: endpoint) else { // string to url
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // 200 means everything is ok
            throw GHError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}

#Preview {
    ContentView()
}

enum GHError: Error {
    case invalidURL,
         invalidResponse,
         invalidData
}
