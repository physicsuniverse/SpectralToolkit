# SpectralToolkit

[![GitHub license](https://img.shields.io/github/license/physicsuniverse/SpectralToolkit)](https://github.com/physicsuniverse/SpectralToolkit/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/physicsuniverse/SpectralToolkit)](https://github.com/physicsuniverse/SpectralToolkit/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/physicsuniverse/SpectralToolkit)](https://github.com/physicsuniverse/SpectralToolkit/issues)

**Author**: [Peng Liu](https://github.com/physicsuniverse) - Working on holographic duality, black hole physics

A high-performance **spectral methods library** for numerical computing in **Mathematica/Wolfram Language**. SpectralToolkit provides state-of-the-art pseudospectral techniques for differentiation, integration, and interpolation with **exponential accuracy** for smooth functions.

## 🚀 Key Features

- **🎯 Exponential Convergence**: Achieve machine precision with relatively few grid points
- **⚡ Exceptional Performance**: **100× faster** integration, **260× peak speedup** over NIntegrate
- **🔧 Comprehensive Toolkit**: Differentiation, integration, interpolation in one package
- **📐 Multi-dimensional**: Easily extends to higher-dimensional problems
- **🧮 Chebyshev Methods**: Optimal point distributions and polynomial bases
- **🔄 Easy Integration**: Drop-in replacements for standard numerical functions
- **📊 Machine Precision**: **10⁻¹³ typical errors** for differentiation of smooth functions

## 📦 Installation

### System Requirements

**SpectralToolkit requires Wolfram Engine or Mathematica to run.** Choose one of the following options:

#### Option 1: Wolfram Engine (Free)
- **Download**: [Wolfram Engine](https://www.wolfram.com/engine/) - Free for developers
- **Features**: Full computational capabilities, no notebook interface
- **Best for**: Command-line usage, integration with other tools, automated workflows

#### Option 2: Mathematica (Commercial)
- **Purchase**: [Wolfram Mathematica](https://www.wolfram.com/mathematica/)
- **Features**: Complete development environment with notebooks, visualization tools
- **Best for**: Interactive development, research, comprehensive mathematical workflow

### Installation Steps

1. **Download** the `SpectralToolkit.wl` file
2. **Place** it in your Mathematica working directory or add to `$Path`
3. **Load** the package:
   ```mathematica
   Get["SpectralToolkit.wl"]
   ```

### Compatibility
- **Minimum Version**: Wolfram Language 12.0 or later
- **Recommended**: Wolfram Language 13.0+ for optimal performance
- **Operating Systems**: Windows, macOS, Linux

### Quick Start Example
```mathematica
(* Load the package *)
Get["SpectralToolkit.wl"]

(* Generate Chebyshev points *)
points = ChebyshevAllocation[{0, 1}, 20];

(* Fast integration example *)
result = SpectralIntegrate[Exp[x] Sin[x], {x, 0, 1}, 101];

(* High-precision differentiation *)
values = Exp[points];
derivative = SpectralDifferentiate[values, {0, 1}, 1];

Print["SpectralToolkit is ready to use!"];
```

## 🔧 Core Functions

### Grid Generation
- **`ChebyshevAllocation[{a,b}, n]`**: Generate optimal Chebyshev-Gauss-Lobatto points
  ```mathematica
  points = ChebyshevAllocation[{-1, 1}, 20]
  ```

### Spectral Coefficients
- **`GetSpectralCoeff[values]`**: Compute Chebyshev expansion coefficients
- **`GetSpectral[values, {a,b}, var]`**: Create continuous spectral interpolation
  ```mathematica
  f = Sin[π x];
  points = ChebyshevAllocation[{0, 1}, 16];
  values = f /. x -> points;
  interpolant = GetSpectral[values, {0, 1}, x]
  ```

### High-Performance Integration
- **`SpectralIntegrate[f, {var, a, b}, order]`**: Ultra-fast numerical integration
  ```mathematica
  (* Often 100x faster than NIntegrate, up to 260x for optimal cases *)
  result = SpectralIntegrate[Exp[x] Sin[3x], {x, 0, 1}, 101]
  (* Typical performance: ~0.0001s vs NIntegrate ~0.01s *)
  ```

### Spectral Differentiation
- **`SpectralDifferentiate[values, {a,b}, order]`**: High-accuracy derivatives
- **`GetDiffMatrix[points]`**: Generate differentiation matrices
  ```mathematica
  (* Machine precision derivatives with ~10^-13 typical error *)
  points = ChebyshevAllocation[{-1, 1}, 25];
  values = Exp[points];
  derivative = SpectralDifferentiate[values, {-1, 1}, 1]
  (* Achieves 2.26×10^-14 relative error for smooth functions *)
  ```

### Advanced Tools
- **`GetCosDiff[n]`**: Fourier-based differentiation for periodic problems
- **`RecoverPolynomial[coeffs, period]`**: Reconstruct polynomials from coefficients
- **`SpectralInterpolate[points, values, x]`**: High-order interpolation

## 📊 Performance Comparison

### Integration Performance
| Method | Speed | Accuracy | Example Results |
|--------|-------|----------|-----------------|
| SpectralToolkit | **17-260x faster** | **Exponential** | ~100× average speedup |
| NIntegrate | Baseline | Adaptive | Reference method |

### Differentiation Performance  
| Method | Speed | Accuracy | Error Magnitude |
|--------|-------|----------|-----------------|
| SpectralToolkit | **High precision** | **Machine precision** | ~10⁻¹³ typical error |
| Finite Differences | Variable | O(h²) | ~10⁻⁶ typical error |

### Tested Performance Metrics
- **Average Integration Speedup**: **100× faster** than NIntegrate for smooth functions
- **Maximum Integration Speedup**: **260× faster** for well-conditioned problems
- **Differentiation Accuracy**: **Machine precision** (~10⁻¹³) for smooth functions
- **Interpolation Error**: **0.008** maximum error for challenging Runge function

### ⚖️ When to Use SpectralToolkit

**Mathematica's Analytical Advantage**: For simple computations, Mathematica's built-in symbolic engine can often optimize operations analytically, making additional numerical methods unnecessary.

**Spectral Methods Excel When**:
- **High-precision computations** are required (working precision > machine precision)
- **Large-scale problems** with many grid points (N > 100)
- **Repeated derivative evaluations** on the same grid
- **Multi-dimensional spectral methods** are employed

In these scenarios, the speedup can be **significant** (often 10×-100× faster) compared to traditional finite difference methods or repeated symbolic differentiation, especially for high-precision computations and numerically complex situations.

## 🧮 Mathematical Foundation

SpectralToolkit implements **Chebyshev pseudospectral methods**, which represent functions as:

```
f(x) ≈ Σ(k=0 to N) aₖ Tₖ(x)
```

Where `Tₖ(x)` are Chebyshev polynomials and coefficients `aₖ` decay exponentially for smooth functions.

### Key Advantages:
- **Spectral Accuracy**: Errors decrease exponentially with N for smooth functions
- **Optimal Points**: Chebyshev points minimize interpolation error (Runge phenomenon avoided)
- **Fast Transforms**: Leverage FFT algorithms for O(N log N) operations
- **Stable Algorithms**: Excellent numerical conditioning

## 🔬 Applications

### Differential Equations
```mathematica
(* Solve BVP: u'' + u = sin(πx), u(±1) = 0 *)
n = 32;
x = ChebyshevAllocation[{-1, 1}, n];
D2 = GetDiffMatrix[x][[3]];  (* Second derivative matrix *)
A = D2 + IdentityMatrix[n];
b = Sin[π x];
solution = LinearSolve[A, b]
```

### Signal Processing
```mathematica
(* High-resolution spectral analysis *)
signal = Table[Sin[10 t] + 0.5 Cos[25 t], {t, 0, 2π, 2π/128}];
coeffs = GetSpectralCoeff[signal];
(* coeffs reveal frequency content with high precision *)
```

### Multi-dimensional Problems
```mathematica
(* 2D integration via tensor products *)
integralX = Table[SpectralIntegrate[f[x, y], {x, -1, 1}], {y, yPoints}];
integral2D = SpectralIntegrate[integralX[[#]] &, {y, -1, 1}]
```

## 📚 Examples and Documentation

Comprehensive examples are provided in:
- **`SpectralToolkit_Tests.ipynb`**: Interactive Jupyter notebook with all function demonstrations
- **Performance benchmarks** comparing with standard methods
- **Multi-dimensional examples** showing tensor product techniques
- **Real-world applications** in physics and engineering

## 🎯 Use Cases

### Research Applications
- **Computational Physics**: Quantum mechanics, fluid dynamics, electromagnetics
- **Applied Mathematics**: Solving PDEs with high accuracy
- **Signal Processing**: Spectral analysis and filtering
- **Computational Finance**: Option pricing and risk modeling

### Educational Applications
- **Numerical Analysis Courses**: Demonstrate spectral method theory
- **Advanced Mathematics**: Explore Chebyshev polynomials and function approximation
- **Scientific Computing**: Compare numerical method performance

## 🔄 Extensions to Higher Dimensions

SpectralToolkit naturally extends to multi-dimensional problems:

```mathematica
(* 2D Laplacian using tensor products *)
{nx, ny} = {16, 16};
xPoints = ChebyshevAllocation[{-1, 1}, nx];
yPoints = ChebyshevAllocation[{-1, 1}, ny];
Dx = GetDiffMatrix[xPoints][[2]];  (* ∂/∂x *)
Dy = GetDiffMatrix[yPoints][[2]];  (* ∂/∂y *)
Laplacian2D = KroneckerProduct[IdentityMatrix[ny], Dx.Dx] + 
              KroneckerProduct[Dy.Dy, IdentityMatrix[nx]];
```

## ⚡ Performance Tips

1. **Choose appropriate order**: More points ≠ always better for noisy data
2. **Function smoothness**: Spectral methods excel for smooth functions
3. **Boundary conditions**: Chebyshev methods naturally handle Dirichlet conditions
4. **Memory usage**: Large matrices for high-order differentiation
5. **Conditioning**: Monitor condition numbers for stability

## 🛠️ Technical Details

### Dependencies
- **Wolfram Engine or Mathematica** 12.0 or later (13.0+ recommended)
- **Core Wolfram Language**: Built-in functions `FourierDCT`, `ChebyshevT`, `NDSolve` utilities
- **Free Option**: Wolfram Engine (free for developers) provides full functionality
- **Commercial Option**: Mathematica (includes notebook interface and advanced visualization)

### Performance Characteristics
- **Time Complexity**: O(N log N) for transforms, O(N²) for matrix operations
- **Space Complexity**: O(N²) for differentiation matrices
- **Accuracy**: Machine precision achievable with ~15-20 points for smooth functions
- **Integration Speed**: **100× faster** average, up to **260× faster** peak performance
- **Differentiation Precision**: **10⁻¹³ typical error** for smooth functions

### Numerical Stability
- Uses **Discrete Cosine Transform** for coefficient computation
- Employs **Chebyshev points** to minimize interpolation error
- Implements **stable algorithms** avoiding traditional polynomial fitting

## 📈 Benchmarks

### Real Performance Data from Tests

Based on comprehensive testing in `SpectralToolkit_Tests.ipynb`:

#### Integration Benchmarks
| Problem Type | SpectralToolkit | NIntegrate | Speedup Factor | Accuracy |
|-------------|-----------------|------------|----------------|----------|
| Gaussian Functions | 0.000104s | 0.007971s | **76.6× faster** | Machine precision |
| Oscillatory Functions | 0.000137s | 0.035642s | **260× faster** | ~10⁻¹⁸ error |
| Exponential-Trigonometric | 0.000102s | 0.004745s | **46.5× faster** | ~10⁻¹⁶ error |

#### Differentiation Benchmarks
| Test Function | Max Error | Relative Error | Performance |
|---------------|-----------|----------------|-------------|
| e^x sin(3x) | **4.35×10⁻¹³** | **2.26×10⁻¹⁴** | Machine precision |
| Smooth Functions | **< 10⁻¹²** | **< 10⁻¹³** | Exponential convergence |

#### Interpolation Benchmarks
| Function Type | Max Interpolation Error | Coefficient Decay |
|---------------|------------------------|------------------|
| Runge Function (challenging) | **0.00816** | Exponential (~10⁻¹⁷) |
| Smooth Functions | **< 10⁻¹⁰** | Exponential |

### Performance Summary
- **Average Integration Speedup**: **100× faster** than traditional methods
- **Peak Integration Speedup**: **260× faster** for well-conditioned problems  
- **Differentiation Accuracy**: **Machine precision** (10⁻¹³ - 10⁻¹⁵ typical errors)
- **Memory Efficiency**: O(N²) storage, O(N log N) transforms

## 🤝 Contributing

Contributions are welcome! Areas for enhancement:
- **Additional basis functions** (Hermite, Laguerre, etc.)
- **GPU acceleration** for large-scale problems
- **Adaptive mesh refinement**
- **Specialized boundary condition handling**
- **More examples and applications**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/physicsuniverse/SpectralToolkit/issues)
- **Documentation**: See `SpectralToolkit_Tests.ipynb` for comprehensive examples
- **Community**: Discussions welcome in the Issues section

## 🔗 References

1. Trefethen, L. N. (2000). *Spectral Methods in MATLAB*. SIAM.
2. Boyd, J. P. (2001). *Chebyshev and Fourier Spectral Methods*. Dover Publications.
3. Canuto, C., et al. (2006). *Spectral Methods: Fundamentals in Single Domains*. Springer.

## ⭐ Citation

If you use SpectralToolkit in your research, please cite:

```bibtex
@software{spectraltoolkit,
  author = {Peng Liu},
  title = {SpectralToolkit: High-Performance Spectral Methods for Mathematica},
  url = {https://github.com/physicsuniverse/SpectralToolkit},
  year = {2025}
}
```

---

**Harness the power of spectral methods for your numerical computing needs!** 🚀
