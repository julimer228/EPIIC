# EPIIC: Edge-Preserving Method Increasing nucleI Clarity for Compression Artifacts Removal in Whole-Slide Histopathological Images

![obraz](https://github.com/user-attachments/assets/8922db78-3572-4f25-b58a-66f81efc93e2)

This repository contains the implementation of the **EPIIC** and **EPIIC Sobel** methods designed to remove JPEG compression artifacts from hematoxylin and eosin (H&E)-stained histopathological images.

## How to use the code

1. Start by running the `main.m` script, or add all folders in the repository to your MATLAB path.

2. Then, navigate to the `test_algorithm.m` script, where you can run the methods on example images from the **BreCaHAD** dataset (located in the `Data` folder).

3. You can customize the algorithm parameters:

   - `Q` – JPEG compression quality factor  
   - `Sigma` – standard deviation of the Gaussian filter  
   - `T_mult` – `T_m` parameter (see details in the manuscript)  
   - `avg_size` – size of the averaging filter  
   - `he` – whether the image is H&E-stained (`true` enables stain deconvolution)  
   - `save` – whether to save intermediate result maps at each step (`true`/`false`)  
   - `method` – choose `"EPIIC"` or `"EPIIC Sobel"`  
     - *Other tested methods are available in the `Utils/process_image.m` function*

4. Run the code, and the result with SSIM and PSNR values will be displayed in the Figure window.

## How to cite

If you use this repository in your research, please cite the following paper (paper is accepted for publication, doi would be updated):

> [Julia Merta, Michał Marczyk, EPIIC: Edge-Preserving Method
Increasing Nuclei Clarity for
Compression Artifacts Removal in
Whole-Slide Histopathological Images.
Appl. Sci. 2025, 1, 0]([LINK](https://doi.org/))
