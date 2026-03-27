import 'package:flutter/material.dart';
import 'package:finlearn/l10n/app_localizations.dart';
import '../../models/course.dart';
import '../course_detail_screen.dart';

class LearningTab extends StatelessWidget {
  const LearningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final courses = Course.getSampleCourses();
    final inProgressCourses = courses
        .where((c) => c.progress > 0 && c.progress < 1)
        .toList();
    final completedCourses = courses.where((c) => c.progress >= 1).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate('my_learning'),
            style: textTheme.headlineSmall,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorColor: colorScheme.primary,
            labelStyle: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.translate('in_progress')),
              Tab(text: AppLocalizations.of(context)!.translate('completed')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // In Progress Tab
            inProgressCourses.isEmpty
                ? _buildEmptyState(
                    context,
                    icon: Icons.school_outlined,
                    title: AppLocalizations.of(
                      context,
                    )!.translate('no_courses_in_progress'),
                    subtitle: AppLocalizations.of(
                      context,
                    )!.translate('start_course_hint'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: inProgressCourses.length,
                    itemBuilder: (context, index) {
                      return _buildLearningCard(
                        context,
                        inProgressCourses[index],
                      );
                    },
                  ),

            // Completed Tab
            completedCourses.isEmpty
                ? _buildEmptyState(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: AppLocalizations.of(
                      context,
                    )!.translate('no_completed_courses'),
                    subtitle: AppLocalizations.of(
                      context,
                    )!.translate('complete_course_hint'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: completedCourses.length,
                    itemBuilder: (context, index) {
                      return _buildCompletedCard(
                        context,
                        completedCourses[index],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 80, color: colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with progress overlay
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 56,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(course.progress * 100).toInt()}% ${AppLocalizations.of(context)!.translate('complete')}',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${course.lessons} ${AppLocalizations.of(context)!.translate('lessons')}',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: LinearProgressIndicator(
                            value: course.progress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(course.instructor, style: textTheme.bodySmall),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.translate('continue_learning'),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            Icons.emoji_events_rounded,
            color: colorScheme.onPrimary,
            size: 32,
          ),
        ),
        title: Text(
          course.title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${AppLocalizations.of(context)!.translate('completed')} • ${course.instructor}',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.green,
          ), // Consider theme color
        ),
        trailing: TextButton(
          onPressed: () {
            // View certificate
          },
          child: Text(
            'Certificate',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
