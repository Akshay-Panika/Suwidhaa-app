import 'package:get/get.dart';
import '../model/ott_webseries_model.dart';
import '../repository/ott_webseries_repository.dart';

class OttWebSeriesController extends GetxController {
  final OttWebSeriesRepository _repo = OttWebSeriesRepository();

  final Rx<OttWebSeriesModel?> webSeries = Rx<OttWebSeriesModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Currently playing episode (for highlighting / displaying)
  final Rx<OttWebSeriesEpisodeModel?> currentEpisode =
  Rx<OttWebSeriesEpisodeModel?>(null);

  /// Currently selected season number
  final RxInt selectedSeason = 1.obs;

  Future<void> fetchWebSeriesDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final detail = await _repo.fetchWebSeriesDetail(id);
      webSeries.value = detail;
      if (detail.seasons.isNotEmpty) {
        selectedSeason.value = detail.seasons.first.seasonNumber;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get episodes of currently selected season
  List<OttWebSeriesEpisodeModel> get currentSeasonEpisodes {
    final ws = webSeries.value;
    if (ws == null) return const [];
    final season = ws.seasons.firstWhereOrNull(
          (s) => s.seasonNumber == selectedSeason.value,
    );
    return season?.episodes ?? const [];
  }

  void selectSeason(int seasonNumber) {
    selectedSeason.value = seasonNumber;
  }

  void setCurrentEpisode(OttWebSeriesEpisodeModel? ep) {
    currentEpisode.value = ep;
  }

  Future<void> refresh() async {
    final ws = webSeries.value;
    if (ws != null) await fetchWebSeriesDetail(ws.id);
  }
}