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
        delegate?.refreshSceneElements()
        self.dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.Identifier,
                                                               for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }

        let currentSetting = interactor.sectionElements[indexPath.row]
        settingsCell.configure(setting: currentSetting, isOn: interactor.settings[currentSetting] ?? false)

        return settingsCell
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelectRow(at: indexPath)
    }
}