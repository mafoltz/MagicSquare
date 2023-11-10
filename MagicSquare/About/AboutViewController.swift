//
//  AboutViewController.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 04/11/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView?

    private var viewModel = AboutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About Us"
        tableView?.register(UINib(nibName: AboutTableViewCell.identifier, bundle: .main),
                            forCellReuseIdentifier: AboutTableViewCell.identifier)

        tableView?.allowsSelection = false
        tableView?.dataSource = self
        tableView?.delegate = self
    }
}

extension AboutViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.teamMembers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.identifier,
                                                       for: indexPath) as? AboutTableViewCell,
                let teamMember = viewModel.teamMembers[safe: indexPath.row] else { return UITableViewCell() }

        cell.configure(teamMember: teamMember)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerNote
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footNote
    }
}
