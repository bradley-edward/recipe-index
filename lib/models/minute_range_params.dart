import 'package:flutter/material.dart' show RangeValues;

class MinuteRangeParams {
	String errorMsg;
	RangeValues intRange;

	MinuteRangeParams({
		required this.errorMsg,
		required this.intRange,
	});

	Map<String,int> get rangeMap {
		final mapToReturn = {
			'from': -1,
			'to': -1,
		};

		mapToReturn['from'] = intRange.start.round();
		mapToReturn['to'] = intRange.end.round();

		return mapToReturn;
	}
}