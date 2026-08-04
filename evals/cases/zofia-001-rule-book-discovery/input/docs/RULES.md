# Rules

Quickstart for running the model-training pipeline locally.

1. Install dependencies: `pip install -r requirements.txt`
2. Train the model: `python train.py --epochs 50 --lr 0.001`
3. Evaluate the checkpoint: `python evaluate.py --checkpoint latest.pt`
4. Export for serving: `python export.py --format onnx`

Re-run step 2 with a different `--lr` any time you change the dataset.
Re-run step 3 after every training run to confirm accuracy hasn't regressed.
