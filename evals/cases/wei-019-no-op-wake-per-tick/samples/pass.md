# Conductor, at the 10:23 tick

1. Cancel my watcher (`TaskStop` on it): mira-volkov owns her completion
   monitor, so a five-minute tick only re-reads my context to say nothing.
2. My only wake is her completion notice — a state change, success or
   failure — with a deadline of about 6 h.
3. Meanwhile dispatch R-8, which needs no training output.
