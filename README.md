# Scale-Space-Blob-Detection

Blob detection on images using Matlab

Outline:
1. Generate a Laplacian of Gaussian filter.
2. Build a Laplacian scale space, starting with some initial scale and going for n iterations:
   - Filter image with scale-normalized Laplacian at current scale.
   - Save square of Laplacian response for current level of scale space.
   - Increase scale by a factor k.

3. Perform nonmaximum suppression in scale space.
4. Display resulting circles at their characteristic scales.

Two implementations performed for performance comparison:
- Upscaling filter size
- Downsampling image
