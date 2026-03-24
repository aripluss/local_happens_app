import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_happens/core/constants/app_colors.dart';
import 'package:local_happens/core/constants/app_text_styles.dart';
import 'package:local_happens/features/events/presentation/widgets/events_categories_list.dart';
import 'package:local_happens/features/events/presentation/widgets/events_search_bar.dart';
import 'package:local_happens/features/events/presentation/widgets/events_sliver_grid.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: AppColors.background,
              statusBarIconBrightness: Brightness.dark,
            ),
            floating: true,
            snap: true,
            pinned: false,
            toolbarHeight: 0,
            backgroundColor: AppColors.background,
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(isLandscape ? 210.0 : 239.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: isLandscape ? 20 : 56),
                    const Text('LocalHappens', style: AppTextStyles.headline),
                    const SizedBox(height: 2),
                    const Text(
                      'Знаходь цікаве поруч',
                      style: AppTextStyles.value,
                    ),
                    SizedBox(height: isLandscape ? 16 : 24),
                    EventsSearchBar(searchController: _searchController),
                    SizedBox(height: isLandscape ? 16 : 24),
                    const EventsCategoriesList(),
                    SizedBox(height: isLandscape ? 20 : 32),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: EventsSliverGrid(),
          ),
        ],
      ),
    );
  }
}
