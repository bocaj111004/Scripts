local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v24,v25) local v26={};for v41=1, #v24 do v6(v26,v0(v4(v1(v2(v24,v41,v41 + 1 )),v1(v2(v25,1 + (v41% #v25) ,1 + (v41% #v25) + 1 )))%256 ));end return v5(v26);end local v8=tonumber;local v9=string.byte;local v10=string.char;local v11=string.sub;local v12=string.gsub;local v13=string.rep;local v14=table.concat;local v15=table.insert;local v16=math.ldexp;local v17=getfenv or function() return _ENV;end ;local v18=setmetatable;local v19=pcall;local v20=select;local v21=unpack or table.unpack ;local v22=tonumber;local function v23(v27,v28,...) local v29=2 -1 ;local v30;v27=v12(v11(v27,5),v7("\81\186","\191\127\148\124\41"),function(v42) if (v9(v42,2)==81) then local v103=0;while true do if (0==v103) then v30=v8(v11(v42,1,1));return "";end end else local v104=0;local v105;while true do if (v104==0) then v105=v10(v8(v42,16));if v30 then local v122=0;local v123;while true do if (v122==1) then return v123;end if (0==v122) then v123=v13(v105,v30);v30=nil;v122=1;end end else return v105;end break;end end end end);local function v31(v43,v44,v45) if v45 then local v106=(v43/(2^(v44-1)))%(2^(((v45-1) -(v44-1)) + 1)) ;return v106-(v106%1) ;else local v107=0;local v108;while true do if (v107==0) then v108=2^(v44-1) ;return (((v43%(v108 + v108))>=v108) and 1) or 0 ;end end end end local function v32() local v46=v9(v27,v29,v29);v29=v29 + 1 ;return v46;end local function v33() local v47=0;local v48;local v49;while true do if (v47==0) then v48,v49=v9(v27,v29,v29 + 2 );v29=v29 + 2 ;v47=1;end if (v47==1) then return (v49 * 256) + v48 ;end end end local function v34() local v50=0;local v51;local v52;local v53;local v54;while true do if (v50==1) then return (v54 * 16777216) + (v53 * 65536) + (v52 * 256) + v51 ;end if (v50==0) then v51,v52,v53,v54=v9(v27,v29,v29 + 3 );v29=v29 + 4 ;v50=1;end end end local function v35() local v55=0;local v56;local v57;local v58;local v59;local v60;local v61;while true do if (v55==0) then v56=v34();v57=v34();v55=1;end if (v55==1) then v58=1;v59=(v31(v57,1,20) * (2^32)) + v56 ;v55=2;end if (v55==3) then if (v60==0) then if (v59==0) then return v61 * 0 ;else v60=1;v58=0;end elseif (v60==2047) then return ((v59==(0 -0)) and (v61 * (1/0))) or (v61 * NaN) ;end return v16(v61,v60-(2635 -1612) ) * (v58 + (v59/(2^52))) ;end if (v55==2) then v60=v31(v57,21,31);v61=((v31(v57,32)==1) and  -1) or (2 -1) ;v55=3;end end end local function v36(v62) local v63;if  not v62 then local v109=0;while true do if (v109==0) then v62=v34();if (v62==(619 -(555 + 64))) then return "";end break;end end end v63=v11(v27,v29,(v29 + v62) -1 );v29=v29 + v62 ;local v64={};for v78=1, #v63 do v64[v78]=v10(v9(v11(v63,v78,v78)));end return v14(v64);end local v37=v34;local function v38(...) return {...},v20("#",...);end local function v39() local v65={};local v66={};local v67={};local v68={v65,v66,nil,v67};local v69=v34();local v70={};for v80=1,v69 do local v81=0;local v82;local v83;while true do if (1==v81) then if (v82==1) then v83=v32()~=0 ;elseif (v82==(933 -(857 + 74))) then v83=v35();elseif (v82==3) then v83=v36();end v70[v80]=v83;break;end if (v81==0) then v82=v32();v83=nil;v81=1;end end end v68[3]=v32();for v84=1,v34() do local v85=0;local v86;while true do if (v85==0) then v86=v32();if (v31(v86,1,1)==0) then local v118=0;local v119;local v120;local v121;while true do if (3==v118) then if (v31(v120,3,3)==1) then v121[4]=v70[v121[4]];end v65[v84]=v121;break;end if (v118==1) then v121={v33(),v33(),nil,nil};if (v119==0) then v121[3]=v33();v121[4]=v33();elseif (v119==1) then v121[3]=v34();elseif (v119==2) then v121[3]=v34() -(2^(584 -(367 + 201))) ;elseif (v119==(930 -(214 + 713))) then local v283=0;while true do if (v283==0) then v121[3]=v34() -(2^16) ;v121[4]=v33();break;end end end v118=2;end if (v118==2) then if (v31(v120,1,1 + 0 )==1) then v121[2]=v70[v121[2]];end if (v31(v120,2,2)==1) then v121[3]=v70[v121[1 + 2 ]];end v118=3;end if (v118==0) then v119=v31(v86,2,3);v120=v31(v86,4,6);v118=1;end end end break;end end end for v87=1,v34() do v66[v87-1 ]=v39();end return v68;end local function v40(v72,v73,v74) local v75=v72[878 -(282 + 595) ];local v76=v72[2];local v77=v72[3];return function(...) local v89=v75;local v90=v76;local v91=v77;local v92=v38;local v93=1;local v94= -(1638 -(1523 + 114));local v95={};local v96={...};local v97=v20("#",...) -1 ;local v98={};local v99={};for v110=0,v97 do if (v110>=v91) then v95[v110-v91 ]=v96[v110 + 1 ];else v99[v110]=v96[v110 + 1 ];end end local v100=(v97-v91) + 1 ;local v101;local v102;while true do v101=v89[v93];v102=v101[1 + 0 ];if (v102<=32) then if (v102<=15) then if (v102<=7) then if (v102<=3) then if (v102<=1) then if (v102>0) then v99[v101[2]]=v99[v101[3]];else local v136=0;local v137;local v138;while true do if (v136==1) then for v314=v137 + 1 ,v94 do v15(v138,v99[v314]);end break;end if (v136==0) then v137=v101[2];v138=v99[v137];v136=1;end end end elseif (v102==2) then local v139=v101[2];local v140,v141=v92(v99[v139](v21(v99,v139 + 1 ,v101[3])));v94=(v141 + v139) -1 ;local v142=0;for v252=v139,v94 do local v253=0;while true do if (0==v253) then v142=v142 + 1 ;v99[v252]=v140[v142];break;end end end else v99[v101[2]][v99[v101[3 -0 ]]]=v99[v101[1069 -(68 + 997) ]];end elseif (v102<=5) then if (v102>4) then for v254=v101[2],v101[3] do v99[v254]=nil;end else v99[v101[2]]=v99[v101[3]] + v101[4] ;end elseif (v102==6) then local v146=v90[v101[3]];local v147;local v148={};v147=v18({},{[v7("\184\17\222\31\134\125\159","\24\231\78\183\113\226")]=function(v256,v257) local v258=0;local v259;while true do if (v258==0) then v259=v148[v257];return v259[1][v259[2]];end end end,[v7("\117\227\78\92\178\67\210\68\92\189","\197\42\188\32\57")]=function(v260,v261,v262) local v263=0;local v264;while true do if (v263==0) then v264=v148[v261];v264[1][v264[2]]=v262;break;end end end});for v265=1,v101[4] do local v266=0;local v267;while true do if (v266==1) then if (v267[1]==10) then v148[v265-1 ]={v99,v267[12 -9 ]};else v148[v265-1 ]={v73,v267[3]};end v98[ #v98 + 1 ]=v148;break;end if (v266==0) then v93=v93 + 1 ;v267=v89[v93];v266=1;end end end v99[v101[2]]=v40(v146,v147,v74);else v99[v101[119 -(32 + 85) ]]=v99[v101[3]]%v99[v101[4]] ;end elseif (v102<=(11 + 0)) then if (v102<=(2 + 7)) then if (v102==8) then local v151=0;local v152;local v153;local v154;local v155;while true do if (v151==1) then v94=(v154 + v152) -(2 -1) ;v155=0;v151=2;end if (v151==2) then for v322=v152,v94 do local v323=0;while true do if (v323==0) then v155=v155 + 1 ;v99[v322]=v153[v155];break;end end end break;end if (v151==0) then v152=v101[2];v153,v154=v92(v99[v152](v21(v99,v152 + (958 -(892 + 65)) ,v101[3])));v151=1;end end else local v156=0;local v157;while true do if (v156==0) then v157=v101[2];v99[v157]=v99[v157](v21(v99,v157 + 1 ,v101[3]));break;end end end elseif (v102>10) then local v158=v101[3 -1 ];local v159,v160=v92(v99[v158](v21(v99,v158 + 1 ,v94)));v94=(v160 + v158) -1 ;local v161=0;for v268=v158,v94 do v161=v161 + 1 ;v99[v268]=v159[v161];end else v99[v101[2]]=v99[v101[3]];end elseif (v102<=13) then if (v102==12) then v99[v101[2]]=v99[v101[3]]%v101[4] ;else v99[v101[2]]=v99[v101[3]][v101[4]];end elseif (v102==14) then v99[v101[2]]=v99[v101[3]]%v101[4] ;else local v168=0;local v169;while true do if (v168==0) then v169=v101[2];do return v21(v99,v169,v94);end break;end end end elseif (v102<=23) then if (v102<=19) then if (v102<=17) then if (v102>16) then v99[v101[2]]=v73[v101[3]];else v99[v101[2]]= #v99[v101[3]];end elseif (v102>18) then local v173=v101[2];local v174=v99[v101[3]];v99[v173 + 1 ]=v174;v99[v173]=v174[v101[7 -3 ]];else v99[v101[2]]={};end elseif (v102<=21) then if (v102==20) then v99[v101[2]]=v101[3];elseif (v99[v101[2]]==v101[4]) then v93=v93 + 1 ;else v93=v101[3];end elseif (v102==22) then v99[v101[2]]=v73[v101[353 -(87 + 263) ]];elseif  not v99[v101[2]] then v93=v93 + (181 -(67 + 113)) ;else v93=v101[3];end elseif (v102<=27) then if (v102<=25) then if (v102==(18 + 6)) then v99[v101[2]]= #v99[v101[7 -4 ]];else v93=v101[3];end elseif (v102>26) then local v185=0;local v186;local v187;local v188;while true do if (v185==0) then v186=v90[v101[3]];v187=nil;v185=1;end if (v185==1) then v188={};v187=v18({},{[v7("\41\203\9\67\95\43\172","\90\118\148\96\45\59\78\212")]=function(v324,v325) local v326=v188[v325];return v326[1][v326[2]];end,[v7("\207\47\88\183\231\25\88\182\245\8","\210\144\112\54")]=function(v327,v328,v329) local v330=0;local v331;while true do if (v330==0) then v331=v188[v328];v331[1][v331[2]]=v329;break;end end end});v185=2;end if (v185==2) then for v332=1 + 0 ,v101[4] do v93=v93 + (3 -2) ;local v333=v89[v93];if (v333[1]==10) then v188[v332-1 ]={v99,v333[3]};else v188[v332-1 ]={v73,v333[3]};end v98[ #v98 + 1 ]=v188;end v99[v101[2]]=v40(v186,v187,v74);break;end end else local v189=0;local v190;while true do if (v189==0) then v190=v101[2];do return v99[v190](v21(v99,v190 + 1 ,v101[3]));end break;end end end elseif (v102<=29) then if (v102==28) then v99[v101[5 -3 ]]=v101[3];else do return v99[v101[2]]();end end elseif (v102<=30) then local v193=0;local v194;local v195;while true do if (v193==1) then v99[v194 + 1 ]=v195;v99[v194]=v195[v101[6 -2 ]];break;end if (v193==0) then v194=v101[2];v195=v99[v101[3]];v193=1;end end elseif (v102>31) then if (v99[v101[2]]==v101[4]) then v93=v93 + 1 ;else v93=v101[3];end elseif v99[v101[2 + 0 ]] then v93=v93 + 1 ;else v93=v101[3];end elseif (v102<=48) then if (v102<=40) then if (v102<=36) then if (v102<=(1031 -(915 + 82))) then if (v102==(93 -60)) then v99[v101[2]]=v101[2 + 1 ] + v99[v101[4]] ;else local v197=v101[2];do return v99[v197](v21(v99,v197 + (1 -0) ,v101[3]));end end elseif (v102>35) then local v198=0;local v199;while true do if (v198==0) then v199=v101[2];v99[v199]=v99[v199](v21(v99,v199 + 1 ,v94));break;end end else local v200=0;local v201;local v202;local v203;while true do if (v200==2) then if (v202>0) then if (v203<=v99[v201 + (2 -1) ]) then local v358=0;while true do if (v358==0) then v93=v101[3];v99[v201 + 3 ]=v203;break;end end end elseif (v203>=v99[v201 + 1 ]) then v93=v101[3];v99[v201 + 3 ]=v203;end break;end if (v200==0) then v201=v101[1189 -(1069 + 118) ];v202=v99[v201 + 2 ];v200=1;end if (v200==1) then v203=v99[v201] + v202 ;v99[v201]=v203;v200=2;end end end elseif (v102<=38) then if (v102==37) then local v204=v101[2];local v205,v206=v92(v99[v204](v99[v204 + 1 ]));v94=(v206 + v204) -(1 -0) ;local v207=0;for v271=v204,v94 do local v272=0;while true do if (v272==0) then v207=v207 + 1 ;v99[v271]=v205[v207];break;end end end else local v208=v101[2];v99[v208]=v99[v208](v21(v99,v208 + 1 ,v94));end elseif (v102==39) then do return;end else local v210=0;local v211;while true do if (0==v210) then v211=v101[2];v99[v211](v21(v99,v211 + 1 ,v101[3]));break;end end end elseif (v102<=44) then if (v102<=42) then if (v102>41) then do return;end else local v212=0;local v213;local v214;local v215;local v216;while true do if (v212==0) then v213=v101[2];v214,v215=v92(v99[v213](v99[v213 + 1 ]));v212=1;end if (v212==2) then for v339=v213,v94 do v216=v216 + 1 ;v99[v339]=v214[v216];end break;end if (v212==1) then v94=(v215 + v213) -1 ;v216=0;v212=2;end end end elseif (v102==43) then local v217=0;local v218;while true do if (v217==0) then v218=v101[1 + 1 ];do return v21(v99,v218,v94);end break;end end elseif  not v99[v101[2]] then v93=v93 + 1 ;else v93=v101[3];end elseif (v102<=46) then if (v102>45) then local v219=0;local v220;local v221;local v222;while true do if (v219==0) then v220=v101[2];v221=v99[v220 + 2 ];v219=1;end if (v219==1) then v222=v99[v220] + v221 ;v99[v220]=v222;v219=2;end if (v219==2) then if (v221>(0 -0)) then if (v222<=v99[v220 + 1 ]) then v93=v101[3];v99[v220 + 3 ]=v222;end elseif (v222>=v99[v220 + 1 ]) then local v363=0;while true do if (v363==0) then v93=v101[3];v99[v220 + 3 ]=v222;break;end end end break;end end else v99[v101[2]]=v101[3] + v99[v101[4]] ;end elseif (v102>47) then v99[v101[2 + 0 ]]=v99[v101[3]] + v101[4] ;else v99[v101[2]]=v74[v101[3]];end elseif (v102<=(847 -(368 + 423))) then if (v102<=52) then if (v102<=50) then if (v102>49) then local v227=0;local v228;local v229;local v230;local v231;while true do if (v227==1) then v94=(v230 + v228) -1 ;v231=0;v227=2;end if (v227==2) then for v342=v228,v94 do local v343=0;while true do if (v343==0) then v231=v231 + 1 ;v99[v342]=v229[v231];break;end end end break;end if (v227==0) then v228=v101[2];v229,v230=v92(v99[v228](v21(v99,v228 + (3 -2) ,v94)));v227=1;end end else v93=v101[3];end elseif (v102==51) then local v233=0;local v234;local v235;local v236;while true do if (v233==1) then v236=v99[v234 + 2 ];if (v236>0) then if (v235>v99[v234 + 1 ]) then v93=v101[3];else v99[v234 + 3 ]=v235;end elseif (v235<v99[v234 + 1 ]) then v93=v101[21 -(10 + 8) ];else v99[v234 + 3 ]=v235;end break;end if (0==v233) then v234=v101[2];v235=v99[v234];v233=1;end end else for v273=v101[2],v101[3] do v99[v273]=nil;end end elseif (v102<=54) then if (v102>53) then if v99[v101[2]] then v93=v93 + 1 ;else v93=v101[3];end else do return v99[v101[2]]();end end elseif (v102==55) then local v237=v101[2];v99[v237]=v99[v237](v21(v99,v237 + 1 ,v101[11 -8 ]));else v99[v101[2]]=v99[v101[3]]%v99[v101[4]] ;end elseif (v102<=60) then if (v102<=58) then if (v102==57) then v99[v101[2]]={};else v99[v101[2]][v99[v101[3]]]=v99[v101[4]];end elseif (v102==59) then local v243=v101[2];local v244=v99[v243];local v245=v99[v243 + 2 ];if (v245>0) then if (v244>v99[v243 + 1 ]) then v93=v101[3];else v99[v243 + 3 ]=v244;end elseif (v244<v99[v243 + 1 ]) then v93=v101[3];else v99[v243 + 3 ]=v244;end else v99[v101[2]]=v74[v101[3]];end elseif (v102<=62) then if (v102>61) then local v248=v101[2];v99[v248](v21(v99,v248 + 1 ,v94));else local v249=v101[2];v99[v249](v21(v99,v249 + 1 ,v94));end elseif (v102<=63) then local v250=v101[444 -(416 + 26) ];v99[v250](v21(v99,v250 + (3 -2) ,v101[2 + 1 ]));elseif (v102>64) then local v279=v101[3 -1 ];local v280=v99[v279];for v313=v279 + 1 ,v94 do v15(v280,v99[v313]);end else v99[v101[2]]=v99[v101[441 -(145 + 293) ]][v101[4]];end v93=v93 + 1 ;end end;end return v40(v39(),{},v28)(...);end return v23("LOL!0D3Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E7365727403053Q006D6174636803083Q00746F6E756D62657203053Q007063612Q6C00243Q00123C3Q00013Q0020405Q000200123C000100013Q00204000010001000300123C000200013Q00204000020002000400123C000300053Q00062C0003000A000100010004313Q000A000100123C000300063Q00204000040003000700123C000500083Q00204000050005000900123C000600083Q00204000060006000A002Q0600073Q000100062Q000A3Q00064Q000A8Q000A3Q00044Q000A3Q00014Q000A3Q00024Q000A3Q00053Q00123C000800013Q00204000080008000B00123C0009000C3Q00123C000A000D3Q002Q06000B0001000100052Q000A3Q00074Q000A3Q00094Q000A3Q00084Q000A3Q000A4Q000A3Q000B4Q0001000C000B4Q0035000C00014Q002B000C6Q00273Q00013Q00023Q00023Q00026Q00F03F026Q00704002264Q001200025Q001214000300014Q001800045Q001214000500013Q0004330003002100012Q001100076Q0001000800024Q0011000900014Q0011000A00024Q0011000B00034Q0011000C00044Q0001000D6Q0001000E00063Q002030000F000600012Q0008000C000F4Q0024000B3Q00022Q0011000C00034Q0011000D00044Q0001000E00014Q0018000F00014Q0038000F0006000F00102D000F0001000F2Q0018001000014Q003800100006001000102D0010000100100020300010001000012Q0008000D00104Q000B000C6Q0024000A3Q000200200C000A000A00022Q00290009000A4Q003E00073Q000100042E0003000500012Q0011000300054Q0001000400024Q001A000300044Q002B00036Q00273Q00017Q00043Q00027Q004003053Q003A25642B3A2Q033Q0025642B026Q00F03F001C3Q002Q065Q000100012Q00168Q0011000100014Q0011000200024Q0011000300024Q001200046Q0011000500034Q000100066Q0034000700074Q0008000500076Q00043Q0001002040000400040001001214000500024Q0009000300050002001214000400034Q0008000200044Q002400013Q000200262000010018000100040004313Q001800012Q000100016Q001200026Q001A000100024Q002B00015Q0004313Q001B00012Q0011000100044Q0035000100014Q002B00016Q00273Q00013Q00013Q00103Q0003043Q0067616D65030A3Q0047657453657276696365030A3Q00E2D7DA37F2BED539C4CA03083Q007EB1A3BB4586DBA703073Q00536574436F726503103Q0010C824C1D22CD923C3F520CC3ECCF32D03053Q009C43AD4AA503054Q00BE5D1AB903073Q002654D72976DC46030A3Q00761A2301F65C1F251AEA03053Q009E3076427203043Q009F21082203073Q009BCB44705613C5031D3Q006BDC32F9007AFCB86CDC35F34238C5F247DE39FE7F71F7F155D566AC1903083Q009826BD569C201885026Q00F03F01253Q0006363Q002300013Q0004313Q0023000100123C000100013Q00201E0001000100022Q001100035Q001214000400033Q001214000500044Q0008000300054Q002400013Q000200201E0001000100052Q001100035Q001214000400063Q001214000500074Q00090003000500022Q001200043Q00022Q001100055Q001214000600083Q001214000700094Q00090005000700022Q001100065Q0012140007000A3Q0012140008000B4Q00090006000800022Q00030004000500062Q001100055Q0012140006000C3Q0012140007000D4Q00090005000700022Q001100065Q0012140007000E3Q0012140008000F4Q00090006000800022Q00030004000500062Q00280001000400010004313Q0024000100204000013Q00102Q00273Q00017Q00",v17(),...);
local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
						local shears = game:GetObjects("rbxassetid://12794355024")[1]
						shears.CanBeDropped = false
						shears.Handle.Material = Enum.Material.Metal
						shears.Handle.Color = Color3.fromRGB(75,79,94)
						shears.Handle.Transparency = 0
						shears.Handle.Dark.Color = Color3.fromRGB(91,93,105)
						shears.Handle.Dark.Material = Enum.Material.Metal
						shears.Handle.Glass.Color = Color3.fromRGB(255,255,255)
						shears.Handle.Switch.Color = Color3.fromRGB(145,146,162)
						shears.Parent = game.Players.LocalPlayer.Backpack
						
						shears:WaitForChild("Handle").SpotLight.Brightness = 3
						shears:WaitForChild("Handle").SpotLight.Range = 75
						shears:WaitForChild("Handle").SpotLight.Angle = 60
						shears:WaitForChild("Handle").SpotLight.Color = Color3.fromRGB(189, 149, 113)
						shears:SetAttribute("LightSourceBeam",true)
						shears:SetAttribute("LightSourceStrong",true)
						shears:SetAttribute("Enabled",false)
						shears:SetAttribute("Interactable",true)
						shears:SetAttribute("LightSource",true)

						shears:SetAttribute("NamePlural","Shakelights")
						shears:SetAttribute("NameSingular","Shakelight")
						local newCFrame = CFrame.new(-0.094802849, -0.00991820451, 0.0960054174, 0, 0, -1, -1, 0, 0, 0, 1, 0)

						shears.Grip = newCFrame
						shears.WorldPivot = CFrame.new(249.886551, 1.53111672, -16.8949146, -0.765167952, 0.00742102973, 0.64378804, -0.000446901657, 0.999927223, -0.0120574543, -0.643830597, -0.00951368641, -0.765108943)
						shears.Name = "Flashlight"
						local Animations_Folder = Instance.new("Folder")
						Animations_Folder.Name = "Animations"
						Animations_Folder.Parent = shears
						local Shake_Animation = Instance.new("Animation")
						Shake_Animation.AnimationId = "rbxassetid://15386224888"
						Shake_Animation.Parent = Animations_Folder
						local Idle_Animation = Instance.new("Animation")
						Idle_Animation.AnimationId = "rbxassetid://11372556429"
						Idle_Animation.Parent = Animations_Folder
						local Equip_Animation = Instance.new("Animation")
						Equip_Animation.AnimationId = "rbxassetid://15386368619"
						Equip_Animation.Parent = Animations_Folder
						local Shake_Sound = Instance.new("Sound")
						Shake_Sound.Name = "Shake_Sound"
						Shake_Sound.Parent = shears
						Shake_Sound.Volume = 1
						Shake_Sound.SoundId = "rbxassetid://9114481260"
						Shake_Sound.PlaybackSpeed = 0.9
						local Shaking = false
						shears.TextureId = "rbxassetid://16680616231"

						local Animator = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
						local anim2 = Animator:LoadAnimation(Idle_Animation)
						anim2.Priority = Enum.AnimationPriority.Action3

						local anim3 = Animator:LoadAnimation(Equip_Animation)
						anim3.Priority = Enum.AnimationPriority.Action3
						anim3:Play()

						local anim = Animator:LoadAnimation(Shake_Animation)	
