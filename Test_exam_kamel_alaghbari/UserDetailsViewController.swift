//
//  UserDetailsViewController.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 04/02/2025.
//


import UIKit

// MARK: - User Details ViewController
class UserDetailsViewController: UIViewController {
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = user.name
        setupDetails()
    }

    private func setupDetails() {
        let nameLabel = createLabel(withText: "Name: \(user.name)")
        let emailLabel = createLabel(withText: "Email: \(user.email)")
        let phoneLabel = createLabel(withText: "Phone: \(user.phone)")
        let websiteLabel = createLabel(withText: "Website: \(user.website)")

        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel, phoneLabel, websiteLabel])
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
