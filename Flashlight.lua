--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.8) ~  Much Love, Ferib 

]]--

local v0 = string.char;
local v1 = string.byte;
local v2 = string.sub;
local v3 = bit32 or bit;
local v4 = v3.bxor;
local v5 = table.concat;
local v6 = table.insert;
local function v7(v24, v25)
	local v26 = {};
	for v41 = 1, #v24 do
		v6(v26, v0(v4(v1(v2(v24, v41, v41 + 1)), v1(v2(v25, 1 + (v41 % #v25), 1 + (v41 % #v25) + 1))) % 256));
	end
	return v5(v26);
end
local v8 = tonumber;
local v9 = string.byte;
local v10 = string.char;
local v11 = string.sub;
local v12 = string.gsub;
local v13 = string.rep;
local v14 = table.concat;
local v15 = table.insert;
local v16 = math.ldexp;
local v17 = getfenv or function()
	return _ENV;
end;
local v18 = setmetatable;
local v19 = pcall;
local v20 = select;
local v21 = unpack or table.unpack;
local v22 = tonumber;
local function v23(v27, v28, ...)
	local v29 = 2 - 1;
	local v30;
	v27 = v12(v11(v27, 5), v7("\243\161", "\201\221\143\235\18\33\23\229"), function(v42)
		if (v9(v42, 2) == (231 - 150)) then
			local v93 = 0;
			while true do
				if (v93 == 0) then
					v30 = v8(v11(v42, 1, 1));
					return "";
				end
			end
		else
			local v94 = v10(v8(v42, 16));
			if v30 then
				local v101 = v13(v94, v30);
				v30 = nil;
				return v101;
			else
				return v94;
			end
		end
	end);
	local function v31(v43, v44, v45)
		if v45 then
			local v95 = 0;
			local v96;
			while true do
				if (v95 == 0) then
					v96 = (v43 / (2 ^ (v44 - (1 - 0)))) % (2 ^ (((v45 - 1) - (v44 - 1)) + 1));
					return v96 - (v96 % 1);
				end
			end
		else
			local v97 = 2 ^ (v44 - 1);
			return (((v43 % (v97 + v97)) >= v97) and (2 - 1)) or 0;
		end
	end
	local function v32()
		local v46 = 0;
		local v47;
		while true do
			if (0 == v46) then
				v47 = v9(v27, v29, v29);
				v29 = v29 + (620 - (555 + 64));
				v46 = 1;
			end
			if (v46 == 1) then
				return v47;
			end
		end
	end
	local function v33()
		local v48 = 0;
		local v49;
		local v50;
		while true do
			if (v48 == 0) then
				v49, v50 = v9(v27, v29, v29 + 2);
				v29 = v29 + 2;
				v48 = 1;
			end
			if (v48 == 1) then
				return (v50 * 256) + v49;
			end
		end
	end
	local function v34()
		local v51, v52, v53, v54 = v9(v27, v29, v29 + (934 - (857 + 74)));
		v29 = v29 + (572 - (367 + 201));
		return (v54 * 16777216) + (v53 * 65536) + (v52 * 256) + v51;
	end
	local function v35()
		local v55 = 0;
		local v56;
		local v57;
		local v58;
		local v59;
		local v60;
		local v61;
		while true do
			if (v55 == 2) then
				v60 = v31(v57, 21, 31);
				v61 = ((v31(v57, 32) == 1) and -1) or 1;
				v55 = 3;
			end
			if (1 == v55) then
				v58 = 928 - (214 + 713);
				v59 = (v31(v57, 1, 6 + 14) * (2 ^ 32)) + v56;
				v55 = 2;
			end
			if (v55 == 3) then
				if (v60 == 0) then
					if (v59 == 0) then
						return v61 * 0;
					else
						local v122 = 0;
						while true do
							if (0 == v122) then
								v60 = 1 + 0;
								v58 = 0;
								break;
							end
						end
					end
				elseif (v60 == 2047) then
					return ((v59 == 0) and (v61 * ((878 - (282 + 595)) / 0))) or (v61 * NaN);
				end
				return v16(v61, v60 - 1023) * (v58 + (v59 / (2 ^ (1689 - (1523 + 114)))));
			end
			if (v55 == 0) then
				v56 = v34();
				v57 = v34();
				v55 = 1;
			end
		end
	end
	local function v36(v62)
		local v63 = 0;
		local v64;
		local v65;
		while true do
			if (v63 == 1) then
				v64 = v11(v27, v29, (v29 + v62) - 1);
				v29 = v29 + v62;
				v63 = 2;
			end
			if (v63 == 2) then
				v65 = {};
				for v102 = 1, #v64 do
					v65[v102] = v10(v9(v11(v64, v102, v102)));
				end
				v63 = 3;
			end
			if (0 == v63) then
				v64 = nil;
				if not v62 then
					v62 = v34();
					if (v62 == 0) then
						return "";
					end
				end
				v63 = 1;
			end
			if (v63 == 3) then
				return v14(v65);
			end
		end
	end
	local v37 = v34;
	local function v38(...)
		return {...}, v20("#", ...);
	end
	local function v39()
		local v66 = 0;
		local v67;
		local v68;
		local v69;
		local v70;
		local v71;
		local v72;
		while true do
			if (v66 == 1) then
				v71 = v34();
				v72 = {};
				for v104 = 1, v71 do
					local v105 = 0;
					local v106;
					local v107;
					while true do
						if (v105 == 0) then
							v106 = v32();
							v107 = nil;
							v105 = 1;
						end
						if (v105 == 1) then
							if (v106 == 1) then
								v107 = v32() ~= 0;
							elseif (v106 == 2) then
								v107 = v35();
							elseif (v106 == 3) then
								v107 = v36();
							end
							v72[v104] = v107;
							break;
						end
					end
				end
				v70[3] = v32();
				v66 = 2;
			end
			if (v66 == 0) then
				v67 = {};
				v68 = {};
				v69 = {};
				v70 = {v67,v68,nil,v69};
				v66 = 1;
			end
			if (v66 == 2) then
				for v108 = 1, v34() do
					local v109 = v32();
					if (v31(v109, 1, 1) == 0) then
						local v118 = 0;
						local v119;
						local v120;
						local v121;
						while true do
							if (3 == v118) then
								if (v31(v120, 3, 3) == 1) then
									v121[17 - 13] = v72[v121[4]];
								end
								v67[v108] = v121;
								break;
							end
							if (v118 == 1) then
								v121 = {v33(),v33(),nil,nil};
								if (v119 == 0) then
									local v127 = 0;
									while true do
										if (v127 == 0) then
											v121[3] = v33();
											v121[4] = v33();
											break;
										end
									end
								elseif (v119 == 1) then
									v121[3] = v34();
								elseif (v119 == 2) then
									v121[3] = v34() - (2 ^ 16);
								elseif (v119 == 3) then
									v121[3] = v34() - (2 ^ 16);
									v121[1069 - (68 + 997)] = v33();
								end
								v118 = 2;
							end
							if (v118 == 0) then
								v119 = v31(v109, 2, 3);
								v120 = v31(v109, 4, 6);
								v118 = 1;
							end
							if (v118 == 2) then
								if (v31(v120, 1, 1) == 1) then
									v121[2] = v72[v121[2]];
								end
								if (v31(v120, 1272 - (226 + 1044), 2) == 1) then
									v121[3] = v72[v121[3]];
								end
								v118 = 3;
							end
						end
					end
				end
				for v110 = 1, v34() do
					v68[v110 - 1] = v39();
				end
				return v70;
			end
		end
	end
	local function v40(v73, v74, v75)
		local v76 = v73[1];
		local v77 = v73[2];
		local v78 = v73[3];
		return function(...)
			local v79 = v76;
			local v80 = v77;
			local v81 = v78;
			local v82 = v38;
			local v83 = 118 - (32 + 85);
			local v84 = -(1 + 0);
			local v85 = {};
			local v86 = {...};
			local v87 = v20("#", ...) - 1;
			local v88 = {};
			local v89 = {};
			for v98 = 0, v87 do
				if (v98 >= v81) then
					v85[v98 - v81] = v86[v98 + 1];
				else
					v89[v98] = v86[v98 + 1];
				end
			end
			local v90 = (v87 - v81) + 1;
			local v91;
			local v92;
			while true do
				local v99 = 0;
				while true do
					if (v99 == 0) then
						v91 = v79[v83];
						v92 = v91[958 - (892 + 65)];
						v99 = 1;
					end
					if (1 == v99) then
						if (v92 <= 43) then
							if (v92 <= 21) then
								if (v92 <= 10) then
									if (v92 <= 4) then
										if (v92 <= (2 - 1)) then
											if (v92 == (0 - 0)) then
												v89[v91[2]] = v89[v91[3]][v91[4]];
											else
												local v140 = 0;
												local v141;
												local v142;
												while true do
													if (v140 == 0) then
														v141 = v91[3 - 1];
														v142 = {};
														v140 = 1;
													end
													if (v140 == 1) then
														for v343 = 1, #v88 do
															local v344 = 0;
															local v345;
															while true do
																if (0 == v344) then
																	v345 = v88[v343];
																	for v402 = 350 - (87 + 263), #v345 do
																		local v403 = v345[v402];
																		local v404 = v403[1];
																		local v405 = v403[182 - (67 + 113)];
																		if ((v404 == v89) and (v405 >= v141)) then
																			local v424 = 0;
																			while true do
																				if (v424 == 0) then
																					v142[v405] = v404[v405];
																					v403[1] = v142;
																					break;
																				end
																			end
																		end
																	end
																	break;
																end
															end
														end
														break;
													end
												end
											end
										elseif (v92 <= 2) then
											v83 = v91[3];
										elseif (v92 == 3) then
											v89[v91[2]] = v89[v91[3]] % v89[v91[4]];
										else
											local v229 = 0;
											local v230;
											local v231;
											local v232;
											while true do
												if (0 == v229) then
													v230 = v91[2];
													v231 = v89[v230];
													v229 = 1;
												end
												if (v229 == 1) then
													v232 = v89[v230 + 2];
													if (v232 > 0) then
														if (v231 > v89[v230 + 1]) then
															v83 = v91[3];
														else
															v89[v230 + 3] = v231;
														end
													elseif (v231 < v89[v230 + 1]) then
														v83 = v91[3];
													else
														v89[v230 + 3] = v231;
													end
													break;
												end
											end
										end
									elseif (v92 <= (6 + 1)) then
										if (v92 <= 5) then
											if (v89[v91[2]] == v91[4]) then
												v83 = v83 + 1;
											else
												v83 = v91[3];
											end
										elseif (v92 == 6) then
											v89[v91[2]] = not v89[v91[3]];
										else
											do
												return v89[v91[2]]();
											end
										end
									elseif (v92 <= 8) then
										local v144 = v91[2];
										local v145 = {};
										for v209 = 1, #v88 do
											local v210 = 0;
											local v211;
											while true do
												if (v210 == 0) then
													v211 = v88[v209];
													for v365 = 0, #v211 do
														local v366 = 0;
														local v367;
														local v368;
														local v369;
														while true do
															if (v366 == 0) then
																v367 = v211[v365];
																v368 = v367[1];
																v366 = 1;
															end
															if (v366 == 1) then
																v369 = v367[2];
																if ((v368 == v89) and (v369 >= v144)) then
																	local v425 = 0;
																	while true do
																		if (v425 == 0) then
																			v145[v369] = v368[v369];
																			v367[1] = v145;
																			break;
																		end
																	end
																end
																break;
															end
														end
													end
													break;
												end
											end
										end
									elseif (v92 > 9) then
										v89[v91[2]][v91[3]] = v91[4];
									elseif (v91[2] == v89[v91[4]]) then
										v83 = v83 + 1;
									else
										v83 = v91[3];
									end
								elseif (v92 <= 15) then
									if (v92 <= 12) then
										if (v92 > 11) then
											v89[v91[4 - 2]][v89[v91[3]]] = v89[v91[4]];
										else
											local v148 = 0;
											local v149;
											while true do
												if (v148 == 0) then
													v149 = v91[2];
													v89[v149] = v89[v149](v21(v89, v149 + 1 + 0, v91[3]));
													break;
												end
											end
										end
									elseif (v92 <= 13) then
										v89[v91[7 - 5]] = v89[v91[3]][v89[v91[4]]];
									elseif (v92 == 14) then
										if not v89[v91[2]] then
											v83 = v83 + (953 - (802 + 150));
										else
											v83 = v91[3];
										end
									else
										v89[v91[2]] = v89[v91[3]] + v91[4];
									end
								elseif (v92 <= 18) then
									if (v92 <= 16) then
										local v152 = v91[2];
										local v153, v154 = v82(v89[v152](v21(v89, v152 + 1, v84)));
										v84 = (v154 + v152) - 1;
										local v155 = 0;
										for v212 = v152, v84 do
											v155 = v155 + 1;
											v89[v212] = v153[v155];
										end
									elseif (v92 > 17) then
										local v238 = 0;
										local v239;
										local v240;
										local v241;
										while true do
											if (v238 == 2) then
												if (v240 > 0) then
													if (v241 <= v89[v239 + 1]) then
														v83 = v91[7 - 4];
														v89[v239 + (5 - 2)] = v241;
													end
												elseif (v241 >= v89[v239 + 1]) then
													v83 = v91[3];
													v89[v239 + 3] = v241;
												end
												break;
											end
											if (v238 == 0) then
												v239 = v91[2];
												v240 = v89[v239 + 2];
												v238 = 1;
											end
											if (v238 == 1) then
												v241 = v89[v239] + v240;
												v89[v239] = v241;
												v238 = 2;
											end
										end
									elseif (v89[v91[2]] == v89[v91[4]]) then
										v83 = v83 + 1;
									else
										v83 = v91[3];
									end
								elseif (v92 <= 19) then
									local v156 = v91[2];
									local v157 = v89[v156];
									for v215 = v156 + 1, v84 do
										v15(v157, v89[v215]);
									end
								elseif (v92 == 20) then
									v89[v91[2]] = v91[3] ~= 0;
								else
									local v243 = v80[v91[3]];
									local v244;
									local v245 = {};
									v244 = v18({}, {[v7("\132\111\179\207\223\229\107", "\19\219\48\218\161\187\128")]=function(v314, v315)
										local v316 = v245[v315];
										return v316[1 + 0][v316[2]];
									end,[v7("\67\118\213\74\18\120\114\77\222\87", "\17\28\41\187\47\101")]=function(v317, v318, v319)
										local v320 = 0;
										local v321;
										while true do
											if (v320 == 0) then
												v321 = v245[v318];
												v321[1][v321[2]] = v319;
												break;
											end
										end
									end});
									for v322 = 1, v91[4] do
										v83 = v83 + 1;
										local v323 = v79[v83];
										if (v323[998 - (915 + 82)] == 72) then
											v245[v322 - (2 - 1)] = {v89,v323[3]};
										else
											v245[v322 - 1] = {v74,v323[2 + 1]};
										end
										v88[#v88 + (1 - 0)] = v245;
									end
									v89[v91[2]] = v40(v243, v244, v75);
								end
							elseif (v92 <= 32) then
								if (v92 <= 26) then
									if (v92 <= 23) then
										if (v92 > 22) then
											local v158 = 0;
											local v159;
											while true do
												if (v158 == 0) then
													v159 = v91[2];
													do
														return v21(v89, v159, v84);
													end
													break;
												end
											end
										else
											local v160 = v91[2];
											do
												return v21(v89, v160, v84);
											end
										end
									elseif (v92 <= (1211 - (1069 + 118))) then
										v89[v91[2]] = v75[v91[3]];
									elseif (v92 > 25) then
										v89[v91[2]]();
									else
										v89[v91[2]] = v91[3] + v89[v91[4]];
									end
								elseif (v92 <= 29) then
									if (v92 <= 27) then
										v89[v91[2]] = not v89[v91[3]];
									elseif (v92 > 28) then
										if v89[v91[2]] then
											v83 = v83 + 1;
										else
											v83 = v91[3];
										end
									else
										local v248 = 0;
										local v249;
										while true do
											if (v248 == 0) then
												v249 = v91[2];
												v89[v249](v89[v249 + 1]);
												break;
											end
										end
									end
								elseif (v92 <= 30) then
									do
										return v89[v91[2]]();
									end
								elseif (v92 > (70 - 39)) then
									local v250 = v91[2];
									local v251 = v89[v250];
									for v326 = v250 + 1, v84 do
										v15(v251, v89[v326]);
									end
								else
									local v252 = 0;
									local v253;
									while true do
										if (v252 == 0) then
											v253 = v91[2];
											do
												return v89[v253](v21(v89, v253 + 1, v91[3]));
											end
											break;
										end
									end
								end
							elseif (v92 <= 37) then
								if (v92 <= 34) then
									if (v92 == 33) then
										local v164 = v91[2];
										local v165 = v89[v91[3]];
										v89[v164 + 1] = v165;
										v89[v164] = v165[v91[4]];
									else
										v89[v91[3 - 1]] = v89[v91[1 + 2]][v89[v91[4]]];
									end
								elseif (v92 <= 35) then
									local v171 = v91[3 - 1];
									v89[v171] = v89[v171](v21(v89, v171 + 1, v84));
								elseif (v92 > 36) then
									v89[v91[2]] = v91[3 + 0] + v89[v91[4]];
								else
									v89[v91[2]][v91[3]] = v89[v91[4]];
								end
							elseif (v92 <= 40) then
								if (v92 <= 38) then
									v89[v91[2]] = v89[v91[3]] % v91[4];
								elseif (v92 > 39) then
									v89[v91[2]] = {};
								else
									local v258 = 0;
									local v259;
									while true do
										if (v258 == 0) then
											v259 = v91[2];
											v89[v259] = v89[v259](v21(v89, v259 + 1, v91[3]));
											break;
										end
									end
								end
							elseif (v92 <= 41) then
								local v174 = 0;
								local v175;
								while true do
									if (v174 == 0) then
										v175 = v91[2];
										v89[v175](v21(v89, v175 + 1, v91[794 - (368 + 423)]));
										break;
									end
								end
							elseif (v92 > 42) then
								local v260 = 0;
								local v261;
								local v262;
								local v263;
								while true do
									if (v260 == 2) then
										if (v262 > 0) then
											if (v263 <= v89[v261 + 1]) then
												v83 = v91[3];
												v89[v261 + 3] = v263;
											end
										elseif (v263 >= v89[v261 + (3 - 2)]) then
											local v419 = 0;
											while true do
												if (0 == v419) then
													v83 = v91[3];
													v89[v261 + 3] = v263;
													break;
												end
											end
										end
										break;
									end
									if (v260 == 0) then
										v261 = v91[2];
										v262 = v89[v261 + 2];
										v260 = 1;
									end
									if (v260 == 1) then
										v263 = v89[v261] + v262;
										v89[v261] = v263;
										v260 = 2;
									end
								end
							else
								v89[v91[2]] = v75[v91[3]];
							end
						elseif (v92 <= 65) then
							if (v92 <= 54) then
								if (v92 <= 48) then
									if (v92 <= 45) then
										if (v92 == 44) then
											local v176 = v91[20 - (10 + 8)];
											v89[v176](v21(v89, v176 + 1, v91[3]));
										else
											local v177 = 0;
											local v178;
											while true do
												if (v177 == 0) then
													v178 = v91[2];
													v89[v178](v21(v89, v178 + 1, v84));
													break;
												end
											end
										end
									elseif (v92 <= 46) then
										local v179 = 0;
										local v180;
										local v181;
										local v182;
										local v183;
										while true do
											if (v179 == 1) then
												v84 = (v182 + v180) - 1;
												v183 = 0;
												v179 = 2;
											end
											if (v179 == 0) then
												v180 = v91[2];
												v181, v182 = v82(v89[v180](v89[v180 + 1]));
												v179 = 1;
											end
											if (2 == v179) then
												for v351 = v180, v84 do
													local v352 = 0;
													while true do
														if (v352 == 0) then
															v183 = v183 + 1;
															v89[v351] = v181[v183];
															break;
														end
													end
												end
												break;
											end
										end
									elseif (v92 > 47) then
										v74[v91[3]] = v89[v91[2]];
									else
										for v330 = v91[2], v91[3] do
											v89[v330] = nil;
										end
									end
								elseif (v92 <= 51) then
									if (v92 <= (188 - 139)) then
										v83 = v91[3];
									elseif (v92 > 50) then
										v89[v91[444 - (416 + 26)]][v91[3]] = v89[v91[4]];
									else
										v74[v91[3]] = v89[v91[6 - 4]];
									end
								elseif (v92 <= 52) then
									v89[v91[2]] = v89[v91[3]];
								elseif (v92 == 53) then
									for v332 = v91[2], v91[3] do
										v89[v332] = nil;
									end
								else
									local v272 = v91[2];
									local v273, v274 = v82(v89[v272](v89[v272 + 1]));
									v84 = (v274 + v272) - 1;
									local v275 = 0 + 0;
									for v334 = v272, v84 do
										v275 = v275 + (1 - 0);
										v89[v334] = v273[v275];
									end
								end
							elseif (v92 <= 59) then
								if (v92 <= 56) then
									if (v92 == 55) then
										v89[v91[2]]();
									else
										local v187 = v80[v91[3]];
										local v188;
										local v189 = {};
										v188 = v18({}, {[v7("\13\57\51\176\5\55\30", "\97\82\102\90\222")]=function(v216, v217)
											local v218 = 0;
											local v219;
											while true do
												if (0 == v218) then
													v219 = v189[v217];
													return v219[1][v219[2]];
												end
											end
										end,[v7("\17\148\69\194\64\165\32\175\78\223", "\204\78\203\43\167\55")]=function(v220, v221, v222)
											local v223 = 0;
											local v224;
											while true do
												if (v223 == 0) then
													v224 = v189[v221];
													v224[1][v224[2]] = v222;
													break;
												end
											end
										end});
										for v225 = 1, v91[4] do
											v83 = v83 + (439 - (145 + 293));
											local v226 = v79[v83];
											if (v226[1] == 72) then
												v189[v225 - 1] = {v89,v226[1 + 2]};
											else
												v189[v225 - 1] = {v74,v226[3]};
											end
											v88[#v88 + 1 + 0] = v189;
										end
										v89[v91[2]] = v40(v187, v188, v75);
									end
								elseif (v92 <= (829 - (201 + 571))) then
									v89[v91[2]] = #v89[v91[3]];
								elseif (v92 == 58) then
									v89[v91[2]][v89[v91[1141 - (116 + 1022)]]] = v89[v91[4]];
								else
									v89[v91[2]] = v91[3];
								end
							elseif (v92 <= 62) then
								if (v92 <= 60) then
									if (v91[2] == v89[v91[16 - 12]]) then
										v83 = v83 + 1;
									else
										v83 = v91[3];
									end
								elseif (v92 == 61) then
									if not v89[v91[2]] then
										v83 = v83 + 1 + 0;
									else
										v83 = v91[10 - 7];
									end
								elseif (v89[v91[2]] == v91[4]) then
									v83 = v83 + 1;
								else
									v83 = v91[10 - 7];
								end
							elseif (v92 <= 63) then
								v89[v91[2]] = {};
							elseif (v92 == 64) then
								local v281 = 0;
								local v282;
								while true do
									if (v281 == 0) then
										v282 = v91[2];
										do
											return v89[v282](v21(v89, v282 + 1, v91[3]));
										end
										break;
									end
								end
							else
								v89[v91[2]] = v91[3];
							end
						elseif (v92 <= 76) then
							if (v92 <= 70) then
								if (v92 <= 67) then
									if (v92 > 66) then
										if (v89[v91[2]] == v89[v91[4]]) then
											v83 = v83 + 1;
										else
											v83 = v91[3];
										end
									else
										local v193 = 0;
										local v194;
										local v195;
										local v196;
										local v197;
										while true do
											if (0 == v193) then
												v194 = v91[2];
												v195, v196 = v82(v89[v194](v21(v89, v194 + 1, v91[3])));
												v193 = 1;
											end
											if (v193 == 1) then
												v84 = (v196 + v194) - 1;
												v197 = 0;
												v193 = 2;
											end
											if (v193 == 2) then
												for v358 = v194, v84 do
													v197 = v197 + 1;
													v89[v358] = v195[v197];
												end
												break;
											end
										end
									end
								elseif (v92 <= 68) then
									v89[v91[2]][v91[3]] = v91[4];
								elseif (v92 == 69) then
									v89[v91[2]] = v89[v91[3]][v91[4]];
								else
									do
										return;
									end
								end
							elseif (v92 <= (932 - (814 + 45))) then
								if (v92 <= 71) then
									v89[v91[2]] = v89[v91[3]] % v89[v91[4]];
								elseif (v92 == 72) then
									v89[v91[4 - 2]] = v89[v91[3]];
								else
									v89[v91[2]] = v91[3] ~= 0;
								end
							elseif (v92 <= 74) then
								do
									return;
								end
							elseif (v92 > 75) then
								if v89[v91[2]] then
									v83 = v83 + 1;
								else
									v83 = v91[1 + 2];
								end
							else
								local v291 = v91[2];
								local v292, v293 = v82(v89[v291](v21(v89, v291 + 1, v84)));
								v84 = (v293 + v291) - 1;
								local v294 = 0;
								for v340 = v291, v84 do
									local v341 = 0;
									while true do
										if (v341 == 0) then
											v294 = v294 + 1;
											v89[v340] = v292[v294];
											break;
										end
									end
								end
							end
						elseif (v92 <= 81) then
							if (v92 <= 78) then
								if (v92 == 77) then
									local v201 = v91[2];
									v89[v201](v21(v89, v201 + 1, v84));
								else
									local v202 = 0;
									local v203;
									while true do
										if (v202 == 0) then
											v203 = v91[2];
											v89[v203](v89[v203 + 1]);
											break;
										end
									end
								end
							elseif (v92 <= 79) then
								local v204 = v91[2];
								v89[v204] = v89[v204](v21(v89, v204 + 1, v84));
							elseif (v92 == (29 + 51)) then
								v89[v91[2]] = v89[v91[3]] + v91[4];
							else
								v89[v91[2]] = v89[v91[3]] % v91[4];
							end
						elseif (v92 <= 84) then
							if (v92 <= 82) then
								v89[v91[2]] = v74[v91[3]];
							elseif (v92 > 83) then
								local v297 = 0;
								local v298;
								local v299;
								local v300;
								while true do
									if (v297 == 1) then
										v300 = v89[v298 + 2];
										if (v300 > 0) then
											if (v299 > v89[v298 + 1]) then
												v83 = v91[3];
											else
												v89[v298 + 3] = v299;
											end
										elseif (v299 < v89[v298 + 1]) then
											v83 = v91[3];
										else
											v89[v298 + 3] = v299;
										end
										break;
									end
									if (v297 == 0) then
										v298 = v91[887 - (261 + 624)];
										v299 = v89[v298];
										v297 = 1;
									end
								end
							else
								local v301 = 0;
								local v302;
								local v303;
								while true do
									if (v301 == 1) then
										v89[v302 + 1] = v303;
										v89[v302] = v303[v91[4]];
										break;
									end
									if (0 == v301) then
										v302 = v91[2];
										v303 = v89[v91[3]];
										v301 = 1;
									end
								end
							end
						elseif (v92 <= 85) then
							v89[v91[2]] = #v89[v91[3]];
						elseif (v92 == (152 - 66)) then
							v89[v91[2]] = v74[v91[3]];
						else
							local v306 = 0;
							local v307;
							local v308;
							local v309;
							local v310;
							while true do
								if (v306 == 2) then
									for v396 = v307, v84 do
										v310 = v310 + 1;
										v89[v396] = v308[v310];
									end
									break;
								end
								if (v306 == 1) then
									v84 = (v309 + v307) - 1;
									v310 = 0;
									v306 = 2;
								end
								if (v306 == 0) then
									v307 = v91[2];
									v308, v309 = v82(v89[v307](v21(v89, v307 + 1, v91[3])));
									v306 = 1;
								end
							end
						end
						v83 = v83 + 1;
						break;
					end
				end
			end
		end;
	end
	return v40(v39(), {}, v28)(...);
end
return v23("LOL!0D3Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E7365727403053Q006D6174636803083Q00746F6E756D62657203053Q007063612Q6C00243Q0012183Q00013Q00206Q0002001218000100013Q00202Q000100010003001218000200013Q00202Q000200020004001218000300053Q00060E0003000A000100010004313Q000A0001001218000300063Q00202Q000400030007001218000500083Q00202Q000500050009001218000600083Q00202Q00060006000A00063800073Q000100062Q00483Q00064Q00488Q00483Q00044Q00483Q00014Q00483Q00024Q00483Q00053Q001218000800013Q00202Q00080008000B0012180009000C3Q001218000A000D3Q000638000B0001000100052Q00483Q00074Q00483Q00094Q00483Q00084Q00483Q000A4Q00483Q000B4Q0034000C000B4Q001E000C00014Q0017000C6Q004A3Q00013Q00023Q00023Q00026Q00F03F026Q00704002264Q002800025Q001241000300014Q003900045Q001241000500013Q0004540003002100012Q005600076Q0034000800024Q0056000900014Q0056000A00024Q0056000B00034Q0056000C00044Q0034000D6Q0034000E00063Q00200F000F000600012Q0042000C000F4Q004F000B3Q00022Q0056000C00034Q0056000D00044Q0034000E00014Q0039000F00014Q0003000F0006000F001025000F0001000F2Q0039001000014Q000300100006001000102500100001001000200F0010001000012Q0042000D00104Q0010000C6Q004F000A3Q0002002051000A000A00022Q002E0009000A4Q004D00073Q00010004120003000500012Q0056000300054Q0034000400024Q0040000300044Q001700036Q004A3Q00017Q00043Q00027Q004003053Q003A25642B3A2Q033Q0025642B026Q00F03F001C3Q0006385Q000100012Q00528Q0056000100014Q0056000200024Q0056000300024Q002800046Q0056000500034Q003400066Q002F000700074Q0042000500074Q002000043Q000100202Q000400040001001241000500024Q000B000300050002001241000400034Q0042000200044Q004F00013Q000200260500010018000100040004313Q001800012Q003400016Q002800026Q0040000100024Q001700015Q0004313Q001B00012Q0056000100044Q001E000100014Q001700016Q004A3Q00013Q00013Q00A13Q0003043Q0067616D65030A3Q0047657453657276696365030A3Q00CFDC2F3294B10BFFE9C103083Q00B89CA84E40E0D47903073Q00536574436F726503103Q0034EBABCA29E1B1C701E7A6CF13E7AAC003043Q00AE678EC503053Q0062214B342003073Q009836483F58453E030A3Q00F2C8EF4FDCC8E75BDCD003043Q003CB4A48E03043Q006C5B1D3D03073Q0072383E6549478D031D3Q0095E8DFC1F8EBC28492E8D8CBBAA9FBCEB9EAD4C687E0C9CDABE18B94E103043Q00A4D889BB03073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C6179657247756903063Q004D61696E554903093Q00496E69746961746F7203093Q004D61696E5F47616D65030E3Q0052656D6F74654C697374656E657203073Q004D6F64756C6573030A3Q004765744F626A6563747303183Q00C0E429B3B5ED0EC6EF35E8E9B15A80B168E6F5AB5E82B46503073Q006BB28651D2C69E026Q00F03F030C3Q0043616E426544726F2Q706564010003063Q0048616E646C6503083Q004D6174657269616C03043Q00456E756D03053Q004D6574616C03053Q00436F6C6F7203063Q00436F6C6F723303073Q0066726F6D524742025Q00C05240025Q00C05340025Q00805740030C3Q005472616E73706172656E6379028Q0003043Q004461726B025Q00C05640025Q00405740025Q00405A4003053Q00476C612Q73025Q00E06F4003063Q00537769746368025Q00206240025Q00406240025Q0040644003063Q00506172656E7403083Q004261636B7061636B030C3Q0057616974466F724368696C6403063Q00100F8CC2A63D03053Q00CA586EE2A603093Q0053706F744C69676874030A3Q004272696768746E652Q73026Q00084003063Q00EB0E8CF32QC603053Q00AAA36FE29703053Q0052616E676503063Q003931BC3C423203073Q00497150D2582E5703053Q00416E676C65026Q004E4003063Q00A92DC316EB8403053Q0087E14CAD72025Q00A06740025Q00A06240025Q00405C40030C3Q00536574412Q74726962757465030F3Q0036E4BF2QB88EA80FFFBBB58EB8A61703073Q00C77A8DD8D0CCDD03113Q0081D417F86CC5A2C802F37DC5B9CF1FFE7F03063Q0096CDBD70901803074Q008ABE4E088D1503083Q007045E4DF2C64E871030C3Q00FD1113D6A47D85C01E05DFB303073Q00E6B47F67B3D61C030B3Q00A00C584EF072EF99175C4303073Q0080EC653F268421030A3Q0082A81C4186E7DABEA81D03073Q00AFCCC97124D68B030B3Q0074C434D7014BC532D4105403053Q006427AC55BC030C3Q008379B48500A476BE953FAC6A03053Q0053CD18D9E0030A3Q00D5CDCC36E3C9C43AEED103043Q005D86A5AD03063Q00434672616D652Q033Q006E65770200C005E0FF44B8BF02303E0BE0FE4F84BF02CFC9F89FCF93B83F026Q00F0BF03043Q0047726970030A3Q00576F726C645069766F74028EE733A05E3C6F40020024EC3E747FF83F0282B68B1F19E530C00200303980417CE8BF025F4DE37F83657E3F02DC632B60E999E43F0251075800C4493DBF027E48256067FFEF3F0264D2211F94B188BF0200F0C89F429AE4BF02E079F65FE97B83BF02F4FC01C0C57BE8BF03043Q004E616D65030A3Q0098FEC0D132C2BB79B6E603083Q001EDE92A1A25AAED203083Q00496E7374616E636503063Q00C3417C0EE05C03043Q006A852E10030A3Q00792E7AF15B54512F7DEF03063Q00203840139C3A03093Q007BC6EC2Q5BE68955C603073Q00E03AA885363A92030B3Q00416E696D6174696F6E496403183Q004B5453FC6695821F505211B23AD7D258010019AF21DEDF5303083Q006B39362B9D15E6E703093Q00FA8518F8B8C8C6D48503073Q00AFBBEB7195D9BC03183Q002EAD994DF06A7D28A68516AC36296DFCD61EB62C2E68FDD803073Q00185CCFE12C831903093Q006ADDB1411A6942DCB603063Q001D2BB3D82C7B03183Q00AFDB384DAECA2558B4DD7A03F288751FE58F731AE58F711503043Q002CDDB94003053Q0032E85D517703053Q00136187283F030B3Q009D5432302A0E9D5326352B03063Q0051CE3C535B4F03063Q00566F6C756D6503073Q00536F756E64496403173Q005CA9C8733CD048B047AF8A3D609A1CF51AFF88237D951D03083Q00C42ECBB0124FA32D030D3Q00506C61796261636B53702Q656402CD5QCCEC3F03093Q0054657874757265496403183Q00AA20661F37E8EAAC2B7A446BB4BEEE74264E72AAB9EA712F03073Q008FD8421E7E449B03093Q0043686172616374657203153Q0046696E6446697273744368696C644F66436C612Q7303083Q0082DD00CACBACDEE503083Q0081CAA86DABA5C3B703083Q0003563ED5DF00E93003073Q0086423857B8BE74030D3Q004C6F6164416E696D6174696F6E03083Q005072696F7269747903113Q00416E696D6174696F6E5072696F7269747903073Q00416374696F6E3303043Q00506C617903093Q0041637469766174656403073Q00436F2Q6E656374030A3Q0052756E53657276696365030D3Q0052656E6465725374652Q70656403083Q00457175692Q706564030A3Q00556E657175692Q7065640183012Q00064C3Q00812Q013Q0004313Q00812Q01001218000100013Q0020530001000100022Q005600035Q001241000400033Q001241000500044Q0042000300054Q004F00013Q00020020530001000100052Q005600035Q001241000400063Q001241000500074Q000B0003000500022Q002800043Q00022Q005600055Q001241000600083Q001241000700094Q000B0005000700022Q005600065Q0012410007000A3Q0012410008000B4Q000B0006000800022Q003A0004000500062Q005600055Q0012410006000C3Q0012410007000D4Q000B0005000700022Q005600065Q0012410007000E3Q0012410008000F4Q000B0006000800022Q003A0004000500062Q002C000100040001001218000100013Q00202Q00010001001000202Q00010001001100202Q00010001001200202Q00010001001300202Q00010001001400202Q00010001001500202Q00010001001600202Q000100010017001218000200013Q0020530002000200182Q005600045Q001241000500193Q0012410006001A4Q0042000400064Q004F00023Q000200202Q00020002001B0030440002001C001D00202Q00030002001E001218000400203Q00202Q00040004001F00202Q0004000400210010330003001F000400202Q00030002001E001218000400233Q00202Q000400040024001241000500253Q001241000600263Q001241000700274Q000B00040007000200103300030022000400202Q00030002001E00304400030028002900202Q00030002001E00202Q00030003002A001218000400233Q00202Q0004000400240012410005002B3Q0012410006002C3Q0012410007002D4Q000B00040007000200103300030022000400202Q00030002001E00202Q00030003002A001218000400203Q00202Q00040004001F00202Q0004000400210010330003001F000400202Q00030002001E00202Q00030003002E001218000400233Q00202Q0004000400240012410005002F3Q0012410006002F3Q0012410007002F4Q000B00040007000200103300030022000400202Q00030002001E00202Q000300030030001218000400233Q00202Q000400040024001241000500313Q001241000600323Q001241000700334Q000B000400070002001033000300220004001218000300013Q00202Q00030003001000202Q00030003001100202Q0003000300350010330002003400030020530003000200362Q005600055Q001241000600373Q001241000700384Q0042000500074Q004F00033Q000200202Q0003000300390030440003003A003B0020530003000200362Q005600055Q0012410006003C3Q0012410007003D4Q0042000500074Q004F00033Q000200202Q0003000300390030440003003E00250020530003000200362Q005600055Q0012410006003F3Q001241000700404Q0042000500074Q004F00033Q000200202Q0003000300390030440003004100420020530003000200362Q005600055Q001241000600433Q001241000700444Q0042000500074Q004F00033Q000200202Q000300030039001218000400233Q00202Q000400040024001241000500453Q001241000600463Q001241000700474Q000B0004000700020010330003002200040020530003000200482Q005600055Q001241000600493Q0012410007004A4Q000B0005000700022Q0049000600014Q002C0003000600010020530003000200482Q005600055Q0012410006004B3Q0012410007004C4Q000B0005000700022Q0049000600014Q002C0003000600010020530003000200482Q005600055Q0012410006004D3Q0012410007004E4Q000B0005000700022Q004900066Q002C0003000600010020530003000200482Q005600055Q0012410006004F3Q001241000700504Q000B0005000700022Q0049000600014Q002C0003000600010020530003000200482Q005600055Q001241000600513Q001241000700524Q000B0005000700022Q0049000600014Q002C0003000600010020530003000200482Q005600055Q001241000600533Q001241000700544Q000B0005000700022Q005600065Q001241000700553Q001241000800564Q0042000600084Q004D00033Q00010020530003000200482Q005600055Q001241000600573Q001241000700584Q000B0005000700022Q005600065Q001241000700593Q0012410008005A4Q0042000600084Q004D00033Q00010012180003005B3Q00202Q00030003005C0012410004005D3Q0012410005005E3Q0012410006005F3Q001241000700293Q001241000800293Q001241000900603Q001241000A00603Q001241000B00293Q001241000C00293Q001241000D00293Q001241000E001B3Q001241000F00294Q000B0003000F00020010330002006100030012180004005B3Q00202Q00040004005C001241000500633Q001241000600643Q001241000700653Q001241000800663Q001241000900673Q001241000A00683Q001241000B00693Q001241000C006A3Q001241000D006B3Q001241000E006C3Q001241000F006D3Q0012410010006E4Q000B0004001000020010330002006200042Q005600045Q001241000500703Q001241000600714Q000B0004000600020010330002006F0004001218000400723Q00202Q00040004005C2Q005600055Q001241000600733Q001241000700744Q0042000500074Q004F00043Q00022Q005600055Q001241000600753Q001241000700764Q000B0005000700020010330004006F0005001033000400340002001218000500723Q00202Q00050005005C2Q005600065Q001241000700773Q001241000800784Q0042000600084Q004F00053Q00022Q005600065Q0012410007007A3Q0012410008007B4Q000B000600080002001033000500790006001033000500340004001218000600723Q00202Q00060006005C2Q005600075Q0012410008007C3Q0012410009007D4Q0042000700094Q004F00063Q00022Q005600075Q0012410008007E3Q0012410009007F4Q000B000700090002001033000600790007001033000600340004001218000700723Q00202Q00070007005C2Q005600085Q001241000900803Q001241000A00814Q00420008000A4Q004F00073Q00022Q005600085Q001241000900823Q001241000A00834Q000B0008000A0002001033000700790008001033000700340004001218000800723Q00202Q00080008005C2Q005600095Q001241000A00843Q001241000B00854Q00420009000B4Q004F00083Q00022Q005600095Q001241000A00863Q001241000B00874Q000B0009000B00020010330008006F000900103300080034000200304400080088001B2Q005600095Q001241000A008A3Q001241000B008B4Q000B0009000B00020010330008008900090030440008008C008D2Q004900096Q0056000A5Q001241000B008F3Q001241000C00904Q000B000A000C00020010330002008E000A001218000A00013Q00202Q000A000A001000202Q000A000A001100202Q000A000A0091002053000A000A00922Q0056000C5Q001241000D00933Q001241000E00944Q0042000C000E4Q004F000A3Q0002002053000A000A00922Q0056000C5Q001241000D00953Q001241000E00964Q0042000C000E4Q004F000A3Q0002002053000B000A00972Q0034000D00064Q000B000B000D0002001218000C00203Q00202Q000C000C009900202Q000C000C009A001033000B0098000C002053000C000A00972Q0034000E00074Q000B000C000E0002001218000D00203Q00202Q000D000D009900202Q000D000D009A001033000C0098000D002053000D000C009B2Q001C000D00020001002053000D000A00972Q0034000F00054Q000B000D000F00022Q0049000E5Q00202Q000F0002009C002053000F000F009D00063800113Q000100072Q00483Q00094Q00483Q00024Q00483Q000E4Q00483Q00014Q00528Q00483Q000D4Q00483Q00084Q002C000F00110001001218000F009E3Q00202Q000F000F009F002053000F000F009D00063800110001000100042Q00483Q000E4Q00483Q00024Q00528Q00483Q00084Q002C000F0011000100202Q000F000200A0002053000F000F009D00063800110002000100022Q00483Q000C4Q00483Q000B4Q002C000F0011000100202Q000F000200A1002053000F000F009D00063800110003000100042Q00483Q00014Q00528Q00483Q000B4Q00483Q000E4Q002C000F001100012Q000100015Q0004313Q00822Q0100202Q00013Q001B2Q004A3Q00013Q00043Q00233Q00010003063Q00506172656E7403043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572028Q00026Q000840026Q00F03F026Q0010402Q01030E3Q0046696E6446697273744368696C6403073Q000F321BBE1CE82903083Q00555C5169DB798B4103073Q005363722Q65636803043Q004E616D6503083Q00CEB0424079DCF58C03063Q00BF9DD330251C03083Q00EC1CE6193FDC17CB03053Q005ABF7F947C030B3Q00416E74695363722Q65636803083Q004B843C127D84262803043Q007718E74E03073Q00B12EB74FD9431903073Q0071E24DC52ABC2003043Q007461736B03043Q0077616974026Q00D03F03083Q005072696F7269747903043Q00456E756D03113Q00416E696D6174696F6E5072696F7269747903073Q00416374696F6E3403043Q0053746F70027Q004003043Q00506C617900B44Q00567Q0026053Q00B3000100010004313Q00B300012Q00563Q00013Q00206Q0002001218000100033Q00202Q00010001000400202Q00010001000500202Q0001000100060006433Q00B3000100010004313Q00B300010012413Q00074Q002F000100013Q0026053Q000D000100070004313Q000D0001001241000100073Q00260500010049000100080004313Q00490001001241000200073Q00260500020017000100090004313Q001700010012410001000A3Q0004313Q0049000100260500020013000100070004313Q001300012Q0056000300024Q0006000300034Q0030000300024Q0056000300023Q002605000300300001000B0004313Q003000012Q0056000300033Q00205300030003000C2Q0056000500043Q0012410006000D3Q0012410007000E4Q0042000500074Q004F00033Q000200064C0003004700013Q0004313Q004700012Q0056000300033Q00202Q00030003000F2Q0056000400043Q001241000500113Q001241000600124Q000B0004000600020010330003001000040004313Q004700012Q0056000300033Q00205300030003000C2Q0056000500043Q001241000600133Q001241000700144Q0042000500074Q004F00033Q000200064C0003004700013Q0004313Q00470001001218000300153Q00260500030047000100010004313Q004700012Q0056000300034Q0056000400043Q001241000500163Q001241000600174Q000B0004000600022Q00220003000300042Q0056000400043Q001241000500183Q001241000600194Q000B000400060002001033000300100004001241000200093Q0004313Q00130001002605000100520001000A0004313Q005200010012180002001A3Q00202Q00020002001B0012410003001C4Q001C0002000200012Q004900026Q003000025Q0004313Q00B3000100260500010073000100070004313Q00730001001241000200074Q002F000300033Q00260500020056000100070004313Q00560001001241000300073Q0026050003005D000100090004313Q005D0001001241000100093Q0004313Q0073000100260500030059000100070004313Q00590001001241000400073Q000E3C00090064000100040004313Q00640001001241000300093Q0004313Q0059000100260500040060000100070004313Q006000012Q0056000500053Q0012180006001E3Q00202Q00060006001F00202Q0006000600200010330005001D00062Q0056000500053Q0020530005000500212Q001C000500020001001241000400093Q0004313Q006000010004313Q005900010004313Q007300010004313Q0056000100260500010092000100220004313Q00920001001241000200074Q002F000300033Q000E3C00070077000100020004313Q00770001001241000300073Q0026050003007E000100090004313Q007E0001001241000100083Q0004313Q009200010026050003007A000100070004313Q007A0001001241000400073Q000E3C0007008A000100040004313Q008A00012Q0056000500053Q0020530005000500232Q001C0005000200012Q0056000500063Q0020530005000500232Q001C000500020001001241000400093Q000E3C00090081000100040004313Q00810001001241000300093Q0004313Q007A00010004313Q008100010004313Q007A00010004313Q009200010004313Q0077000100260500010010000100090004313Q00100001001241000200074Q002F000300033Q00260500020096000100070004313Q00960001001241000300073Q002605000300A9000100070004313Q00A90001001241000400073Q002605000400A4000100070004313Q00A400012Q0049000500014Q003000055Q0012180005001A3Q00202Q00050005001B2Q0037000500010001001241000400093Q0026050004009C000100090004313Q009C0001001241000300093Q0004313Q00A900010004313Q009C000100260500030099000100090004313Q00990001001241000100223Q0004313Q001000010004313Q009900010004313Q001000010004313Q009600010004313Q001000010004313Q00B300010004313Q000D00012Q004A3Q00017Q000D3Q002Q01028Q00030C3Q0057616974466F724368696C6403063Q001217FAB1361303043Q00D55A769403093Q0053706F744C6967687403073Q00456E61626C6564030D3Q00506C61796261636B53702Q6564026Q00F03F03063Q00732FBA52415E03053Q002D3B4ED4360100026Q66E63F00314Q00567Q0026053Q001A000100010004313Q001A00010012413Q00024Q002F000100013Q0026053Q0005000100020004313Q00050001001241000100023Q00260500010008000100020004313Q000800012Q0056000200013Q0020530002000200032Q0056000400023Q001241000500043Q001241000600054Q0042000400064Q004F00023Q000200202Q0002000200060030440002000700012Q0056000200033Q0030440002000800090004313Q003000010004313Q000800010004313Q003000010004313Q000500010004313Q003000010012413Q00024Q002F000100013Q0026053Q001C000100020004313Q001C0001001241000100023Q000E3C0002001F000100010004313Q001F00012Q0056000200013Q0020530002000200032Q0056000400023Q0012410005000A3Q0012410006000B4Q0042000400064Q004F00023Q000200202Q00020002000600304400020007000C2Q0056000200033Q00304400020008000D0004313Q003000010004313Q001F00010004313Q003000010004313Q001C00012Q004A3Q00017Q00023Q00028Q0003043Q00506C617900123Q0012413Q00014Q002F000100013Q000E3C0001000200013Q0004313Q00020001001241000100013Q00260500010005000100010004313Q000500012Q005600025Q0020530002000200022Q001C0002000200012Q0056000200013Q0020530002000200022Q001C0002000200010004313Q001100010004313Q000500010004313Q001100010004313Q000200012Q004A3Q00017Q000D3Q00028Q00026Q00F03F030E3Q0046696E6446697273744368696C6403083Q002355918E832DA5CF03083Q00907036E3EBE64ECD030B3Q00416E74695363722Q656368010003083Q00802B1DF9D558BB1703063Q003BD3486F9CB003043Q004E616D6503073Q007D84F1284B84EB03043Q004D2EE78303043Q0053746F70002D3Q0012413Q00013Q0026053Q001B000100020004313Q001B00012Q005600015Q0020530001000100032Q0056000300013Q001241000400043Q001241000500054Q0042000300054Q004F00013Q000200064C0001002C00013Q0004313Q002C0001001218000100063Q0026050001002C000100070004313Q002C00012Q005600016Q0056000200013Q001241000300083Q001241000400094Q000B0002000400022Q00220001000100022Q0056000200013Q0012410003000B3Q0012410004000C4Q000B0002000400020010330001000A00020004313Q002C00010026053Q0001000100010004313Q00010001001241000100013Q00260500010022000100020004313Q002200010012413Q00023Q0004313Q000100010026050001001E000100010004313Q001E00012Q0056000200023Q00205300020002000D2Q001C0002000200012Q004900026Q0030000200033Q001241000100023Q0004313Q001E00010004313Q000100012Q004A3Q00017Q00", v17(), ...);
