/*
 Copyright (c) 2013 yvt
 
 This file is part of OpenSpades.
 
 OpenSpades is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 OpenSpades is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with OpenSpades.  If not, see <http://www.gnu.org/licenses/>.
 
 */

vec4 FogDensity(float poweredLength) {
	float distance = floor(poweredLength/64.)*64.;
	distance = min(distance * (1. / 128. / 128.), 1.);
	float weakenedDensity = 1. - distance;
	distance *= distance;
	return mix(vec4(distance, distance, distance, 0), vec4(1. - weakenedDensity),
					 vec4(0, 0.3, 1.0, 0));
}
