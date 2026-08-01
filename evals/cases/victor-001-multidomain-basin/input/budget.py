"""Monthly water balance for the Cerro Alto basin.

Reads the month-end gauge record and reports, per month, the change in
basin water storage (precipitation minus evapotranspiration minus stream
outflow) together with the observed water-table trend.

Depth convention: water_table_m is depth to water below ground surface,
positive downward, so a rising number means a falling water table.
"""

import csv
from pathlib import Path

import numpy as np

BASIN_AREA_KM2 = 1240.0     # catchment area above the Cerro Alto gauge
MIN_VALID_DAYS = 20         # months with sparser gauge coverage are dropped
SECONDS_PER_DAY = 86400.0


def load_record(path):
    """Read the monthly gauge record into parallel arrays."""
    month, precip, et, q, dim, valid, wt = [], [], [], [], [], [], []
    with open(path, newline="") as fh:
        for row in csv.DictReader(fh):
            month.append(row["month"])
            precip.append(float(row["precip_mm"]))
            et.append(float(row["et_mm"]))
            q.append(float(row["discharge_m3s"]))
            dim.append(int(row["days_in_month"]))
            valid.append(int(row["valid_days"]))
            wt.append(float(row["water_table_m"]))
    return (month, np.array(precip), np.array(et), np.array(q),
            np.array(dim), np.array(valid), np.array(wt))


def runoff_depth_mm(discharge_m3s, days_in_month):
    """Stream outflow expressed as a depth of water over the basin, in mm."""
    volume_m3 = discharge_m3s * days_in_month * SECONDS_PER_DAY
    return volume_m3 / BASIN_AREA_KM2 * 1000.0


def storage_change_mm(precip_mm, et_mm, runoff_mm):
    """Monthly basin storage change from the mass balance P - ET - Q."""
    return precip_mm - et_mm - runoff_mm


def water_table_change_m(depth_m):
    """Month-over-month change in depth to water (positive = deepening)."""
    dh = np.zeros(len(depth_m))
    for i in range(len(depth_m)):
        dh[i] = depth_m[i] - depth_m[i - 1]
    return dh


def summarize(path):
    month, precip, et, q, dim, valid, wt = load_record(path)
    runoff = runoff_depth_mm(q, dim)
    usable = valid >= MIN_VALID_DAYS
    ds = storage_change_mm(precip[usable], et[usable], runoff[usable])
    dh = water_table_change_m(wt)

    print(f"months in record            : {len(month)}")
    print(f"months dropped for coverage : {int((~usable).sum())}")
    print(f"mean storage change         : {ds.mean():.1f} mm/month")
    print(f"mean water-table change     : {dh.mean():.4f} m/month")
    print(f"water-table change, record  : {wt[-1] - wt[0]:.2f} m")


if __name__ == "__main__":
    summarize(Path(__file__).with_name("gauge_monthly.csv"))
