# Optimizing Profitability in Olive Oil Distribution: A Case Study on Viola's Supply Chain Strategy

This repository contains an advanced Operations Research and Decision Theory project focused on optimizing the distribution network of the Italian olive oil mill **Viola** (with its main production facility located in Venosa, PZ). 

The problem addresses monthly delivery planning to 10 cities in Southern Italy, integrating transport logistics with economic uncertainty caused by market price fluctuations.

This project was developed for the *Decision Theory and Multi-Criteria Analysis* course within the Master’s degree program in *Analytics and Data Science for Economics and Management* at the University of Brescia (A.Y. 2024/2025).

## Authors
* Alessia Aquilini
* Gabriele Battagliola
* Luigina Bertolotti
* Federico Buizza
* Marie Doka
* Samuela Paci
* Martina Pagan

## Project Structure & Files
* **`TwoStageProblem.gms`**: GAMS code implementing the two-stage stochastic optimization model integrated with Conditional Value at Risk (CVaR) for risk management.
* **`VRP.gms` & `VRP.lst`**: Model formulation for the Capacitated Vehicle Routing Problem (CVRP) and the corresponding solver output report execution.
* **`Project2_MathematicalFormulation.pdf`**: Detailed documentation of the mathematical model, including sets, parameters, decision variables, and the node-variable formulation constraints.
* **`Project2_Presentation.pdf`**: Slide deck used for the final project presentation and defense.
* **`Data_ViolaOliveOil.xlsx - Data.csv`**: Input dataset containing geographic coordinates, distance matrices, and customer monthly demand profiles.

## Tech Stack & Tools
* **Optimization Software:** GAMS (General Algebraic Modeling System)
* **Solvers:** CPLEX / IBM ILOG CPLEX (leveraged to solve mixed-integer linear and stochastic programming problems)
* **Data Processing:** Microsoft Excel / CSV format (price estimates sourced from ISMEA market reports and logistics routing based on digital maps).

## Methodology & Key Results
The optimization framework is divided into two sequential macro-phases:
1. **Phase 1: Capacitated Vehicle Routing Problem (CVRP)**
   Determining the optimal routing schedules for a fleet of 3 identical vehicles (capacity of 3,500 liters each) to meet all client demands while strictly minimizing the total transportation distance (km).
2. **Phase 2: Two-Stage Stochastic Model under Uncertainty**
   Optimizing first-stage production decisions (with a deterministic current price of €45.2/l) and second-stage operational adjustments under 3 distinct probabilistic market price scenarios:
   * **Scenario 1 (Depreciation):** €43.5/liter (Probability: 57%)
   * **Scenario 2 (Baseline):** €46.4/liter (Probability: 27%)
   * **Scenario 3 (Appreciation):** €48.2/liter (Probability: 16%)
3. **Risk Management via CVaR**
   Integrating a *Conditional Value at Risk* constraint into the expected profit maximization objective function. This allows the company to adjust its risk-aversion threshold ($\beta$), protecting the supply chain against worst-case financial losses due to oil price drops.
