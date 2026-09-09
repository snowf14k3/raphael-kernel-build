# SM8150 / Raphael Venus Test22

Test22 uses Linux baseline
`58f3df07833f2382fe2fbc28f996c4c85817c1f6` and applies patches 0001--0036.
The expected release is `7.1.0-sm8150-venus-test22+`.

Test21 stopped safely in the public DMA API before the first input allocation.
Patch 0036 allows the upstream-cache hint through
`dma_alloc_noncontiguous()`. Test22 otherwise retains the fully audited Test21
streaming DMA, packet, property, count, internal-buffer, power and PM paths.

Before hardware starts, both queues must report `bidi=1 nc=1 up=1`. Failure to
establish that mapping stops the test without sending LOAD/START/ETB.

Use encoder scope once with a persistent external log. Success requires EBD,
non-empty FBD, software-decodable H.264, clean teardown and runtime PM
`suspended`; a reset or empty result is failure.
