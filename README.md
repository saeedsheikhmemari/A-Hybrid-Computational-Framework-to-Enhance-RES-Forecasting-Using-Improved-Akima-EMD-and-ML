# A Hybrid Computational Framework to Enhance RES Forecasting Using Improved Akima-Empirical Mode Decomposition and ML

**Renewable energy forecasting · Signal decomposition · Machine learning · Smart energy management**

This repository accompanies a research framework that connects renewable energy forecasting with energy management. The manuscript focuses on wind power: improved Akima empirical mode decomposition (Akima-EMD) separates historical signals into intrinsic mode functions (IMFs) and a residual, which are prepared and forecast individually before reconstruction of the final wind power prediction.

**Release status:** Documentation is available. The manuscript's implementation code, environment requirements, datasets or data-access instructions, and reproducible experiments will be added in a future release. This repository does not yet contain an executable implementation.

## Research scope

RES stands for renewable energy sources. Although the repository title describes the broader RES forecasting direction, the current manuscript's case study concerns **wind power**. Solar forecasting and other renewable technologies are not presented here as validated applications.

The framework combines signal processing, neural forecasting, and uncertainty estimation with an application to residential energy scheduling involving wind generation, stationary batteries, electric vehicles, grid exchange, and diesel backup.

## Conceptual workflow

1. **Prepare historical inputs:** organize wind power records and relevant available explanatory variables.
2. **Decompose the signal:** use improved Akima interpolation within EMD to extract IMFs and the residual through iterative sifting.
3. **Denoise and select features:** apply soft-threshold denoising and the manuscript's feature-processing methods, including DWT and relevance/redundancy criteria.
4. **Forecast each component:** predict the IMFs and residual using the neural forecasting engine.
5. **Reconstruct wind power:** sum the component predictions to obtain the final forecast.
6. **Characterize uncertainty:** estimate the forecast-error distribution using non-parametric kernel density estimation (NPKDE).
7. **Support energy management:** use the forecast alongside demand, electricity prices, and storage state of charge to inform energy allocation and grid exchange.

## Energy management application

The manuscript considers a residential market with consumers and prosumers. Wind generation, battery energy storage systems (BESS), and electric vehicles (EVs) interact with the main grid; diesel generation provides backup. The distribution system operator (DSO) and energy management layer exchange information with the physical system.

This application connects forecasting outputs to scheduling decisions. The repository does not claim demonstrated real-time deployment, experimentally verified grid stability, or reproducible performance improvements before the implementation and evaluation materials are released.

## Planned code release

The release will document:

- The implemented forecasting architecture and training configuration.
- Data sources, units, timestamps, and forecast horizons.
- Chronological training, validation, and test partitions.
- Preprocessing and decomposition procedures that respect forecast-time information availability.
- Installation requirements and commands for running the experiments.
- Benchmark definitions, metric calculations, and result-generation scripts.
- BESS and EV operating constraints, including charging/discharging logic.
- Usage and licensing terms for code and any redistributed data.

## Getting started

There are no installation or execution steps yet. Please revisit this repository after the implementation is uploaded.

## Manuscript

This project is based on the manuscript **“A Hybrid Computational Framework for Enhance Wind Power Forecasting Using Improved Akima-Empirical Mode Decomposition and Deep Neural Networks in Smart Grid Applications.”**

Publication metadata and a citation will be added when confirmed.

## Questions and discussion

Use the repository's Issues tab for questions about the methodology, documentation, or future code release.
