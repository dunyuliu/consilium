.PHONY: test test-regression plots clean

test:
	pytest -q tests/unit tests/analytic

test-regression:
	pytest -q tests/regression --baseline baselines/spring_neap_2019.npz

plots:
	python -m src.plots transport --run runs/latest

clean:
	rm -rf runs/latest/__pycache__
