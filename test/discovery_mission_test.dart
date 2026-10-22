import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/discovery/domain/discovery_mission.dart';

void main() {
  test(
      'each legal stage round trips and out-of-stage actions cannot skip ahead',
      () {
    var state = DiscoveryMissionState();
    void check() {
      expect(DiscoveryMissionState.fromJson(state.toJson()).toJson(),
          state.toJson());
      if (state.stage != DiscoveryStage.apply) {
        expect(state.submitApplication(correct: true).toJson(), state.toJson());
      }
      if (state.stage != DiscoveryStage.conclude) {
        expect(
            state
                .submitConclusion(
                    evaporation: true,
                    evidence: DiscoveryEvidence.controlledComparison)
                .toJson(),
            state.toJson());
      }
    }

    check();
    for (final clue in DiscoveryClue.values) {
      state = state.inspect(clue);
      check();
    }
    state = state.continueFromClues();
    check();
    state = state.runTrial(warm: false);
    check();
    expect(state.continueFromExperiment().stage, DiscoveryStage.experiment);
    state = state.runTrial(warm: true).continueFromExperiment();
    check();
    expect(
        state
            .submitConclusion(
                evaporation: false,
                evidence: DiscoveryEvidence.controlledComparison)
            .stage,
        DiscoveryStage.conclude);
    state = state.submitConclusion(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    check();
    state = state.submitApplication(correct: true);
    check();
    expect(state.inspect(DiscoveryClue.dryTable).toJson(), state.toJson());
    expect(state.runTrial(warm: true).toJson(), state.toJson());
  });

  test('correct hypothesis still needs supporting evidence', () {
    var state = DiscoveryMissionState();
    for (final clue in DiscoveryClue.values) {
      state = state.inspect(clue);
    }
    state = state
        .continueFromClues()
        .runTrial(warm: true)
        .runTrial(warm: false)
        .continueFromExperiment();
    expect(state.submitConclusion(evaporation: true).stage,
        DiscoveryStage.conclude);
  });

  test('caller cannot mutate clue evidence after construction', () {
    final clues = <DiscoveryClue>{};
    final state = DiscoveryMissionState(clues: clues);
    clues.addAll(DiscoveryClue.values);
    expect(state.inspectedAll, false);
    expect(
        () => state.clues.add(DiscoveryClue.dryTable), throwsUnsupportedError);
  });

  test('restore rejects evidence from stages not yet reached', () {
    final base = DiscoveryMissionState().toJson();
    for (final flag in [
      'warmTrial',
      'coolTrial',
      'conclusionCorrect',
      'appliedCorrect'
    ]) {
      expect(() => DiscoveryMissionState.fromJson({...base, flag: true}),
          throwsFormatException,
          reason: flag);
    }
  });

  test('restore rejects noninteger schema and unknown fields', () {
    final base = DiscoveryMissionState().toJson();
    expect(() => DiscoveryMissionState.fromJson({...base, 'schema': 1.0}),
        throwsFormatException);
    expect(() => DiscoveryMissionState.fromJson({...base, 'xp': 1000}),
        throwsFormatException);
  });

  test('cannot skip clues, experiment, or independent application', () {
    var s = DiscoveryMissionState();
    expect(s.continueFromClues().stage, DiscoveryStage.inspect);
    for (final clue in DiscoveryClue.values) {
      s = s.inspect(clue);
    }
    s = s.continueFromClues();
    expect(s.stage, DiscoveryStage.experiment);
    expect(s.continueFromExperiment().stage, DiscoveryStage.experiment);
    s = s.runTrial(warm: true).runTrial(warm: false).continueFromExperiment();
    expect(s.stage, DiscoveryStage.conclude);
    expect(
        s.submitConclusion(evaporation: false).stage, DiscoveryStage.conclude);
    expect(
        s
            .submitConclusion(
                evaporation: true, evidence: DiscoveryEvidence.dryTableAlone)
            .stage,
        DiscoveryStage.conclude);
    expect(
        s
            .submitConclusion(
                evaporation: true, evidence: DiscoveryEvidence.warmWindowAlone)
            .stage,
        DiscoveryStage.conclude);
    s = s.submitConclusion(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    expect(s.submitApplication(correct: false).complete, false);
    s = s.submitApplication(correct: true);
    expect(s.complete, true);
    expect(DiscoveryMissionState.fromJson(s.toJson()).complete, true);
  });

  test('forged completion and unknown clues are rejected', () {
    expect(
        () => DiscoveryMissionState.fromJson(
            {...DiscoveryMissionState().toJson(), 'stage': 'complete'}),
        throwsFormatException);
    expect(
        () => DiscoveryMissionState.fromJson({
              ...DiscoveryMissionState().toJson(),
              'clues': ['fake']
            }),
        throwsFormatException);
  });
}
