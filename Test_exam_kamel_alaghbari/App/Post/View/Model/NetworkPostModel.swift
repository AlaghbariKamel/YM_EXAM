//
//  NetworkPostModel.swift
//  CleanArchitecture
//
//  Created by Kamel Alaghbari on 05/02/2025.
//  Copyright © 2025 harsivo. All rights reserved.
//

enum PostsNetworking {

    case getPost(String)
    case getPosts
    case addPost([String:Any])
    
}
 
extension PostsNetworking:TargetType
{
    
 
    var path: String {
        switch self {
        case .getPost(let id):
            return "posts/\(id)"
        case  .getPosts , .addPost:
            return "posts"
//        case .getPost:
//            return "posts"
//        case .getPosts:
//            return "posts"
//        case .setPost:
//            return "posts"
         
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
 
        case .getPost, .getPosts:
            return .get
        default:
            return .post
        }
    }
    
    var taskPostData: TaskPostData {
        switch self {
        case  .getPost,.getPosts:
            return .requsetPlain;
        case .addPost(let dic) :
 
            return .requestParameters(parameters : dic)
        }
    }
    
    var taskURLQueryParameter: TaskURLQueryParameter {
        switch self {
 
        case .getPost,.getPosts:
            return .requsetPlain;
        case .addPost(let dic) :
 
            return .requestURLQueryParameters(parameters : dic)
        }
    }
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
            
        }
    }
    
    
}



protocol PostAPIProtocol {
    
    var postId:String{get set}
    func getPost(completion: @escaping(Result<ResponsePost?,ServiceError>) -> Void )
    func getAllPosts(completion: @escaping(Result<[ResponsePost]?,ServiceError>) -> Void )
    func addPost(completion: @escaping(Result<ResponsePost?,ServiceError>) -> Void)


    var dicValuePostData:[String:Any]
    {
        get
        set

    }
    var dicValueURLQueryParameter:[String:Any]
    {
        get
        set

    }
}
 





