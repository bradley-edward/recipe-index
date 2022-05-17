import 'package:flutter/widgets.dart' show TextEditingController;

class MinuteRangeParams {
	String errorMsg;
	final TextEditingController fromController;
	final TextEditingController toController;

	MinuteRangeParams({
		required this.errorMsg,
		required this.fromController,
		required this.toController
	});

	void validateInputs() {
		/*
		int fromInt = int.tryParse(fromController.text);
		int toInt = int.tryParse(toController.text);
		*/
		int? fromInt = int.tryParse(fromController.text);
		int? toInt = int.tryParse(toController.text);

		if (fromController.text.isEmpty && toController.text.isEmpty) {
			errorMsg = 'Please fill in at least one of the fields.';
			return;
		}

		if (fromController.text.isNotEmpty) {
			fromInt = int.tryParse(fromController.text);
			if (fromInt == null) {
				errorMsg = "Please input valid integer in 'From'!";
				return;
			}
		}

		if (toController.text.isNotEmpty) {
			toInt = int.tryParse(toController.text);
			if (toInt == null) {
				errorMsg = "Please input valid integer in 'To'!";
				return;
			}
		}

		if (fromInt != null && toInt != null) {
			if (fromInt > toInt) {
				errorMsg = "'From' cannot be greater than 'To'!";
				return;
			}
		}

		errorMsg = '';
	}

	bool get hasError {
		return errorMsg.isNotEmpty;
	}

	Map<String,int> get intRange {
		final mapToReturn = {
			'from': -1,
			'to': -1,
		};

		if (fromController.text.isNotEmpty) {
			mapToReturn['from'] = int.parse(fromController.text);
		}
		if (toController.text.isNotEmpty) {
			mapToReturn['to'] = int.parse(toController.text);
		}
		
		return mapToReturn;
	}
}