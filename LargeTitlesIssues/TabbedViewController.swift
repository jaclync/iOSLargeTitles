//
//  TabbedViewController.swift
//  LargeTitlesIssues
//
//  Created by Jaclyn Chen on 12/28/20.
//

import UIKit

final class TabbedViewController: UIViewController {
    private let firstTableView: UITableView = .init(frame: .zero, style: .grouped)
    private let secondTableView: UITableView = .init(frame: .zero, style: .plain)

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = .init(title: "Tabbed", image: .checkmark, tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["Today", "This Week"]
        let segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.addTarget(self, action: #selector(tabSelected(_:)), for: .valueChanged)

        navigationItem.titleView = segmentedControl

        [firstTableView, secondTableView].forEach { tableView in
            tableView.dataSource = self
            tableView.delegate = self
        }

        segmentedControl.selectedSegmentIndex = 0
        tabSelected(segmentedControl)
    }
}

extension TabbedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        return cell
    }
}

extension TabbedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailsViewController = DetailsViewController()
        detailsViewController.navigationItem.largeTitleDisplayMode = .never
        show(detailsViewController, sender: self)
    }
}

private extension TabbedViewController {
    @objc private func tabSelected(_ segmentedControl: UISegmentedControl) {
        let tableView: UITableView
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView = firstTableView
            secondTableView.removeFromSuperview()
            navigationItem.title = "Hello"
        case 1:
            tableView = secondTableView
            firstTableView.removeFromSuperview()
            view.bringSubviewToFront(secondTableView)
            navigationItem.title = "There there"
        default:
            return
        }
        // 👋 If there are two scroll views in the view hierarchy, only the first scroll view's vertical scroll events are observed by the
        // navigation bar. If we only show/hide the corresponding table view on tab selection, you'd notice the second table view never
        // triggers the large title to shrink.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
        ])
    }
}
