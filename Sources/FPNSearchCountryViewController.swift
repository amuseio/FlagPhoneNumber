//
//  FPNSearchCountryViewController.swift
//  FlagPhoneNumber
//
//  Created by Aurélien Grifasi on 06/08/2017.
//  Copyright (c) 2017 Aurélien Grifasi. All rights reserved.
//

import UIKit

class FPNSearchCountryViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
	
	var countryNameAttributes: [NSAttributedString.Key: Any]?
	var countryCodeAttributes: [NSAttributedString.Key: Any]?
	
	var searchController: UISearchController?
	var list: [FPNCountry]?
	var results: [FPNCountry]?
	var selectedCountryCode : FPNCountryCode?
	var selectedCellColor : UIColor?

	weak var delegate: FPNDelegate?

	init(countries: [FPNCountry], selectedCountryCode : FPNCountryCode?) {
		self.list = countries
		self.selectedCountryCode = selectedCountryCode
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		initSearchBarController()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if #available(iOS 11.0, *) {
			navigationItem.hidesSearchBarWhenScrolling = false
		} else {
			// Fallback on earlier versions
		}
		
		updateInitialScrollPosition()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController?.isActive = true

	}

	@objc private func dismissController() {
		dismiss(animated: true, completion: nil)
	}
	
	private func updateInitialScrollPosition(){
		tableView.setNeedsLayout()
		tableView.layoutIfNeeded()
		if let countryCode = selectedCountryCode,let index = list?.firstIndex(where: {$0.code == countryCode}){
			tableView.scrollToRow(at: IndexPath(row: index, section: 0),at: .top, animated: false)
			
		}
		
	}
    
	private func initSearchBarController() {
		searchController = UISearchController(searchResultsController: nil)
		searchController?.searchResultsUpdater = self
		searchController?.delegate = self
		searchController?.hidesNavigationBarDuringPresentation = false
		searchController?.searchBar.tintColor = navigationController?.navigationBar.tintColor

		if #available(iOS 9.1, *) {
			searchController?.obscuresBackgroundDuringPresentation = false
		} else {
			// Fallback on earlier versions
		}
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
		} else {
			searchController?.dimsBackgroundDuringPresentation = false
			searchController?.hidesNavigationBarDuringPresentation = false
			searchController?.definesPresentationContext = false

			//				searchController?.searchBar.sizeToFit()
			tableView.tableHeaderView = searchController?.searchBar
		}
		definesPresentationContext = false
	}

	private func getItem(at indexPath: IndexPath) -> FPNCountry {
		var array: [FPNCountry]!

		if let searchController = searchController, searchController.isActive && results != nil && results!.count > 0 {
			array = results
		} else {
			array = list
		}

		return array[indexPath.row]
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let searchController = searchController, searchController.isActive {
			if let count = searchController.searchBar.text?.count, count > 0 {
				return results?.count ?? 0
			}
		}
		return list?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		let country = getItem(at: indexPath)
        
        cell.backgroundColor = tableView.backgroundColor
		cell.textLabel?.attributedText = NSAttributedString(string: country.name, attributes: countryNameAttributes)
		cell.detailTextLabel?.attributedText = NSAttributedString(string: country.phoneCode, attributes: countryCodeAttributes)
		cell.imageView?.image = country.flag
		
		if let selectedCellColor = selectedCellColor{
			let selectedBackgroundView  = UIView()
			selectedBackgroundView.backgroundColor = selectedCellColor
			cell.selectedBackgroundView = selectedBackgroundView
			
		}
		
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//tableView.deselectRow(at: indexPath, animated: true)

		let country = getItem(at: indexPath)
		
		selectedCountryCode = country.code
		delegate?.fpnDidSelect(country: country)

		searchController?.isActive = false
		searchController?.searchBar.resignFirstResponder()
	}
    
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let country = getItem(at: indexPath)
		if let countryCode = selectedCountryCode , country.code == countryCode{
			cell.setSelected(true, animated: false)
			
		}
		
	}
    

	// UISearchResultsUpdating

	func updateSearchResults(for searchController: UISearchController) {
		if list == nil {
			results?.removeAll()
			return
		} else if searchController.searchBar.text == "" {
			results?.removeAll()
			tableView.reloadData()
			return
		}

		if let searchText = searchController.searchBar.text, searchText.count > 0 {
			results = list!.filter({(item: FPNCountry) -> Bool in
				if item.name.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				} else if item.code.rawValue.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				} else if item.phoneCode.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				}
				return false
			})
		}
		tableView.reloadData()
	}

	// UISearchControllerDelegate

	func didPresentSearchController(_ searchController: UISearchController) {
		DispatchQueue.main.async { [unowned self] in
			self.searchController?.searchBar.becomeFirstResponder()
		}
	}

	func willDismissSearchController(_ searchController: UISearchController) {
		results?.removeAll()
	}

	func didDismissSearchController(_ searchController: UISearchController) {
		dismissController()
	}
}
