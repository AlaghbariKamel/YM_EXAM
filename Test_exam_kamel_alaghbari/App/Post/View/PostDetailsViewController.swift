//
//  PostetailsViewController.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//
import UIKit

// MARK: - User Details ViewController
class PostDetailsViewController: UIViewController {
    private let post: ResponsePost

    init(post: ResponsePost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = post.userId?.description ?? "Post Details"
        setupDetails()
    }

    private func setupDetails() {
        let idLabel = createLabel(withText: "Id: \(post.id ?? 0)")
        let titleLabel = createLabel(withText: "Title: \(post.title ?? "")")
        let bodyLabel = createLabel(withText: "Body: \(post.body ?? "")")
        let userIdLabel = createLabel(withText: "User Id: \(post.userId ?? 0)")

        let stackView = UIStackView(arrangedSubviews: [idLabel, titleLabel, bodyLabel, userIdLabel])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }
}

