int nowSecondsEpoch() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).round();
}

String formatTimestampToYMDHIS(int inputTimestamp) {
  final dateNow = DateTime.fromMillisecondsSinceEpoch(inputTimestamp * 1000);

  final dateStr = '${dateNow.year}-${dateNow.month.toString().padLeft(2,'0')}-${dateNow.day.toString().padLeft(2,'0')}';
  final timeStr = '${dateNow.hour.toString().padLeft(2,'0')}:${dateNow.minute.toString().padLeft(2,'0')}';
  return '$dateStr $timeStr';
}