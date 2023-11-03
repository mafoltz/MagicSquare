//
//  SettingsViewController.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 22/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var tableView: UITableView?

    private lazy var interactor = SettingsInteractor(viewController: self)

    weak var delegate: GameSceneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }

    func updateSettings(at indexPaths: [IndexPath]) {
        tableView?.reloadRows(at: indexPaths, with: .automatic)
    }

    func routeToAbout() {
        print("Route to about")
    }

    private func setUpElements() {
        title = "Settings"
        imageView?.image = UIImage(named: "EsleConfig")

        tableView?.register(UINib(nibName: SettingsTableViewCell.Identifier, bundle: .main),
                            forCellReuseIdentifier: SettingsTableViewCell.Identifier)
        tableView?.dataSource = self
        tableView?.delegate = self

        let doneButton = UIBarButtonItem(title: "Done", image: nil, target: self, action: #selector(didTapDone))
        navigationItem.setRightBarButton(doneButton, animated: false)
    }

    @objc private func didTapDone() {
        self.dismiss(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.refreshSceneElements()
        super.viewWillDisappear(animated)
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.sections[section].elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.Identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }

        let currentSetting = interactor.sections[indexPath.section].elements[indexPath.row]
        settingsCell.configure(setting: currentSetting, isOn: interactor.settings[currentSetting] ?? false)

        return settingsCell
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        interactor.sections[section].title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelectRow(at: indexPath)
    }
}