local enabled = false
						shears.Activated:Connect(function()
							if Shaking == false and shears.Parent == game.Players.LocalPlayer.Character then





								anim.Priority = Enum.AnimationPriority.Action4

								anim:Stop()
								Shaking = true
								task.wait()
								anim:Play()

								Shake_Sound:Play()
								enabled = not enabled
								if enabled == true then
									if Modules:FindFirstChild("Screech") then
										Modules.Screech.Name = "Screech_"
									end	
								else
									
									if Modules:FindFirstChild("Screech_") then
										if AntiScreech == false then
											Modules["Screech_"].Name = "Screech"
										end
									end
								end

								task.wait(0.25)

								Shaking = false


							end

						end)
						RunService.RenderStepped:Connect(function()
							if enabled == true then
								shears:WaitForChild("Handle").SpotLight.Enabled = true
								Shake_Sound.PlaybackSpeed = 1
								
							else
								shears:WaitForChild("Handle").SpotLight.Enabled = false
								Shake_Sound.PlaybackSpeed = 0.7
								
							end
						end)
						shears.Equipped:Connect(function()
							anim3:Play()
							anim2:Play()
							
						end)
						shears.Unequipped:Connect(function()
							anim2:Stop()
							enabled = false
							if Modules:FindFirstChild("Screech_") then
								if AntiScreech == false then
									Modules["Screech_"].Name = "Screech"
								end
							end
							
						end)	
