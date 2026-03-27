import 'package:flutter/material.dart';
import 'package:finlearn/l10n/app_localizations.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final projects = [
      Project(
        title: 'Personal Budget Tracker',
        description: 'Create a comprehensive budget tracking system',
        difficulty: 'Beginner',
        duration: '2 weeks',
        progress: 0.45,
        category: 'Personal Finance',
        tasks: 8,
        completedTasks: 4,
      ),
      Project(
        title: 'Investment Portfolio Analysis',
        description: 'Analyze and optimize your investment portfolio',
        difficulty: 'Intermediate',
        duration: '3 weeks',
        progress: 0.20,
        category: 'Investing',
        tasks: 10,
        completedTasks: 2,
      ),
      Project(
        title: 'Retirement Planning Calculator',
        description: 'Build a retirement savings calculator',
        difficulty: 'Advanced',
        duration: '4 weeks',
        progress: 0.0,
        category: 'Retirement',
        tasks: 12,
        completedTasks: 0,
      ),
    ];

    final inProgressProjects = projects
        .where((p) => p.progress > 0 && p.progress < 1)
        .toList();
    final availableProjects = projects.where((p) => p.progress == 0).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('projects_title'),
                      style: textTheme.displaySmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.translate('projects_subtitle'),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.translate('in_progress'),
                            '${inProgressProjects.length}',
                            Icons.pending_actions_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.translate('completed'),
                            '0',
                            Icons.check_circle_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.translate('available'),
                            '${availableProjects.length}',
                            Icons.folder_open_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // In Progress Section
            if (inProgressProjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12),
                  child: Text(
                    AppLocalizations.of(context)!.translate('in_progress'),
                    style: textTheme.headlineSmall,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildProjectCard(
                      context,
                      inProgressProjects[index],
                      true,
                    );
                  }, childCount: inProgressProjects.length),
                ),
              ),
            ],

            // Available Projects Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.translate('available_projects'),
                      style: textTheme.headlineSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        '${availableProjects.length} ${AppLocalizations.of(context)!.translate('new_tag')}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildProjectCard(
                    context,
                    availableProjects[index],
                    false,
                  );
                }, childCount: availableProjects.length),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Browse all projects
        },
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.explore_rounded, color: colorScheme.onPrimary),
        label: Text(
          AppLocalizations.of(context)!.translate('browse_all'),
          style: TextStyle(color: colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.onPrimary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    Project project,
    bool inProgress,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        Icons.assignment_rounded,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(
                                    context,
                                    project.difficulty,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  project.difficulty,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: _getDifficultyColor(
                                      context,
                                      project.difficulty,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                project.duration,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  project.description,
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Tasks progress
                Row(
                  children: [
                    Icon(
                      Icons.checklist_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${project.completedTasks}/${project.tasks} tasks completed',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(project.progress * 100).toInt()}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                if (inProgress) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: LinearProgressIndicator(
                      value: project.progress,
                      backgroundColor: colorScheme.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: TextButton(
              onPressed: () {
                // View project details
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    inProgress
                        ? Icons.play_arrow_rounded
                        : Icons.rocket_launch_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    inProgress ? 'Continue Project' : 'Start Project',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green; // Consider a theme color
      case 'intermediate':
        return Colors.orange; // Consider a theme color
      case 'advanced':
        return Colors.red; // Consider a theme color
      default:
        return colorScheme.primary;
    }
  }
}

class Project {
  final String title;
  final String description;
  final String difficulty;
  final String duration;
  final double progress;
  final String category;
  final int tasks;
  final int completedTasks;

  Project({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.progress,
    required this.category,
    required this.tasks,
    required this.completedTasks,
  });
}
