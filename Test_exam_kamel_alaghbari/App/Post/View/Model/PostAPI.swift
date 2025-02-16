//
//  PostAPI.swift
//  CleanArchitecture
//
//  Created by Kamel Alaghbari on 05/02/2025.
//  Copyright © 2025 harsivo. All rights reserved.
//

//typealias APIPostHandler = PostAPIProtocol //& BaseAPI<PostsNetworking>

class PostAPI : PostAPIProtocol
{
    var postId: String = ""
    
    let baseAPi = BaseAPI<PostsNetworking>()
    
    func getAllPosts(completion: @escaping (Result<[ResponsePost]?, ServiceError>) -> Void) {
        baseAPi.fetchData(target: .getPosts, responseClass: [ResponsePost].self) { (reslut) in
            completion(reslut)
        }
    }
    
   
    
    func getPost(completion: @escaping (Result<ResponsePost?, ServiceError>) -> Void) {
        
        baseAPi.fetchData(target: .getPost(postId), responseClass: ResponsePost.self) { (reslut) in
            completion(reslut)
        }
    }
    
    func addPost(completion: @escaping (Result<ResponsePost?, ServiceError>) -> Void) {
        baseAPi.fetchData(target: .addPost(dicValuePostData), responseClass: ResponsePost.self) { (reslut) in
            completion(reslut)
        }
    }
    
    var dicValuePostData: [String : Any] = [:]
    
    var dicValueURLQueryParameter: [String : Any] = [:]
    
    




}
