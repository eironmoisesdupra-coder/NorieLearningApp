import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_coverage.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_coverage_panel.dart';

AnatomyAtlasCatalog fixture() => AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Male body', 'description': 'Body'},
        {'id': 'female', 'label': 'Female body', 'description': 'Partial body'},
        {'id': 'ear', 'label': 'Ear detail', 'description': 'Detail'},
      ],
      'structures': [
        {
          'id': 'male-bone',
          'name': 'Bone',
          'reference': 'male',
          'systems': ['skeletal'],
          'asset': 'male-skeletal',
          'source': 'bodyparts3d',
          'ontology': 'FMA1',
        },
        {
          'id': 'female-bone',
          'name': 'Bone',
          'reference': 'female',
          'systems': ['skeletal', 'articular'],
          'asset': 'female-skeletal',
          'source': 'hra-female',
          'ontology': '-',
        },
        {
          'id': 'ear-part',
          'name': 'Ear part',
          'reference': 'ear',
          'systems': ['sensory'],
          'asset': 'detail-ear',
          'source': 'spl-ear',
        },
      ],
    });

void main() {
  test('counts preserve reference boundaries and overlapping systems', () {
    final coverage = AnatomyAtlasCoverage.fromCatalog(fixture(), 'female');
    expect(coverage.totalCount, 3);
    expect(coverage.selectedCount, 1);
    expect(coverage.systemCounts['skeletal'], 1);
    expect(coverage.systemCounts['articular'], 1);
    expect(coverage.systemCounts['sensory'], 0);
    expect(coverage.systemCounts.length, 15);
    expect(coverage.sourceCounts, {'hra-female': 1});
    expect(coverage.ontologyMissingCount, 1);
    expect(coverage.statusFor('female-bone'), AtlasTeachingStatus.missing);
    expect(coverage.statusFor('invented'), AtlasTeachingStatus.unreviewed);
  });

  test('unknown reference cannot borrow another reference counts', () {
    final coverage = AnatomyAtlasCoverage.fromCatalog(fixture(), 'invented');
    expect(coverage.knownReference, false);
    expect(coverage.selectedCount, 0);
    expect(coverage.sourceCounts, isEmpty);
  });

  testWidgets('small phone panel scrolls to all filters and limitations', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnatomyAtlasCoveragePanel(
            catalog: fixture(),
            reference: 'female',
          ),
        ),
      ),
    );
    expect(find.text('Female body'), findsOneWidget);
    expect(
      find.text('1 selectable model parts in this reference'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Coverage boundaries'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('partial musculoskeletal'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('human subject-matter'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
  });
}
