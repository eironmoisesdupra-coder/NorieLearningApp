import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/domain/study_source_review.dart';
import 'norie_study_cache_test.dart' show fixture;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
      'comparison and flags persist for the exact question and owner across restart',
      () async {
    final set = fixture();
    final store = NorieStudyOfflineStore('alice');
    final q = set.questions.single;
    await store.saveSourceReview(set, q.id, SourceReviewDecision.compared);
    var review = await NorieStudyOfflineStore('alice').loadSourceReview(set);
    expect(review.statusFor(set, q), SourceReviewStatus.compared);
    expect(review.completeFor(set), isTrue);
    expect(
        (await NorieStudyOfflineStore('bob').loadSourceReview(set))
            .statusFor(set, q),
        SourceReviewStatus.unchecked);
    await store.saveSourceReview(set, q.id, SourceReviewDecision.flagged);
    review = await NorieStudyOfflineStore('alice').loadSourceReview(set);
    expect(review.statusFor(set, q), SourceReviewStatus.flagged);
    expect(review.completeFor(set), isFalse);
  });
  test('every relevant content or source change invalidates learner comparison',
      () async {
    final set = fixture();
    final store = NorieStudyOfflineStore('alice');
    final q = set.questions.single;
    await store.saveSourceReview(set, q.id, SourceReviewDecision.compared);
    final review = await store.loadSourceReview(set);
    for (final change in <Map<String, dynamic>>[
      {'prompt': 'Different prompt'},
      {
        'correct_values': ['Wrong new answer']
      },
      {'explanation': 'Changed explanation'},
      {'source_excerpt': 'Changed source'},
      {
        'options': ['Other choice']
      },
      {
        'ordered_items': ['Femur', 'Skull']
      },
      {'kind': 'identification'},
      {'difficulty': 'advanced'},
      {'topic_tag': 'Other topic'},
    ]) {
      final changedQ = NorieStudyQuestion.fromMap({...q.toMap(), ...change});
      final changedSet =
          NorieStudySet.fromMap(set.toMap(), questions: [changedQ]);
      expect(
          review.statusFor(changedSet, changedQ), SourceReviewStatus.unchecked,
          reason: change.toString());
    }
    for (final change in <Map<String, dynamic>>[
      {'source_name': 'other.pdf'},
      {'source_type': 'file'},
      {'ai_model': 'new-model'},
      {
        'generation_metadata': {'source_revision': 'changed'}
      }
    ]) {
      final changed =
          NorieStudySet.fromMap({...set.toMap(), ...change}, questions: [q]);
      expect(review.statusFor(changed, q), SourceReviewStatus.unchecked);
    }
  });
  test('missing source cannot be acknowledged as source-backed practice',
      () async {
    final set = fixture();
    final q = NorieStudyQuestion.fromMap(
        {...set.questions.single.toMap(), 'source_excerpt': ''});
    final missing = NorieStudySet.fromMap(set.toMap(), questions: [q]);
    final store = NorieStudyOfflineStore('alice');
    await expectLater(
        store.saveSourceReview(missing, q.id, SourceReviewDecision.compared),
        throwsStateError);
    final review = await store.loadSourceReview(missing);
    expect(review.statusFor(missing, q), SourceReviewStatus.missingSource);
    expect(review.completeFor(missing), isFalse);
    await store.saveSourceReview(missing, q.id, SourceReviewDecision.flagged);
    expect((await store.loadSourceReview(missing)).statusFor(missing, q),
        SourceReviewStatus.flagged);
  });
  test(
      'empty sets and unknown questions never become complete or create decisions',
      () async {
    final set = NorieStudySet.fromMap(fixture().toMap());
    final store = NorieStudyOfflineStore('alice');
    expect((await store.loadSourceReview(set)).completeFor(set), isFalse);
    await expectLater(
        store.saveSourceReview(set, 'missing', SourceReviewDecision.compared),
        throwsStateError);
  });
  test('corrupted review records fail closed and keep original stored bytes',
      () async {
    final prefs = await SharedPreferences.getInstance();
    const bytes =
        '{"sourceReviews":{"private-set":{"schema":1,"records":"broken"}}}';
    await prefs.setString('norie.study.alice.offline.v1', bytes);
    final store = NorieStudyOfflineStore('alice');
    await expectLater(store.loadSourceReview(fixture()), throwsStateError);
    await expectLater(
        store.saveSourceReview(
            fixture(), 'bone-q1', SourceReviewDecision.compared),
        throwsStateError);
    expect(prefs.getString('norie.study.alice.offline.v1'), bytes);
  });
  test(
      'foreign nonnull owners and blank card identifiers cannot create review records',
      () async {
    final original = fixture();
    final foreign = NorieStudySet.fromMap(
        {...original.toMap(), 'user_id': 'bob'},
        questions: original.questions);
    final store = NorieStudyOfflineStore('alice');
    await expectLater(store.loadSourceReview(foreign), throwsStateError);
    await expectLater(
        store.saveSourceReview(foreign, original.questions.single.id,
            SourceReviewDecision.flagged),
        throwsStateError);
    final blank = NorieStudyQuestion.fromMap(
        {...original.questions.single.toMap(), 'id': ''});
    final malformed =
        NorieStudySet.fromMap(original.toMap(), questions: [blank]);
    for (final decision in SourceReviewDecision.values) {
      await expectLater(
          store.saveSourceReview(malformed, '', decision), throwsStateError);
    }
    expect((await store.loadSourceReview(original)).records, isEmpty);
  });
}
