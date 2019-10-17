import UIKit

class FPNCountryView: NibLoadingView {

	@IBOutlet weak var flagImageView: UIImageView!
	@IBOutlet weak var countryNameLabel: UILabel!
	@IBOutlet weak var countryCodeLabel: UILabel!

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
