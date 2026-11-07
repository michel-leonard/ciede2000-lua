-- This function written in Lua is not affiliated with the CIE (International Commission on Illumination),
-- and is released into the public domain. It is provided "as is" without any warranty, express or implied.

-- The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
-- "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
function ciede2000(l1, a1, b1, l2, a2, b2, kl, kc, kh, canonical)
	-- Working in Lua/LuaJIT with the CIEDE2000 color-difference formula.
	-- kl, kc, kh are parametric factors to be adjusted according to
	-- different viewing parameters such as textures, backgrounds...
	local n = (math.sqrt(a1 * a1 + b1 * b1) + math.sqrt(a2 * a2 + b2 * b2)) * 0.5;
	n = n * n * n * n * n * n * n;
	-- A factor involving chroma raised to the power of 7 designed to make
	-- the influence of chroma on the total color difference more accurate.
	n = 1.0 + 0.5 * (1.0 - math.sqrt(n / (n + 6103515625.0)));
	-- Application of the chroma correction factor.
	local c1 = math.sqrt(a1 * a1 * n * n + b1 * b1);
	local c2 = math.sqrt(a2 * a2 * n * n + b2 * b2);
	-- atan2 is preferred over atan because it accurately computes the angle of
	-- a point (x, y) in all quadrants, handling the signs of both coordinates.
	local h1 = math.atan2(b1, a1 * n);
	local h2 = math.atan2(b2, a2 * n);
	if h1 < 0.0 then h1 = h1 + 2.0 * math.pi end;
	if h2 < 0.0 then h2 = h2 + 2.0 * math.pi end;
	-- When the hue angles lie in different quadrants, the straightforward
	-- average can produce a mean that incorrectly suggests a hue angle in
	-- the wrong quadrant, the next lines handle this issue.
	local h_mean = (h1 + h2) * 0.5;
	local h_delta = (h2 - h1) * 0.5;
	-- The part where most programmers get it wrong.
	if math.pi + 1E-14 < math.abs(h2 - h1) then
		h_delta = h_delta + math.pi;
		if canonical and math.pi + 1E-14 < h_mean then
			-- Sharma’s implementation, OpenJDK, ...
			h_mean = h_mean - math.pi;
		else
			-- Lindbloom’s implementation, Netflix’s VMAF, ...
			h_mean = h_mean + math.pi;
		end
	end
	local p = 36.0 * h_mean - 55.0 * math.pi;
	n = (c1 + c2) * 0.5;
	n = n * n * n * n * n * n * n;
	-- The hue rotation correction term is designed to account for the
	-- non-linear behavior of hue differences in the blue region.
	local r_t = -2.0 * math.sqrt(n / (n + 6103515625.0)) *
			math.sin(math.pi / 3.0 * math.exp(p * p / (-25.0 * math.pi * math.pi)));
	n = (l1 + l2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	-- Lightness.
	local l = (l2 - l1) / ((kl or 1.0) * (1.0 + 0.015 * n / math.sqrt(20.0 + n)));
	-- These coefficients adjust the impact of different harmonic
	-- components on the hue difference calculation.
	local t = 1.0	- 0.17 * math.sin(h_mean + math.pi / 3.0)
					+ 0.24 * math.sin(2.0 * h_mean + math.pi * 0.5)
					+ 0.32 * math.sin(3.0 * h_mean + 8.0 * math.pi / 15.0)
					- 0.20 * math.sin(4.0 * h_mean + 3.0 * math.pi / 20.0);
	n = c1 + c2;
	-- Hue.
	local h = 2.0 * math.sqrt(c1 * c2) *
			math.sin(h_delta) / ((kh or 1.0) * (1.0 + 0.0075 * n * t));
	-- Chroma.
	local c = (c2 - c1) / ((kc or 1.0) * (1.0 + 0.0225 * n));
	-- The result reflects the actual geometric distance in color space, given a tolerance of 3.6e-13.
	return math.sqrt(l * l + h * h + c * c + c * h * r_t);
end

-- If you remove the constant 1E-14, the code will continue to work, but CIEDE2000
-- interoperability between all programming languages will no longer be guaranteed.

-- Source code tested by Michel LEONARD
-- Website: ciede2000.pages-perso.free.fr
