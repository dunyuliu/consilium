# ziyan-001 — citation overclaim and year mismatch

**Agent under test:** `ziyan-chen`  
**Difficulty:** medium — requires reading abstract descriptions and comparing to text claims; year mismatch is straightforward.

## Planted defects

### 1. Overclaim (critical, `manuscript.tex:23-26`)

**Text claim:**  
> Smith et al. (2015) demonstrate that thermal expansion will cause 1 meter of sea level rise by 2100, making it the dominant contributor to future sea level change.

**Bib entry abstract:**  
> We present numerical models of seawater thermal expansion under various warming scenarios with uncertainty bounds. The model includes regional variations across different ocean basins. Expansion coefficients are computed across a range of temperatures, salinities, and pressures.

**Defect:**  
The abstract describes a modeling study with "uncertainty bounds" and "regional variations" — it is about method and scope, not a specific quantitative prediction. The text claims a definitive "1 meter by 2100", which is an overclaim not supported by the abstract's description of the paper's actual content.

**Why this tests ziyan-chen:**  
Rule 7 of ziyan-chen's contract: "Read the abstract of every cited paper and verify the claim in the text is actually supported. A citation that is real but misused is as bad as a fabricated one." This is exactly that case — the citation is verifiable (the entry is complete), but the claim overstates what the paper found.

### 2. Year mismatch (medium, `manuscript.tex:30`)

**Text citation:**  
> Historical temperature records from Johnson (2019) show a consistent warming trend...

**Bib entry:**  
```
@article{Johnson2018,
  year={2018},
  ...
}
```

**Defect:**  
Citation year in text (2019) does not match the year field in the bib entry (2018). This violates Rule 5: "Key year in citation key must match publication year."

**Why this is easy to detect:**  
No network access needed; a simple scan of the text and bib file surfaces the mismatch.

## Controls (correct entries)

### 3. Williams et al. (2020) — `manuscript.tex:35-37`

**Text claim:**  
> Williams et al. (2020) provide detailed measurements of seawater density at various depths, which are essential for understanding expansion rates under different conditions.

**Bib entry:**  
```
@article{Williams2020,
  title={Seawater Properties at Depth: A Comprehensive Review},
  year={2020},
  abstract={We provide detailed measurements and analysis of seawater density, thermal
    expansion coefficients, and physical properties at various depths and temperatures
    under modern ocean conditions.}
}
```

**Status:** CORRECT — the claim is accurate to the abstract. This is a control entry to ensure the agent does not flag correct citations as defective.

### 4. Brown and Lee (2012) — `manuscript.tex:41-44`

**Text claim:**  
> Brown and Lee (2012) conducted extensive modeling of thermal expansion under various warming scenarios. Their framework provides a comprehensive approach for understanding how different emission pathways affect ocean expansion. The results demonstrate significant regional variation in expansion rates, with larger effects in tropical regions.

**Bib entry:**  
```
@article{BrownLee2012,
  title={Thermal Expansion Modeling Under Climate Scenarios},
  year={2012},
  abstract={Our modeling framework examines thermal expansion responses across multiple
    climate emission scenarios. Results show significant regional variation in expansion
    rates, with regional effects dominating over global averages.}
}
```

**Status:** CORRECT — the claims align with the abstract. Year is correct. This is a second control entry to guard against overflagging.

## Fixture design notes

- **No DOIs in any entry.** All bib entries are synthetic (obvious from the all-lowercase journal names and round page numbers). This avoids the risk of accidentally pointing to a real DOI that does not match the fake entry. Network access is not required or helpful.
- **Abstracts are detailed enough to detect overclaim.** The abstract field in each entry contains enough information to verify whether the claim in the text is supported — this is how ziyan-chen will detect the defect.
- **Year mismatch is purely textual.** The second defect is a straightforward scan: text says 2019, bib says 2018.

## Pass criteria

See `case.yaml`. Minimum bar:
1. Finding at `manuscript.tex:23-26` mentioning overclaim, Smith, and that the claim is unsupported.
2. Finding at `manuscript.tex:30` flagging the year mismatch (2019 vs. 2018).
3. No false positives on Williams or Brown entries.

The agent's report must follow its contract (table format, one row per issue, no hedging).
