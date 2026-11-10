import 'package:get/get.dart';
import '../model/ott_tvshows_model.dart';
import '../repository/ott_tvshows_repository.dart';

class OttTvShowsController extends GetxController {
  final OttTvShowsRepository _repo = OttTvShowsRepository();

  final Rx<OttTvShowsModel?> tvShow = Rx<OttTvShowsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Currently playing episode
  final Rx<OttTvShowsEpisodeModel?> currentEpisode =
  Rx<OttTvShowsEpisodeModel?>(null);

  /// Currently selected season number
  final RxInt selectedSeason = 1.obs;

  Future<void> fetchTvShowDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final detail = await _repo.fetchTvShowsDetail(id);
      tvShow.value = detail;
      if (detail.seasons.isNotEmpty) {
        selectedSeason.value = detail.seasons.first.seasonNumber;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Episodes of currently selected season
  List<OttTvShowsEpisodeModel> get currentSeasonEpisodes {
    final show = tvShow.value;
    if (show == null) return const [];
    final season = show.seasons.firstWhereOrNull(
          (s) => s.seasonNumber == selectedSeason.value,
    );
    return season?.episodes ?? const [];
  }

  void selectSeason(int seasonNumber) {
    selectedSeason.value = seasonNumber;
  }

  void setCurrentEpisode(OttTvShowsEpisodeModel? ep) {
    currentEpisode.value = ep;
  }

  Future<void> refresh() async {
    final show = tvShow.value;
    if (show != null) await fetchTvShowDetail(show.id);
  }
}