/// 冲突解决策略（依据设计文档 Part 9.2）。
///
/// 小团体（≤4 人）并发冲突概率低，采用 **Last-write-wins + 字段级保留**：
/// - 单值字段（标题、描述）：时间戳较新者覆盖
/// - 完成标记：取**最早** completedAt（本质都是完成，尊重先达成者）
/// - 完成纪念文字：全部保留为数组，不丢内容
/// - 删除 vs 编辑：删除优先
abstract final class ConflictResolver {
  /// 单值字段取胜：返回是否应采纳远端值。
  static bool remoteWins({
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
  }) =>
      remoteUpdatedAt.isAfter(localUpdatedAt);

  /// 完成时间取胜：取较早者。
  static DateTime earliestCompletion(DateTime a, DateTime b) =>
      a.isBefore(b) ? a : b;

  /// 纪念文字合并：去重 + 保留顺序。
  static List<String> mergeNotes(List<String> local, List<String> remote) {
    final List<String> merged = <String>[...local];
    for (final String note in remote) {
      if (!merged.contains(note)) merged.add(note);
    }
    return merged;
  }

  /// 删除优先。
  static bool shouldApplyDelete({DateTime? localDeletedAt}) =>
      localDeletedAt == null;
}
