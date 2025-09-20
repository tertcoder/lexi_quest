import '../models/annotation_task_model.dart';
import '../models/completed_annotation_model.dart';

/// Demo data provider for annotation tasks and completed annotations
class AnnotationDemoData {
  /// Demo annotation tasks
  static List<AnnotationTask> get demoTasks => [
    AnnotationTask(
      id: '1',
      title: 'Identify Named Entities',
      content:
          'The company Apple Inc. was founded by Steve Jobs in Cupertino, California in 1976. The headquarters is located at One Apple Park Way.',
      type: AnnotationType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: TaskStatus.pending,
      xpReward: 50,
    ),
    AnnotationTask(
      id: '2',
      title: 'Sentiment Analysis',
      content:
          'This product exceeded my expectations! The quality is amazing and the customer service was outstanding. Highly recommended for anyone looking for reliability.',
      type: AnnotationType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: TaskStatus.pending,
      xpReward: 40,
    ),
    AnnotationTask(
      id: '3',
      title: 'Object Detection',
      content: 'Identify and label objects in this street scene.',
      type: AnnotationType.image,
      imageUrl:
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.pending,
      xpReward: 75,
    ),
    AnnotationTask(
      id: '4',
      title: 'Speech Recognition',
      content: 'Transcribe the following audio clip accurately.',
      type: AnnotationType.audio,
      audioUrl: 'https://example.com/demo-audio.mp3',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      status: TaskStatus.pending,
      xpReward: 60,
    ),
    AnnotationTask(
      id: '5',
      title: 'Text Classification',
      content:
          'The new policy changes will significantly impact our quarterly revenue projections and require immediate stakeholder notification.',
      type: AnnotationType.text,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: TaskStatus.inProgress,
      xpReward: 45,
    ),
    AnnotationTask(
      id: '6',
      title: 'Medical Document Analysis',
      content:
          'Patient presents with acute chest pain radiating to left arm. ECG shows ST elevation in leads II, III, and aVF. Blood pressure 140/90.',
      type: AnnotationType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: TaskStatus.pending,
      xpReward: 80,
    ),
  ];

  /// Demo completed annotations
  static List<CompletedAnnotation> get demoCompletedAnnotations => [
    CompletedAnnotation(
      id: 'comp_1',
      taskId: 'task_completed_1',
      userId: 'user_1',
      title: 'Product Review Analysis',
      description: 'Sentiment analysis of product reviews',
      type: AnnotationType.text,
      labels: [
        AnnotationLabel(
          id: 'label_1',
          text: 'Apple Inc.',
          startPosition: 12,
          endPosition: 22,
          category: 'ORGANIZATION',
          confidence: 0.95,
        ),
        AnnotationLabel(
          id: 'label_2',
          text: 'Steve Jobs',
          startPosition: 41,
          endPosition: 51,
          category: 'PERSON',
          confidence: 0.98,
        ),
      ],
      completedAt: DateTime.now().subtract(const Duration(hours: 3)),
      xpEarned: 25,
      accuracy: 0.92,
      labelsAdded: 2,
      timeSpent: 15,
    ),
    CompletedAnnotation(
      id: 'comp_2',
      taskId: 'task_completed_2',
      userId: 'user_1',
      title: 'Medical Document Analysis',
      description: 'Entity recognition in medical records',
      type: AnnotationType.text,
      labels: [
        AnnotationLabel(
          id: 'label_3',
          text: 'headache',
          startPosition: 25,
          endPosition: 33,
          category: 'SYMPTOM',
          confidence: 0.89,
        ),
      ],
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      xpEarned: 40,
      accuracy: 0.89,
      labelsAdded: 1,
      timeSpent: 25,
    ),
    CompletedAnnotation(
      id: 'comp_3',
      taskId: 'task_completed_3',
      userId: 'user_1',
      title: 'News Article Classification',
      description: 'Topic classification for news articles',
      type: AnnotationType.text,
      labels: [
        AnnotationLabel(
          id: 'label_4',
          text: 'technology',
          startPosition: 0,
          endPosition: 10,
          category: 'TOPIC',
          confidence: 0.96,
        ),
        AnnotationLabel(
          id: 'label_5',
          text: 'innovation',
          startPosition: 45,
          endPosition: 55,
          category: 'TOPIC',
          confidence: 0.88,
        ),
      ],
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      xpEarned: 35,
      accuracy: 0.94,
      labelsAdded: 2,
      timeSpent: 20,
    ),
  ];

  /// Available annotation categories
  static List<String> get annotationCategories => [
    'PERSON',
    'ORGANIZATION',
    'LOCATION',
    'DATE',
    'TIME',
    'MONEY',
    'PRODUCT',
    'EVENT',
    'SENTIMENT',
    'VEHICLE',
    'STRUCTURE',
    'ANIMAL',
    'FOOD',
    'TECHNOLOGY',
  ];
}
