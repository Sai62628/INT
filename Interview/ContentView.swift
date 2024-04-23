//
//  ContentView.swift
//  Interview
//
//  Created by Sai Krishna on 17/04/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var todos = [Todo]()
    
    var body: some View {
        List(todos, id: \.id) { todo in
            Text(todo.title)
        }
        .onAppear {
            fetchData()
        }
    }
//    func fetchFromServer(){
//        List(todos, id: \.id) { todo in
//            Text(todo.title)
//        }
//        .onAppear {
//            fetchData()
//        }
//    }
    
    func fetchData() {
        // URL of the JSON data
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        
        // Create a URLRequest with GET method
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create a URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check if data is available
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse JSON data
            do {
                // Decode JSON into an array of Todo objects
                let decodedData = try JSONDecoder().decode([Todo].self, from: data)
                
                // Update UI on the main thread
                DispatchQueue.main.async {
                    print(decodedData)
                    self.todos = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
