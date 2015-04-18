tvt2015_distributed_CSI_acquisition
====

**tvt2015_distributed_CSI_acquisition** is the simulation environment for
> [R. Brandt][rabr5411] and [M. Bengtsson][matben]. "Distributed CSI Acquisition and Coordinated
Precoding for TDD Multicell MIMO Systems". *Trans. Veh. Technol.*, 2015. Accepted for publication.

It provides all the simulation code and scripts required to reproduce the 
figures from the paper.

## Abstract
Several distributed coordinated precoding methods exist in the downlink multicell MIMO literature, many of which assume perfect knowledge of received signal covariance and local effective channels. In this work, we let the notion of channel state information (CSI) encompass this knowledge of covariances and effective channels. We analyze what local CSI is required in the WMMSE algorithm for distributed coordinated precoding, and study how this required CSI can be obtained in a distributed fashion. Based on pilot-assisted channel estimation, we propose three CSI acquisition methods with different tradeoffs between feedback and signaling, backhaul use, and computational complexity. One of the proposed methods is fully distributed, meaning that it only depends on over-the-air signaling but requires no backhaul, and results in a fully distributed joint system when coupled with the WMMSE algorithm. Naively applying the WMMSE algorithm together with the fully distributed CSI acquisition results in catastrophic performance however, and therefore we propose a robustified WMMSE algorithm based on the well known diagonal loading framework. By enforcing properties of the WMMSE solutions with perfect CSI onto the problem with imperfect CSI, the resulting diagonally loaded spatial filters are shown to perform significantly better than the naive filters. The proposed robust and distributed system is evaluated using numerical simulations, and shown to perform well compared with benchmarks. Under centralized CSI acquisition, the proposed algorithm performs on par with other existing centralized robust WMMSE algorithms. When evaluated in a large scale fading environment, the performance of the proposed system is promising.

## Description of simulations
The simulations are placed in two folders, `PracticalTDD` and `PracticalTDD_largescale`. The former contains the simulations for the canonical interering broadcast channel, whereas the latter contain the simulations for the large-scale 3-cell network.

The plot commands require that [export_fig](https://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig) from the Matlab File Exchange is installed.

## Running the simulations
1. `cd` into the base directory and run `setup` from within Matlab
2. `cd PracticalTDD/batches` or `cd PracticalTDD_largescale/batches`
3. `matlabpool X` where `X` is the number of cores available
4. Run any `_run` scripts to run the simulation, and the corresponding 
   `_plot_final` script to recreate the figure from the paper.

## Description of batch scripts
### PracticalTDD
- AWsqrt
  - Evolution of the Frobenius norm of the weighted receive filters, as a function of number of optimization iterations performed. Not included in paper.
- convergence
  - Evolution of the rates, as a function of number of optimization iterations performed. Figure 6 in the paper.
- pilotComplexity
  - Compares sum rate performance and computational complexity as a function of pilot length. Figure 8 in the paper.
- rho
  - Sum rate performance as a function of the design parameter rho. Figure 4 in the paper.
- sumrateQres
  - Sum rate performance as a function of the number of quantization bits when the MSE weight is quantized. Figure 9 in the paper.
- sumrateSIR
  - Sum rate performance as a function of signal-to-interference ratio. Not included in paper.
- sumrateSNR
  - Sum rate performance as a function of signal-to-noise ratios. Figures 3, 5, and 7 in the paper.

### PracticalTDD_largescale
- sumrateKc
  - Sum rate performance as a function of number of scheduled users per cell. Figure 11(a) in the paper.
- sumrateKcsched
  - Sum rate performance as a function of total number of users per cell. Figure 11(b) in the paper.

## License and referencing
This source code is licensed under the [MIT][mit] license. If you in any way use this code for research that results in publications, please cite our original article. The following [Bibtex][bibtex] entry can be used.

```
@Article{Brandt2015accepted,
  Title                    = {Distributed {CSI} Acquisition and Coordinated Precoding for {TDD} Multicell {MIMO} Systems},
  Author                   = {R. Brandt and M. Bengtsson},
  Journal                  = {IEEE} Trans. Veh. Technol.,
  Year                     = {2015},
  Note                     = {Accepted for publication}
}
```

[rabr5411]: http://www.kth.se/profile/rabr5411
[matben]: http://www.kth.se/profile/matben
[mit]: http://choosealicense.com/licenses/mit
[bibtex]: http://www.bibtex.org/
