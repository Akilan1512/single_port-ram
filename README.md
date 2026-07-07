Bugs Fixed in Single Port RAM:

1. Toggle Coverage Reset (rst) signal was toggling only from 0 → 1, but not from 1 → 0, resulting in incomplete toggle coverage. In some tasks and function calls, the reference model interface (ref_vif) was not passed. Because of this, the reference model did not receive transactions, causing the data_out signal not to toggle.

2. Branch Coverage; Some else branches were not executed because the corresponding conditions were never satisfied during simulation. Additional stimulus or appropriate test scenarios are required to exercise those branches.

3. FEC (Focused Expression Condition) Coverage; Certain FEC conditions were not covered because a constraint prevented the required input combinations from being generated. As a result, those conditions remained uncovered during simulation.

4. Statement Coverage Some statements were not executed because they belonged to commented-out code or branches that were never reached. Since those paths were not exercised, the corresponding statements remained uncovered.
