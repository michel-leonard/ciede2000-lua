Browse : [Go](https://github.com/michel-leonard/ciede2000-go) · [JavaScript](https://github.com/michel-leonard/ciede2000-javascript) · [Java](https://github.com/michel-leonard/ciede2000-java) · [Julia](https://github.com/michel-leonard/ciede2000-julia) · [Kotlin](https://github.com/michel-leonard/ciede2000-kotlin) · **Lua** · [MATLAB](https://github.com/michel-leonard/ciede2000-matlab) · [Microsoft Excel](https://github.com/michel-leonard/ciede2000-excel) · [PHP](https://github.com/michel-leonard/ciede2000-php) · [Perl](https://github.com/michel-leonard/ciede2000-perl) · [Python](https://github.com/michel-leonard/ciede2000-python)

# CIEDE2000 color difference formula in Lua

This page presents the CIEDE2000 color difference, implemented in the Lua programming language.

![Logo](https://raw.githubusercontent.com/michel-leonard/ciede2000-color-matching/refs/heads/main/docs/assets/images/logo.jpg)

## About

Here you’ll find the first rigorously correct implementation of CIEDE2000 that doesn’t use any conversion between degrees and radians. Set parameter `canonical` to obtain results in line with your existing pipeline.

`canonical`|The algorithm operates...|
|:--:|-|
`false`|in accordance with the CIEDE2000 values currently used by many industry players|
`true`|in accordance with the CIEDE2000 values provided by [this](https://hajim.rochester.edu/ece/sites/gsharma/ciede2000/) academic MATLAB function|

## Our CIEDE2000 offer

This production-ready file, released in 2026, contain the CIEDE2000 algorithm.

Source File|Type|Bits|Purpose|Advantage|
|:--:|:--:|:--:|:--:|:--:|
[ciede2000.lua](./ciede2000.lua)|`number`|64|General|Interoperability|

### Software Versions

- Lua 5.2
- Lua 5.3
- Lua 5.4
- LuaJIT 2.1

### Example Usage

We calculate the CIEDE2000 distance between two colors, first without and then with parametric factors.

```lua
-- Example of two L*a*b* colors
l1, a1, b1 = 20.5, 119.1, 8.1
l2, a2, b2 = 19.4, 96.5, -6.4

print("CIEDE2000 =", ciede2000(l1, a1, b1, l2, a2, b2))
-- ΔE2000 = 6.0482461903517

-- Example of parametric factors used in the textile industry
kl, kc, kh = 2.0, 1.0, 1.0

-- Perform a CIEDE2000 calculation compliant with that of Gaurav Sharma
canonical = true

print("CIEDE2000 =", ciede2000(l1, a1, b1, l2, a2, b2, kl, kc, kh, canonical))
-- ΔE2000 = 6.012280374242
```
Typically, hundreds of thousands of CIEDE2000 color comparisons can be performed per second using Lua.

### Test Results

LEONARD’s tests are based on well-chosen L\*a\*b\* colors, with various parametric factors `kL`, `kC` and `kH`.

```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : 93.0,5.0,-21.0,94.0,28.0,120.0,1.0,1.0,1.0,47.69446104798974
           Precision : 12 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 289.34 seconds
     Average Delta E : 67.13
   Average Deviation : 5e-15
   Maximum Deviation : 1.6e-13
```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : 93.0,5.0,-21.0,94.0,28.0,120.0,1.0,1.0,1.0,47.69466027817887
           Precision : 12 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 280.53 seconds
     Average Delta E : 67.13
   Average Deviation : 5.5e-15
   Maximum Deviation : 1.6e-13
```

## Public Domain Licence

You are free to use these files, even for commercial purposes.
