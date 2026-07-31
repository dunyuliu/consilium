# Job scheduler worker pool

Pulls a batch of jobs from a queue and executes each one, retrying failed
jobs up to a configured limit before giving up.

## Configuration

All parameters live in `config.yaml`:

| Key | Meaning | Default |
|---|---|---|
| `max_retries` | Number of retry attempts before a job is marked failed. | `3` |
| `queue_name` | Name of the queue to poll for jobs. | `default` |
| `batch_size` | Number of jobs pulled from the queue per cycle. | `50` |
| `enable_dead_letter` | Route jobs that exhaust retries to a dead-letter queue instead of dropping them. | `false` |

## Quick start

```
python worker.py --config config.yaml
```
