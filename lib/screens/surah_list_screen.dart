import 'package:flutter/material.dart';
import 'surah_reader_screen.dart';

import '../core/app_spacing.dart';
import '../models/quran_surah.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({
    required this.surahs,
    super.key,
  });

  final List<QuranSurah> surahs;

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QuranSurah> get _filteredSurahs {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.surahs;
    }

    return widget.surahs.where(
      (surah) {
        return surah.number.toString() == query ||
            surah.englishName.toLowerCase().contains(query) ||
            surah.translatedName.toLowerCase().contains(query) ||
            surah.arabicName.contains(_query.trim());
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final surahs = _filteredSurahs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surahs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Surah',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _query = '';
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: surahs.isEmpty
                ? const Center(
                    child: Text(
                      'No Surahs found.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: surahs.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    itemBuilder: (context, index) {
                      final surah = surahs[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              surah.number.toString(),
                            ),
                          ),
                          title: Text(
                            surah.englishName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${surah.translatedName} • '
                            '${surah.revelationType} • '
                            '${surah.ayahCount} Ayahs',
                          ),
                          trailing: Text(
                            surah.arabicName,
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>SurahReaderScreen(
                                  surah: surah,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}