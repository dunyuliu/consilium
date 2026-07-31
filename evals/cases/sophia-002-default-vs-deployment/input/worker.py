"""Job scheduler worker pool. Pulls a batch of jobs from a queue and runs
each one, retrying failures up to a configured limit."""

import yaml


def load_config(path: str) -> dict:
    with open(path) as f:
        return yaml.safe_load(f)


def run_job(job, attempt: int) -> bool:
    """Execute a single job; returns True on success."""
    return job.run(attempt)


def run_batch(cfg: dict, jobs: list) -> list:
    """Pull cfg['batch_size'] jobs from cfg['queue_name'] and execute each
    with retry."""
    queue = cfg.get("queue_name", "default")
    batch = jobs[: cfg.get("batch_size", 50)]
    max_retries = cfg.get("max_retries", 5)

    results = []
    for job in batch:
        job.queue = queue
        ok = False
        for attempt in range(max_retries):
            if run_job(job, attempt):
                ok = True
                break
        results.append((job, ok))
    return results


def main(cfg_path: str, jobs: list) -> list:
    cfg = load_config(cfg_path)
    return run_batch(cfg, jobs)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True)
    args = parser.parse_args()
    main(args.config, jobs=[])
