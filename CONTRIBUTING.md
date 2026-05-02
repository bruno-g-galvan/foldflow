# Contributing to foldflow

Thanks for your interest. Contributions of all sizes are welcome.

## Ways to contribute

- Report a bug — open an issue with steps to reproduce
- Request a feature — open an issue describing the use case
- Fix a bug or add a feature — open a PR against main
- Improve documentation — always valuable

## Development setup

```bash
git clone https://github.com/bruno-g-galvan/foldflow.git
cd foldflow
conda env create -f environment.yml
conda activate foldflow
nextflow run main.nf --input test_data/test_sequences.fasta --outdir results/test
```

## Questions?

Open an issue or email hello@brunogalvan.com.ar
