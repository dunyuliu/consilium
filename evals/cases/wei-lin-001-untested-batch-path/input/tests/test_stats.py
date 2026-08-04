from worktree.stats import compute_stats


def test_compute_stats_matches_expected():
    items = [2, 4, 4, 4, 5, 5, 7, 9]  # n=8, well under BATCH_THRESHOLD=200
    mean, std = compute_stats(items)
    assert abs(mean - 5.0) < 1e-9
    assert abs(std - 2.0) < 1e-9
