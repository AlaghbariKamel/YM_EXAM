//
//  PostEntryViewController.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import UIKit
import RxSwift
import RxCocoa
// MARK: - Post Entry ViewController
class PostEntryViewController: UIViewController {
    
    private var viewModel:PostViewModel? = nil
    private let disposeBag = DisposeBag()
    private let userIdField = UITextField()
    private let titleField = UITextField()
    private let bodyTextView = UITextView()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Post"
        setupForm()
        viewModel = PostViewModel()
        subscribeToLoading()
        subscribeToErrorMessage()

        subscribeToResponse()
    }

    private func setupForm() {
        userIdField.placeholder = "User ID"
        userIdField.borderStyle = .roundedRect
        userIdField.keyboardType = .numberPad

        titleField.placeholder = "Title"
        titleField.borderStyle = .roundedRect

        bodyTextView.layer.borderColor = UIColor.gray.cgColor
        bodyTextView.layer.borderWidth = 1
        bodyTextView.layer.cornerRadius = 8
        bodyTextView.font = UIFont.systemFont(ofSize: 16)

        submitButton.setTitle("Submit Post", for: .normal)
        submitButton.addTarget(self, action: #selector(submitPost), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [userIdField, titleField, bodyTextView, submitButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bodyTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    
    
    func subscribeToErrorMessage()
    {
        viewModel?.messageError.subscribe(onNext: {[weak self] errorMessage in
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.displayMessage(titleMsg: "Error", message:  "\(errorMessage)" , messageStatus: .MessageError)
                
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeToLoading()
    {
        viewModel?.loadingBehavior.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingDialog()
                } else {
                    
                    self.hideMyDialog()
                }
            }
        }).disposed(by: disposeBag)
    }

    
    
    func subscribeToResponse()
    {
        
        viewModel?.onePostsModelObservable.subscribe(onNext: {[weak self] post in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let post = post
                {
                    
                    
                    self.showAlert(title: "Success", message: "Post Submitted: \(post.title ?? "")")
                    
                }
                else {
                    self.showAlert(title: "Error", message: "Data Not Saved")
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    @objc private func submitPost() {
        guard
            let userIdText = userIdField.text, let userId = Int(userIdText),
            let title = titleField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill all fields correctly.")
            return
        }

       
        let newPost = ResponsePost(userId: userId, id: 1, title: title, body: body)

        if InternetConnectionManager.isConnectedToNetwork()
        {
            viewModel?.addPost(post: newPost)
        }
        else
        {
            
            self.displayMessage(titleMsg: "Warning", message: "No Internet Connection", messageStatus: .MessageError)
        }
       
//        NetworkManager.shared.submitPost(post: newPost) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let post):
//                    self?.showAlert(title: "Success", message: "Post Submitted: \(post.title ?? "")")
//                case .failure(let error):
//                    self?.showAlert(title: "Error", message: error.localizedDescription)
//                }
//            }
//        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
