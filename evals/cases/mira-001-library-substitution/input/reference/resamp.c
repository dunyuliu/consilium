/* Reference resampler. Do not modify — this is the parity oracle. */

#include <math.h>
#include <stdlib.h>

/* Low-pass filter applied before decimation.
 *
 * NOTE: the kernel is CIRCULAR and TRUNCATED at radius 2*sigma, and is
 * renormalised over the truncated support only. It is not a separable
 * Gaussian over the full plane.
 */
static void smooth(const double *in, double *out, int nr, int nc, double sigma)
{
    int radius = (int)(2.0 * sigma);
    double inv2s2 = 1.0 / (2.0 * sigma * sigma);

    for (int i = 0; i < nr; i++) {
        for (int j = 0; j < nc; j++) {
            double acc = 0.0, wsum = 0.0;
            for (int di = -radius; di <= radius; di++) {
                for (int dj = -radius; dj <= radius; dj++) {
                    double r2 = (double)(di * di + dj * dj);
                    if (r2 > (double)(radius * radius)) continue;  /* circular */
                    int ii = i + di, jj = j + dj;
                    if (ii < 0) ii = 0;
                    if (jj < 0) jj = 0;
                    if (ii >= nr) ii = nr - 1;
                    if (jj >= nc) jj = nc - 1;
                    double w = exp(-r2 * inv2s2);
                    acc += w * in[ii * nc + jj];
                    wsum += w;
                }
            }
            out[i * nc + j] = acc / wsum;
        }
    }
}

/* Interpolate one row/column onto destination positions.
 *
 * NOTE: this is a LOCAL 4-point cubic convolution (Catmull-Rom, a = -0.5),
 * not a globally-fitted cubic spline. Each output sample depends on exactly
 * four neighbours. Edges clamp to the boundary sample.
 */
static double cubic_kernel(double t)
{
    double a = -0.5;
    double at = fabs(t);
    if (at <= 1.0)
        return ((a + 2.0) * at - (a + 3.0)) * at * at + 1.0;
    if (at < 2.0)
        return a * (((at - 5.0) * at + 8.0) * at - 4.0);
    return 0.0;
}

static double interp_1d(const double *v, int n, double x)
{
    int i0 = (int)floor(x);
    double frac = x - (double)i0;
    double acc = 0.0;

    for (int k = -1; k <= 2; k++) {
        int idx = i0 + k;
        if (idx < 0) idx = 0;
        if (idx >= n) idx = n - 1;
        acc += v[idx] * cubic_kernel((double)k - frac);
    }
    return acc;
}

void resample(const double *field, double *out,
              int nr, int nc, double sigma, int out_rows, int out_cols)
{
    double *sm = malloc((size_t)nr * nc * sizeof(double));
    double *stage = malloc((size_t)nr * out_cols * sizeof(double));
    double *col = malloc((size_t)nr * sizeof(double));

    smooth(field, sm, nr, nc, sigma);

    for (int i = 0; i < nr; i++)
        for (int j = 0; j < out_cols; j++) {
            double x = (double)j * (double)(nc - 1) / (double)(out_cols - 1);
            stage[i * out_cols + j] = interp_1d(&sm[i * nc], nc, x);
        }

    for (int j = 0; j < out_cols; j++) {
        for (int i = 0; i < nr; i++) col[i] = stage[i * out_cols + j];
        for (int i = 0; i < out_rows; i++) {
            double y = (double)i * (double)(nr - 1) / (double)(out_rows - 1);
            out[i * out_cols + j] = interp_1d(col, nr, y);
        }
    }

    free(sm); free(stage); free(col);
}
