//
//  PostController.swift
//  RedditApp
//
//  Created by Marina Basaeva on 7/20/22.
//

import Foundation
import UIKit


class PostController {
    
    static let baseURL = URL(string: "https://www.reddit.com")
    static let rComponent = "r"
    static let jsonExtension = "json"
    
    
    // https://www.reddit.com/r/funny.json
    static func fetchPostsWith(searchTerm: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        
        let rURL = baseURL.appendingPathComponent(rComponent)
        
        let searchURL = rURL.appendingPathComponent(searchTerm)
        
        let finalURL = searchURL.appendingPathExtension(jsonExtension)
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelObject = topLevelObject.data
                let thirdLevelObject = secondLevelObject.children
                
                var arrayOfPosts: [Post] = []
                
                for dict in thirdLevelObject {
                    let post = dict.data
                    arrayOfPosts.append(post)
                }
                
                return completion(.success(arrayOfPosts))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchThumbnailFor(post: Post, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
        guard let thumbnailURL = URL(string: post.thumbnail) else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("THUMBNAIL STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            
            return completion(.success(thumbnail))
            
        }.resume()
    }
    
    
}// End of class
