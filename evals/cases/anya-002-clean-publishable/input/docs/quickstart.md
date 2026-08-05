# Quickstart

Set the archive location once per shell if you keep the data outside the repo:

```
export RECURRENCE_DATA=/path/to/your/data
python3 analyze.py --input "$RECURRENCE_DATA/subei_cycles.nc" --out figures/
```

If you mirror the Zenodo record behind an institutional proxy, `fetch_data.sh`
honours the standard `https_proxy` variable. An access token is only needed for
a restricted record; for this public one it is unset. The placeholder below is
what the environment variable looks like — it is not a token and grants nothing:

```
export ZENODO_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx   # placeholder only
```
