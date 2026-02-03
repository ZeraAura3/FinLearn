class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnail;
  final double rating;
  final int students;
  final int lessons;
  final String duration;
  final double progress;
  final String category;
  final bool isFeatured;
  final List<String> tags;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnail,
    required this.rating,
    required this.students,
    required this.lessons,
    required this.duration,
    this.progress = 0.0,
    required this.category,
    this.isFeatured = false,
    this.tags = const [],
  });

  static List<Course> getSampleCourses() {
    return [
      Course(
        id: '1',
        title: 'Introduction to Personal Finance',
        description:
            'Learn the basics of managing your money, budgeting, and saving for your future.',
        instructor: 'Sarah Johnson',
        thumbnail: 'assets/images/course1.png',
        rating: 4.8,
        students: 12450,
        lessons: 24,
        duration: '6 hours',
        progress: 0.65,
        category: 'Personal Finance',
        isFeatured: true,
        tags: ['Beginner', 'Budgeting', 'Savings'],
      ),
      Course(
        id: '2',
        title: 'Investing Fundamentals',
        description:
            'Master the art of investing in stocks, bonds, and mutual funds.',
        instructor: 'Michael Chen',
        thumbnail: 'assets/images/course2.png',
        rating: 4.9,
        students: 18920,
        lessons: 32,
        duration: '8 hours',
        progress: 0.35,
        category: 'Investing',
        isFeatured: true,
        tags: ['Intermediate', 'Stocks', 'Investing'],
      ),
      Course(
        id: '3',
        title: 'Cryptocurrency Basics',
        description:
            'Understand blockchain technology and cryptocurrency investments.',
        instructor: 'Alex Rivera',
        thumbnail: 'assets/images/course3.png',
        rating: 4.6,
        students: 8750,
        lessons: 18,
        duration: '5 hours',
        progress: 0.0,
        category: 'Cryptocurrency',
        isFeatured: false,
        tags: ['Beginner', 'Crypto', 'Blockchain'],
      ),
      Course(
        id: '4',
        title: 'Real Estate Investment',
        description:
            'Learn how to invest in real estate and generate passive income.',
        instructor: 'Jennifer Martinez',
        thumbnail: 'assets/images/course4.png',
        rating: 4.7,
        students: 6340,
        lessons: 28,
        duration: '7 hours',
        progress: 0.0,
        category: 'Real Estate',
        isFeatured: false,
        tags: ['Advanced', 'Real Estate', 'Property'],
      ),
      Course(
        id: '5',
        title: 'Retirement Planning',
        description:
            'Plan for a secure and comfortable retirement with smart strategies.',
        instructor: 'Robert Williams',
        thumbnail: 'assets/images/course5.png',
        rating: 4.8,
        students: 10230,
        lessons: 22,
        duration: '6.5 hours',
        progress: 0.15,
        category: 'Retirement',
        isFeatured: false,
        tags: ['Intermediate', 'Retirement', '401k'],
      ),
      Course(
        id: '6',
        title: 'Tax Planning Strategies',
        description:
            'Optimize your taxes and keep more of your hard-earned money.',
        instructor: 'Lisa Anderson',
        thumbnail: 'assets/images/course6.png',
        rating: 4.5,
        students: 5680,
        lessons: 16,
        duration: '4 hours',
        progress: 0.0,
        category: 'Taxes',
        isFeatured: false,
        tags: ['Advanced', 'Taxes', 'Planning'],
      ),
    ];
  }
}
