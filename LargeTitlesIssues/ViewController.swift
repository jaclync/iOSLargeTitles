//
//  ViewController.swift
//  LargeTitlesIssues
//
//  Created by Jaclyn Chen on 12/25/20.
//

import UIKit

final class ViewController: UIViewController {
    private var randomView = UIView(frame: .zero)

    /// Main TableView
    ///
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()

    /// Pull To Refresh Support.
    ///
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = .init(title: "Table", image: .checkmark, tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Testing large titles"
        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground

        // 👋 If you uncomment the following code to add a random view in the vertical axis, the large title stops shrinking on vertical scroll events.
//        randomView.backgroundColor = .red
//        randomView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(randomView)
//        NSLayoutConstraint.activate([
//            view.leadingAnchor.constraint(equalTo: randomView.leadingAnchor, constant: 0),
//            view.trailingAnchor.constraint(equalTo: randomView.trailingAnchor, constant: 0),
//            view.topAnchor.constraint(equalTo: randomView.topAnchor, constant: 0),
//            randomView.heightAnchor.constraint(equalToConstant: 30)
//        ])

        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 👋 If you uncomment the following line and the corresponding line in `viewWillDisappear`, you'll notice the large title lingering while navigating to
        // the next view controller.
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewWillDisappear(animated)
    }
}

private extension ViewController {
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
        ])

        tableView.dataSource = self
        tableView.delegate = self

        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.rowHeight = UITableView.automaticDimension

        // Removes extra header spacing in ghost content view.
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionHeaderHeight = 0

        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none

        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: Int(100)))
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "Long\nLong\nText!"
            return label
        }()
        headerContainer.addSubview(label)
        NSLayoutConstraint.activate([
            headerContainer.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0),
            headerContainer.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0),
            headerContainer.topAnchor.constraint(equalTo: label.topAnchor, constant: 0),
            headerContainer.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
        ])
        tableView.tableHeaderView = headerContainer
    }
}

private extension ViewController {
    @objc private func pullToRefresh(sender: UIRefreshControl) {
        perform(#selector(endRefreshing), with: nil, afterDelay: 1)
    }

    @objc func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailsViewController = DetailsViewController()
        detailsViewController.navigationItem.largeTitleDisplayMode = .never
        show(detailsViewController, sender: self)
    }
}
