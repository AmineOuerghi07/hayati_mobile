enum PlantStage { seed, sprout, bud, bloom, tree }

/// How grown a habit's plant is. Streaks count double so a long run
/// blooms even when the total check-ins are still small.
PlantStage plantStage({required int checkIns, required int bestStreak}) {
  final score = checkIns + bestStreak * 2;
  if (bestStreak >= 30 || score >= 60) return PlantStage.tree;
  if (bestStreak >= 7 || score >= 21) return PlantStage.bloom;
  if (bestStreak >= 3 || score >= 8) return PlantStage.bud;
  if (checkIns >= 1 || bestStreak >= 1) return PlantStage.sprout;
  return PlantStage.seed;
}

double plantProgress(PlantStage stage) => switch (stage) {
  PlantStage.seed => 0.05,
  PlantStage.sprout => 0.28,
  PlantStage.bud => 0.55,
  PlantStage.bloom => 0.8,
  PlantStage.tree => 1,
};
