library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"c0c478a1",
     1 => x"db03a9b7",
     2 => x"48d4ff87",
     3 => x"bfc8dec3",
     4 => x"c4dec378",
     5 => x"dec349bf",
     6 => x"a1c148c4",
     7 => x"b7c0c478",
     8 => x"87e504a9",
     9 => x"c848d0ff",
    10 => x"d0dec378",
    11 => x"2678c048",
    12 => x"0000004f",
    13 => x"00000000",
    14 => x"00000000",
    15 => x"00005f5f",
    16 => x"03030000",
    17 => x"00030300",
    18 => x"7f7f1400",
    19 => x"147f7f14",
    20 => x"2e240000",
    21 => x"123a6b6b",
    22 => x"366a4c00",
    23 => x"32566c18",
    24 => x"4f7e3000",
    25 => x"683a7759",
    26 => x"04000040",
    27 => x"00000307",
    28 => x"1c000000",
    29 => x"0041633e",
    30 => x"41000000",
    31 => x"001c3e63",
    32 => x"3e2a0800",
    33 => x"2a3e1c1c",
    34 => x"08080008",
    35 => x"08083e3e",
    36 => x"80000000",
    37 => x"000060e0",
    38 => x"08080000",
    39 => x"08080808",
    40 => x"00000000",
    41 => x"00006060",
    42 => x"30604000",
    43 => x"03060c18",
    44 => x"7f3e0001",
    45 => x"3e7f4d59",
    46 => x"06040000",
    47 => x"00007f7f",
    48 => x"63420000",
    49 => x"464f5971",
    50 => x"63220000",
    51 => x"367f4949",
    52 => x"161c1800",
    53 => x"107f7f13",
    54 => x"67270000",
    55 => x"397d4545",
    56 => x"7e3c0000",
    57 => x"3079494b",
    58 => x"01010000",
    59 => x"070f7971",
    60 => x"7f360000",
    61 => x"367f4949",
    62 => x"4f060000",
    63 => x"1e3f6949",
    64 => x"00000000",
    65 => x"00006666",
    66 => x"80000000",
    67 => x"000066e6",
    68 => x"08080000",
    69 => x"22221414",
    70 => x"14140000",
    71 => x"14141414",
    72 => x"22220000",
    73 => x"08081414",
    74 => x"03020000",
    75 => x"060f5951",
    76 => x"417f3e00",
    77 => x"1e1f555d",
    78 => x"7f7e0000",
    79 => x"7e7f0909",
    80 => x"7f7f0000",
    81 => x"367f4949",
    82 => x"3e1c0000",
    83 => x"41414163",
    84 => x"7f7f0000",
    85 => x"1c3e6341",
    86 => x"7f7f0000",
    87 => x"41414949",
    88 => x"7f7f0000",
    89 => x"01010909",
    90 => x"7f3e0000",
    91 => x"7a7b4941",
    92 => x"7f7f0000",
    93 => x"7f7f0808",
    94 => x"41000000",
    95 => x"00417f7f",
    96 => x"60200000",
    97 => x"3f7f4040",
    98 => x"087f7f00",
    99 => x"4163361c",
   100 => x"7f7f0000",
   101 => x"40404040",
   102 => x"067f7f00",
   103 => x"7f7f060c",
   104 => x"067f7f00",
   105 => x"7f7f180c",
   106 => x"7f3e0000",
   107 => x"3e7f4141",
   108 => x"7f7f0000",
   109 => x"060f0909",
   110 => x"417f3e00",
   111 => x"407e7f61",
   112 => x"7f7f0000",
   113 => x"667f1909",
   114 => x"6f260000",
   115 => x"327b594d",
   116 => x"01010000",
   117 => x"01017f7f",
   118 => x"7f3f0000",
   119 => x"3f7f4040",
   120 => x"3f0f0000",
   121 => x"0f3f7070",
   122 => x"307f7f00",
   123 => x"7f7f3018",
   124 => x"36634100",
   125 => x"63361c1c",
   126 => x"06030141",
   127 => x"03067c7c",
   128 => x"59716101",
   129 => x"4143474d",
   130 => x"7f000000",
   131 => x"0041417f",
   132 => x"06030100",
   133 => x"6030180c",
   134 => x"41000040",
   135 => x"007f7f41",
   136 => x"060c0800",
   137 => x"080c0603",
   138 => x"80808000",
   139 => x"80808080",
   140 => x"00000000",
   141 => x"00040703",
   142 => x"74200000",
   143 => x"787c5454",
   144 => x"7f7f0000",
   145 => x"387c4444",
   146 => x"7c380000",
   147 => x"00444444",
   148 => x"7c380000",
   149 => x"7f7f4444",
   150 => x"7c380000",
   151 => x"185c5454",
   152 => x"7e040000",
   153 => x"0005057f",
   154 => x"bc180000",
   155 => x"7cfca4a4",
   156 => x"7f7f0000",
   157 => x"787c0404",
   158 => x"00000000",
   159 => x"00407d3d",
   160 => x"80800000",
   161 => x"007dfd80",
   162 => x"7f7f0000",
   163 => x"446c3810",
   164 => x"00000000",
   165 => x"00407f3f",
   166 => x"0c7c7c00",
   167 => x"787c0c18",
   168 => x"7c7c0000",
   169 => x"787c0404",
   170 => x"7c380000",
   171 => x"387c4444",
   172 => x"fcfc0000",
   173 => x"183c2424",
   174 => x"3c180000",
   175 => x"fcfc2424",
   176 => x"7c7c0000",
   177 => x"080c0404",
   178 => x"5c480000",
   179 => x"20745454",
   180 => x"3f040000",
   181 => x"0044447f",
   182 => x"7c3c0000",
   183 => x"7c7c4040",
   184 => x"3c1c0000",
   185 => x"1c3c6060",
   186 => x"607c3c00",
   187 => x"3c7c6030",
   188 => x"386c4400",
   189 => x"446c3810",
   190 => x"bc1c0000",
   191 => x"1c3c60e0",
   192 => x"64440000",
   193 => x"444c5c74",
   194 => x"08080000",
   195 => x"4141773e",
   196 => x"00000000",
   197 => x"00007f7f",
   198 => x"41410000",
   199 => x"08083e77",
   200 => x"01010200",
   201 => x"01020203",
   202 => x"7f7f7f00",
   203 => x"7f7f7f7f",
   204 => x"1c080800",
   205 => x"7f3e3e1c",
   206 => x"3e7f7f7f",
   207 => x"081c1c3e",
   208 => x"18100008",
   209 => x"10187c7c",
   210 => x"30100000",
   211 => x"10307c7c",
   212 => x"60301000",
   213 => x"061e7860",
   214 => x"3c664200",
   215 => x"42663c18",
   216 => x"6a387800",
   217 => x"386cc6c2",
   218 => x"00006000",
   219 => x"60000060",
   220 => x"5b5e0e00",
   221 => x"1e0e5d5c",
   222 => x"dec34c71",
   223 => x"c04dbfe1",
   224 => x"741ec04b",
   225 => x"87c702ab",
   226 => x"c048a6c4",
   227 => x"c487c578",
   228 => x"78c148a6",
   229 => x"731e66c4",
   230 => x"87dfee49",
   231 => x"e0c086c8",
   232 => x"87efef49",
   233 => x"6a4aa5c4",
   234 => x"87f0f049",
   235 => x"cb87c6f1",
   236 => x"c883c185",
   237 => x"ff04abb7",
   238 => x"262687c7",
   239 => x"264c264d",
   240 => x"1e4f264b",
   241 => x"dec34a71",
   242 => x"dec35ae5",
   243 => x"78c748e5",
   244 => x"87ddfe49",
   245 => x"731e4f26",
   246 => x"c04a711e",
   247 => x"d303aab7",
   248 => x"f7ddc287",
   249 => x"87c405bf",
   250 => x"87c24bc1",
   251 => x"ddc24bc0",
   252 => x"87c45bfb",
   253 => x"5afbddc2",
   254 => x"bff7ddc2",
   255 => x"c19ac14a",
   256 => x"ec49a2c0",
   257 => x"48fc87e8",
   258 => x"bff7ddc2",
   259 => x"87effe78",
   260 => x"c44a711e",
   261 => x"49721e66",
   262 => x"2687e2e6",
   263 => x"c21e4f26",
   264 => x"49bff7dd",
   265 => x"c387d3e3",
   266 => x"e848d9de",
   267 => x"dec378bf",
   268 => x"bfec48d5",
   269 => x"d9dec378",
   270 => x"c3494abf",
   271 => x"b7c899ff",
   272 => x"7148722a",
   273 => x"e1dec3b0",
   274 => x"0e4f2658",
   275 => x"5d5c5b5e",
   276 => x"ff4b710e",
   277 => x"dec387c8",
   278 => x"50c048d4",
   279 => x"f9e24973",
   280 => x"4c497087",
   281 => x"eecb9cc2",
   282 => x"87d3cc49",
   283 => x"c34d4970",
   284 => x"bf97d4de",
   285 => x"87e2c105",
   286 => x"c34966d0",
   287 => x"99bfddde",
   288 => x"d487d605",
   289 => x"dec34966",
   290 => x"0599bfd5",
   291 => x"497387cb",
   292 => x"7087c7e2",
   293 => x"c1c10298",
   294 => x"fe4cc187",
   295 => x"497587c0",
   296 => x"7087e8cb",
   297 => x"87c60298",
   298 => x"48d4dec3",
   299 => x"dec350c1",
   300 => x"05bf97d4",
   301 => x"c387e3c0",
   302 => x"49bfddde",
   303 => x"059966d0",
   304 => x"c387d6ff",
   305 => x"49bfd5de",
   306 => x"059966d4",
   307 => x"7387caff",
   308 => x"87c6e149",
   309 => x"fe059870",
   310 => x"487487ff",
   311 => x"0e87dcfb",
   312 => x"5d5c5b5e",
   313 => x"c086f40e",
   314 => x"bfec4c4d",
   315 => x"48a6c47e",
   316 => x"bfe1dec3",
   317 => x"c01ec178",
   318 => x"fd49c71e",
   319 => x"86c887cd",
   320 => x"cd029870",
   321 => x"fb49ff87",
   322 => x"dac187cc",
   323 => x"87cae049",
   324 => x"dec34dc1",
   325 => x"02bf97d4",
   326 => x"f3c087c4",
   327 => x"dec387cc",
   328 => x"c24bbfd9",
   329 => x"05bff7dd",
   330 => x"c487dcc1",
   331 => x"c0c848a6",
   332 => x"ddc278c0",
   333 => x"976e7ee3",
   334 => x"486e49bf",
   335 => x"7e7080c1",
   336 => x"d5dfff71",
   337 => x"02987087",
   338 => x"66c487c3",
   339 => x"4866c4b3",
   340 => x"c828b7c1",
   341 => x"987058a6",
   342 => x"87daff05",
   343 => x"ff49fdc3",
   344 => x"c387f7de",
   345 => x"deff49fa",
   346 => x"497387f0",
   347 => x"7199ffc3",
   348 => x"fa49c01e",
   349 => x"497387da",
   350 => x"7129b7c8",
   351 => x"fa49c11e",
   352 => x"86c887ce",
   353 => x"c387c5c6",
   354 => x"4bbfddde",
   355 => x"87dd029b",
   356 => x"bff3ddc2",
   357 => x"87f3c749",
   358 => x"c4059870",
   359 => x"d24bc087",
   360 => x"49e0c287",
   361 => x"c287d8c7",
   362 => x"c658f7dd",
   363 => x"f3ddc287",
   364 => x"7378c048",
   365 => x"0599c249",
   366 => x"ebc387cf",
   367 => x"d9ddff49",
   368 => x"c2497087",
   369 => x"c2c00299",
   370 => x"734cfb87",
   371 => x"0599c149",
   372 => x"f4c387cf",
   373 => x"c1ddff49",
   374 => x"c2497087",
   375 => x"c2c00299",
   376 => x"734cfa87",
   377 => x"0599c849",
   378 => x"f5c387ce",
   379 => x"e9dcff49",
   380 => x"c2497087",
   381 => x"87d60299",
   382 => x"bfe5dec3",
   383 => x"87cac002",
   384 => x"c388c148",
   385 => x"c058e9de",
   386 => x"4cff87c2",
   387 => x"49734dc1",
   388 => x"c00599c4",
   389 => x"f2c387ce",
   390 => x"fddbff49",
   391 => x"c2497087",
   392 => x"87dc0299",
   393 => x"bfe5dec3",
   394 => x"b7c7487e",
   395 => x"cbc003a8",
   396 => x"c1486e87",
   397 => x"e9dec380",
   398 => x"87c2c058",
   399 => x"4dc14cfe",
   400 => x"ff49fdc3",
   401 => x"7087d3db",
   402 => x"0299c249",
   403 => x"c387d5c0",
   404 => x"02bfe5de",
   405 => x"c387c9c0",
   406 => x"c048e5de",
   407 => x"87c2c078",
   408 => x"4dc14cfd",
   409 => x"ff49fac3",
   410 => x"7087efda",
   411 => x"0299c249",
   412 => x"c387d9c0",
   413 => x"48bfe5de",
   414 => x"03a8b7c7",
   415 => x"c387c9c0",
   416 => x"c748e5de",
   417 => x"87c2c078",
   418 => x"4dc14cfc",
   419 => x"03acb7c0",
   420 => x"c487d1c0",
   421 => x"d8c14a66",
   422 => x"c0026a82",
   423 => x"4b6a87c6",
   424 => x"0f734974",
   425 => x"f0c31ec0",
   426 => x"49dac11e",
   427 => x"c887dcf6",
   428 => x"02987086",
   429 => x"c887e2c0",
   430 => x"dec348a6",
   431 => x"c878bfe5",
   432 => x"91cb4966",
   433 => x"714866c4",
   434 => x"6e7e7080",
   435 => x"c8c002bf",
   436 => x"4bbf6e87",
   437 => x"734966c8",
   438 => x"029d750f",
   439 => x"c387c8c0",
   440 => x"49bfe5de",
   441 => x"c287caf2",
   442 => x"02bffbdd",
   443 => x"4987ddc0",
   444 => x"7087d8c2",
   445 => x"d3c00298",
   446 => x"e5dec387",
   447 => x"f0f149bf",
   448 => x"f349c087",
   449 => x"ddc287d0",
   450 => x"78c048fb",
   451 => x"eaf28ef4",
   452 => x"5b5e0e87",
   453 => x"1e0e5d5c",
   454 => x"dec34c71",
   455 => x"c149bfe1",
   456 => x"c14da1cd",
   457 => x"7e6981d1",
   458 => x"cf029c74",
   459 => x"4ba5c487",
   460 => x"dec37b74",
   461 => x"f249bfe1",
   462 => x"7b6e87c9",
   463 => x"c4059c74",
   464 => x"c24bc087",
   465 => x"734bc187",
   466 => x"87caf249",
   467 => x"c80266d4",
   468 => x"eac04987",
   469 => x"c24a7087",
   470 => x"c24ac087",
   471 => x"265affdd",
   472 => x"5887d8f1",
   473 => x"1d141112",
   474 => x"5a231c1b",
   475 => x"f5949159",
   476 => x"00f4ebf2",
   477 => x"00000000",
   478 => x"00000000",
   479 => x"1e000000",
   480 => x"c8ff4a71",
   481 => x"a17249bf",
   482 => x"1e4f2648",
   483 => x"89bfc8ff",
   484 => x"c0c0c0fe",
   485 => x"01a9c0c0",
   486 => x"4ac087c4",
   487 => x"4ac187c2",
   488 => x"4f264872",
   489 => x"4ad4ff1e",
   490 => x"c848d0ff",
   491 => x"f0c378c5",
   492 => x"c07a717a",
   493 => x"7a7a7a7a",
   494 => x"4f2678c4",
   495 => x"4ad4ff1e",
   496 => x"c848d0ff",
   497 => x"7ac078c5",
   498 => x"7ac0496a",
   499 => x"7a7a7a7a",
   500 => x"487178c4",
   501 => x"731e4f26",
   502 => x"c84b711e",
   503 => x"87db0266",
   504 => x"c14a6b97",
   505 => x"699749a3",
   506 => x"51727b97",
   507 => x"c24866c8",
   508 => x"58a6cc88",
   509 => x"987083c2",
   510 => x"c487e505",
   511 => x"264d2687",
   512 => x"264b264c",
   513 => x"5b5e0e4f",
   514 => x"e80e5d5c",
   515 => x"59a6cc86",
   516 => x"4d66e8c0",
   517 => x"c395e8c2",
   518 => x"c285e9de",
   519 => x"c47ea5d8",
   520 => x"dcc248a6",
   521 => x"66c478a5",
   522 => x"bf6e4cbf",
   523 => x"85e0c294",
   524 => x"66c8946d",
   525 => x"c84ac04b",
   526 => x"e1fd49c0",
   527 => x"66c887fa",
   528 => x"9fc0c148",
   529 => x"4966c878",
   530 => x"bf6e81c2",
   531 => x"66c8799f",
   532 => x"c481c649",
   533 => x"799fbf66",
   534 => x"cc4966c8",
   535 => x"799f6d81",
   536 => x"d44866c8",
   537 => x"58a6d080",
   538 => x"48f1e4c2",
   539 => x"d44966cc",
   540 => x"41204aa1",
   541 => x"f905aa71",
   542 => x"4866c887",
   543 => x"d480eec0",
   544 => x"e5c258a6",
   545 => x"66d048c6",
   546 => x"4aa1c849",
   547 => x"aa714120",
   548 => x"c887f905",
   549 => x"f6c04866",
   550 => x"58a6d880",
   551 => x"48cfe5c2",
   552 => x"c04966d4",
   553 => x"204aa1e8",
   554 => x"05aa7141",
   555 => x"e8c087f9",
   556 => x"4966d81e",
   557 => x"cc87dffc",
   558 => x"dec14966",
   559 => x"d0c0c881",
   560 => x"66cc799f",
   561 => x"81e2c149",
   562 => x"799fc0c8",
   563 => x"c14966cc",
   564 => x"9fc181ea",
   565 => x"4966cc79",
   566 => x"c481ecc1",
   567 => x"799fbf66",
   568 => x"c14966cc",
   569 => x"66c881ee",
   570 => x"cc799fbf",
   571 => x"f0c14966",
   572 => x"799f6d81",
   573 => x"ffcf4b74",
   574 => x"4a739bff",
   575 => x"c14966cc",
   576 => x"9f7281f2",
   577 => x"d04a7479",
   578 => x"ffffcf2a",
   579 => x"cc4c729a",
   580 => x"f4c14966",
   581 => x"799f7481",
   582 => x"4966cc73",
   583 => x"7381f8c1",
   584 => x"cc72799f",
   585 => x"fac14966",
   586 => x"799f7281",
   587 => x"ccfb8ee4",
   588 => x"544d6987",
   589 => x"694d6953",
   590 => x"484d696e",
   591 => x"66617267",
   592 => x"20696c64",
   593 => x"312e0065",
   594 => x"20203030",
   595 => x"59002020",
   596 => x"42555141",
   597 => x"20202045",
   598 => x"20202020",
   599 => x"20202020",
   600 => x"20202020",
   601 => x"20202020",
   602 => x"20202020",
   603 => x"20202020",
   604 => x"20202020",
   605 => x"00202020",
   606 => x"711e731e",
   607 => x"0266d44b",
   608 => x"66c887d4",
   609 => x"7331d849",
   610 => x"7232c84a",
   611 => x"66cc49a1",
   612 => x"c0487181",
   613 => x"66d087e3",
   614 => x"91e8c249",
   615 => x"81e9dec3",
   616 => x"4aa1dcc2",
   617 => x"92734a6a",
   618 => x"c28266c8",
   619 => x"496981e0",
   620 => x"66cc9172",
   621 => x"7189c181",
   622 => x"87c5f948",
   623 => x"ff4a711e",
   624 => x"d0ff49d4",
   625 => x"78c5c848",
   626 => x"c079d0c2",
   627 => x"79797979",
   628 => x"79797979",
   629 => x"79c07972",
   630 => x"c07966c4",
   631 => x"7966c879",
   632 => x"66cc79c0",
   633 => x"d079c079",
   634 => x"79c07966",
   635 => x"c47966d4",
   636 => x"1e4f2678",
   637 => x"a2c64a71",
   638 => x"49699749",
   639 => x"7199f0c3",
   640 => x"1e1ec01e",
   641 => x"1ec01ec1",
   642 => x"87f0fe49",
   643 => x"f649d0c2",
   644 => x"8eec87d2",
   645 => x"c01e4f26",
   646 => x"1e1e1e1e",
   647 => x"fe49c11e",
   648 => x"d0c287da",
   649 => x"87fcf549",
   650 => x"4f268eec",
   651 => x"ff4a711e",
   652 => x"c5c848d0",
   653 => x"48d4ff78",
   654 => x"c078e0c2",
   655 => x"78787878",
   656 => x"1ec0c878",
   657 => x"dbfd4972",
   658 => x"d0ff87e0",
   659 => x"2678c448",
   660 => x"5e0e4f26",
   661 => x"0e5d5c5b",
   662 => x"4a7186f8",
   663 => x"c14ba2c2",
   664 => x"a2c37b97",
   665 => x"7c97c14c",
   666 => x"51c049a2",
   667 => x"c04da2c4",
   668 => x"a2c57d97",
   669 => x"c0486e7e",
   670 => x"48a6c450",
   671 => x"c478a2c6",
   672 => x"50c04866",
   673 => x"c31e66d8",
   674 => x"f549feca",
   675 => x"66c887f7",
   676 => x"1e49bf97",
   677 => x"bf9766c8",
   678 => x"49151e49",
   679 => x"1e49141e",
   680 => x"c01e4913",
   681 => x"87d4fc49",
   682 => x"f7f349c8",
   683 => x"fecac387",
   684 => x"87f8fd49",
   685 => x"f349d0c2",
   686 => x"8ee087ea",
   687 => x"1e87fef4",
   688 => x"a2c64a71",
   689 => x"49699749",
   690 => x"49a2c51e",
   691 => x"1e496997",
   692 => x"9749a2c4",
   693 => x"c31e4969",
   694 => x"699749a2",
   695 => x"a2c21e49",
   696 => x"49699749",
   697 => x"fb49c01e",
   698 => x"d0c287d2",
   699 => x"87f4f249",
   700 => x"4f268eec",
   701 => x"711e731e",
   702 => x"4aa3c24b",
   703 => x"c24966c8",
   704 => x"dec391e8",
   705 => x"e4c281e9",
   706 => x"c2791281",
   707 => x"d3f249d0",
   708 => x"87edf387",
   709 => x"711e731e",
   710 => x"49a3c64b",
   711 => x"1e496997",
   712 => x"9749a3c5",
   713 => x"c41e4969",
   714 => x"699749a3",
   715 => x"a3c31e49",
   716 => x"49699749",
   717 => x"49a3c21e",
   718 => x"1e496997",
   719 => x"124aa3c1",
   720 => x"87f8f949",
   721 => x"f149d0c2",
   722 => x"8eec87da",
   723 => x"0e87f2f2",
   724 => x"5d5c5b5e",
   725 => x"7e711e0e",
   726 => x"81c2496e",
   727 => x"6e7997c1",
   728 => x"c183c34b",
   729 => x"4a6e7b97",
   730 => x"97c082c1",
   731 => x"c44c6e7a",
   732 => x"7c97c084",
   733 => x"85c54d6e",
   734 => x"4d6e55c0",
   735 => x"6d9785c6",
   736 => x"1ec01e4d",
   737 => x"1e4c6c97",
   738 => x"1e4b6b97",
   739 => x"1e496997",
   740 => x"e7f84912",
   741 => x"49d0c287",
   742 => x"e887c9f0",
   743 => x"87ddf18e",
   744 => x"5c5b5e0e",
   745 => x"dcff0e5d",
   746 => x"c34b7186",
   747 => x"4c1149a3",
   748 => x"c54aa3c4",
   749 => x"699749a3",
   750 => x"9731c849",
   751 => x"71484a6a",
   752 => x"58a6d8b0",
   753 => x"6e7ea3c6",
   754 => x"4d49bf97",
   755 => x"48719dcf",
   756 => x"dc98c0c1",
   757 => x"ec4858a6",
   758 => x"78a3c280",
   759 => x"bf9766c4",
   760 => x"58a6d448",
   761 => x"c01e66d8",
   762 => x"741e66f8",
   763 => x"c01e751e",
   764 => x"f64966e4",
   765 => x"86d087c2",
   766 => x"e0c04970",
   767 => x"66d059a6",
   768 => x"87e5c502",
   769 => x"0266f8c0",
   770 => x"a6cc87c8",
   771 => x"7866d048",
   772 => x"a6cc87c5",
   773 => x"cc78c148",
   774 => x"f8c04b66",
   775 => x"87de0266",
   776 => x"4966f4c0",
   777 => x"c391e8c2",
   778 => x"c281e9de",
   779 => x"a6c881e4",
   780 => x"cc786948",
   781 => x"66c84866",
   782 => x"c106a8b7",
   783 => x"49c84b87",
   784 => x"ed87e1ed",
   785 => x"497087f6",
   786 => x"ca0599c4",
   787 => x"87eced87",
   788 => x"99c44970",
   789 => x"7387f602",
   790 => x"d088c148",
   791 => x"4a7058a6",
   792 => x"c1029b73",
   793 => x"66d087d2",
   794 => x"02a8c148",
   795 => x"c087f7c0",
   796 => x"c24966f4",
   797 => x"dec391e8",
   798 => x"807148e9",
   799 => x"c858a6cc",
   800 => x"e0c24966",
   801 => x"05ac6981",
   802 => x"4cc187da",
   803 => x"4966c885",
   804 => x"6981dcc2",
   805 => x"87ce05ad",
   806 => x"66d44dc0",
   807 => x"d880c148",
   808 => x"87c258a6",
   809 => x"66d084c1",
   810 => x"d488c148",
   811 => x"497258a6",
   812 => x"99718ac1",
   813 => x"87eefe05",
   814 => x"d90266d8",
   815 => x"dc497387",
   816 => x"4a718166",
   817 => x"729affc3",
   818 => x"c84a714c",
   819 => x"a6d82ab7",
   820 => x"29b7d85a",
   821 => x"976e4d71",
   822 => x"f0c349bf",
   823 => x"71b17599",
   824 => x"4966d81e",
   825 => x"7129b7c8",
   826 => x"1e66dc1e",
   827 => x"66d41e74",
   828 => x"1e49bf97",
   829 => x"c3f349c0",
   830 => x"d086d487",
   831 => x"87e4ea49",
   832 => x"4966f4c0",
   833 => x"c391e8c2",
   834 => x"7148e9de",
   835 => x"58a6cc80",
   836 => x"c84966c8",
   837 => x"c1026981",
   838 => x"66dc87c4",
   839 => x"7131c949",
   840 => x"4966cc1e",
   841 => x"87c3f8fd",
   842 => x"e0c086c4",
   843 => x"66cc48a6",
   844 => x"029b7378",
   845 => x"c087ecc0",
   846 => x"4966cc1e",
   847 => x"87d1f2fd",
   848 => x"66d01ec1",
   849 => x"eef0fd49",
   850 => x"c086c887",
   851 => x"484966e0",
   852 => x"e4c088c1",
   853 => x"997158a6",
   854 => x"87dbff05",
   855 => x"49c987c5",
   856 => x"d087c1e9",
   857 => x"dbfa0566",
   858 => x"49c0c287",
   859 => x"ff87f5e8",
   860 => x"c8ea8edc",
   861 => x"5b5e0e87",
   862 => x"e00e5d5c",
   863 => x"c34c7186",
   864 => x"481149a4",
   865 => x"c458a6d4",
   866 => x"a4c54aa4",
   867 => x"49699749",
   868 => x"6a9731c8",
   869 => x"b071484a",
   870 => x"c658a6d8",
   871 => x"976e7ea4",
   872 => x"cf4d49bf",
   873 => x"c148719d",
   874 => x"a6dc98c0",
   875 => x"80ec4858",
   876 => x"c478a4c2",
   877 => x"4bbf9766",
   878 => x"c01e66d8",
   879 => x"d81e66f4",
   880 => x"1e751e66",
   881 => x"4966e4c0",
   882 => x"d087edee",
   883 => x"c0497086",
   884 => x"7359a6e0",
   885 => x"87c3059b",
   886 => x"c44bc0c4",
   887 => x"87c4e749",
   888 => x"c94966dc",
   889 => x"c01e7131",
   890 => x"c24966f4",
   891 => x"dec391e8",
   892 => x"807148e9",
   893 => x"d058a6d4",
   894 => x"f4fd4966",
   895 => x"86c487ed",
   896 => x"c4029b73",
   897 => x"f4c087df",
   898 => x"87c40266",
   899 => x"87c24a73",
   900 => x"4c724ac1",
   901 => x"0266f4c0",
   902 => x"66cc87d3",
   903 => x"81e4c249",
   904 => x"6948a6c8",
   905 => x"b766c878",
   906 => x"87c106aa",
   907 => x"029c744c",
   908 => x"e687d5c2",
   909 => x"497087c6",
   910 => x"ca0599c8",
   911 => x"87fce587",
   912 => x"99c84970",
   913 => x"ff87f602",
   914 => x"c5c848d0",
   915 => x"48d4ff78",
   916 => x"c078f0c2",
   917 => x"78787878",
   918 => x"1ec0c878",
   919 => x"49fecac3",
   920 => x"87edcbfd",
   921 => x"c448d0ff",
   922 => x"fecac378",
   923 => x"4966d41e",
   924 => x"87eceefd",
   925 => x"66d81ec1",
   926 => x"faebfd49",
   927 => x"dc86cc87",
   928 => x"80c14866",
   929 => x"58a6e0c0",
   930 => x"c002abc1",
   931 => x"66cc87f3",
   932 => x"81e0c249",
   933 => x"694866d0",
   934 => x"87dd05a8",
   935 => x"c148a6d0",
   936 => x"66cc8578",
   937 => x"81dcc249",
   938 => x"d405ad69",
   939 => x"d44dc087",
   940 => x"80c14866",
   941 => x"c858a6d8",
   942 => x"4866d087",
   943 => x"a6d480c1",
   944 => x"8c8bc158",
   945 => x"87ebfd05",
   946 => x"da0266d8",
   947 => x"4966dc87",
   948 => x"d499ffc3",
   949 => x"66dc59a6",
   950 => x"29b7c849",
   951 => x"dc59a6d8",
   952 => x"b7d84966",
   953 => x"6e4d7129",
   954 => x"c349bf97",
   955 => x"b17599f0",
   956 => x"66d81e71",
   957 => x"29b7c849",
   958 => x"66dc1e71",
   959 => x"1e66dc1e",
   960 => x"bf9766d4",
   961 => x"49c01e49",
   962 => x"d487f1ea",
   963 => x"029b7386",
   964 => x"49d087c7",
   965 => x"c687cde2",
   966 => x"49d0c287",
   967 => x"7387c5e2",
   968 => x"e1fb059b",
   969 => x"e38ee087",
   970 => x"5e0e87d3",
   971 => x"0e5d5c5b",
   972 => x"4c7186f8",
   973 => x"6949a4c8",
   974 => x"7129c949",
   975 => x"c3029a4a",
   976 => x"1e7287e0",
   977 => x"4ad14972",
   978 => x"87edc6fd",
   979 => x"99714a26",
   980 => x"87cdc205",
   981 => x"c0c0c4c1",
   982 => x"c201aab7",
   983 => x"a6c487c3",
   984 => x"cc78d148",
   985 => x"aab7c0f0",
   986 => x"c487c501",
   987 => x"87cfc14d",
   988 => x"49721e72",
   989 => x"c5fd4ac6",
   990 => x"4a2687ff",
   991 => x"cd059971",
   992 => x"c0e0d987",
   993 => x"c501aab7",
   994 => x"c04dc687",
   995 => x"4bc587f1",
   996 => x"49721e72",
   997 => x"c5fd4a73",
   998 => x"4a2687df",
   999 => x"cc059971",
  1000 => x"c4497387",
  1001 => x"7191c0d0",
  1002 => x"d006aab7",
  1003 => x"05abc587",
  1004 => x"83c187c2",
  1005 => x"b7d083c1",
  1006 => x"d3ff04ab",
  1007 => x"724d7387",
  1008 => x"7549721e",
  1009 => x"f0c4fd4a",
  1010 => x"26497087",
  1011 => x"721e714a",
  1012 => x"fd4ad11e",
  1013 => x"2687e2c4",
  1014 => x"c449264a",
  1015 => x"e8c058a6",
  1016 => x"48a6c487",
  1017 => x"d078ffc0",
  1018 => x"721e724d",
  1019 => x"fd4ad049",
  1020 => x"7087c6c4",
  1021 => x"714a2649",
  1022 => x"c01e721e",
  1023 => x"c3fd4aff",
  1024 => x"4a2687f7",
  1025 => x"a6c44926",
  1026 => x"a4d8c258",
  1027 => x"c2796e49",
  1028 => x"7549a4dc",
  1029 => x"a4e0c279",
  1030 => x"7966c449",
  1031 => x"49a4e4c2",
  1032 => x"8ef879c1",
  1033 => x"87d5dfff",
  1034 => x"c349c01e",
  1035 => x"02bff1de",
  1036 => x"49c187c2",
  1037 => x"bfd9e1c3",
  1038 => x"c287c202",
  1039 => x"48d0ffb1",
  1040 => x"ff78c5c8",
  1041 => x"fac348d4",
  1042 => x"ff787178",
  1043 => x"78c448d0",
  1044 => x"731e4f26",
  1045 => x"1e4a711e",
  1046 => x"c24966cc",
  1047 => x"dec391e8",
  1048 => x"83714be9",
  1049 => x"e0fd4973",
  1050 => x"86c487c9",
  1051 => x"c5029870",
  1052 => x"fa497387",
  1053 => x"effe87f4",
  1054 => x"c4deff87",
  1055 => x"5b5e0e87",
  1056 => x"f40e5d5c",
  1057 => x"f3dcff86",
  1058 => x"c4497087",
  1059 => x"d3c50299",
  1060 => x"48d0ff87",
  1061 => x"ff78c5c8",
  1062 => x"c0c248d4",
  1063 => x"7878c078",
  1064 => x"4d787878",
  1065 => x"c048d4ff",
  1066 => x"a54a7678",
  1067 => x"bfd4ff49",
  1068 => x"d4ff7997",
  1069 => x"6878c048",
  1070 => x"c885c151",
  1071 => x"e304adb7",
  1072 => x"48d0ff87",
  1073 => x"97c678c4",
  1074 => x"a6cc4866",
  1075 => x"d04c7058",
  1076 => x"2cb7c49c",
  1077 => x"e8c24974",
  1078 => x"e9dec391",
  1079 => x"6981c881",
  1080 => x"c287ca05",
  1081 => x"daff49d1",
  1082 => x"f7c387fa",
  1083 => x"6697c787",
  1084 => x"f0c3494b",
  1085 => x"05a9d099",
  1086 => x"1e7487cc",
  1087 => x"f2e34972",
  1088 => x"c386c487",
  1089 => x"d0c287de",
  1090 => x"87c805ab",
  1091 => x"c5e44972",
  1092 => x"87d0c387",
  1093 => x"05abecc3",
  1094 => x"1ec087ce",
  1095 => x"49721e74",
  1096 => x"c887efe4",
  1097 => x"87fcc286",
  1098 => x"05abd1c2",
  1099 => x"1e7487cc",
  1100 => x"cae64972",
  1101 => x"c286c487",
  1102 => x"c6c387ea",
  1103 => x"87cc05ab",
  1104 => x"49721e74",
  1105 => x"c487ede6",
  1106 => x"87d8c286",
  1107 => x"05abe0c0",
  1108 => x"1ec087ce",
  1109 => x"49721e74",
  1110 => x"c887c5e9",
  1111 => x"87c4c286",
  1112 => x"05abc4c3",
  1113 => x"1ec187ce",
  1114 => x"49721e74",
  1115 => x"c887f1e8",
  1116 => x"87f0c186",
  1117 => x"05abf0c0",
  1118 => x"1ec087ce",
  1119 => x"49721e74",
  1120 => x"c887f2ef",
  1121 => x"87dcc186",
  1122 => x"05abc5c3",
  1123 => x"1ec187ce",
  1124 => x"49721e74",
  1125 => x"c887deef",
  1126 => x"87c8c186",
  1127 => x"cc05abc8",
  1128 => x"721e7487",
  1129 => x"87e7e649",
  1130 => x"f7c086c4",
  1131 => x"059b7387",
  1132 => x"1e7487cc",
  1133 => x"dbe54972",
  1134 => x"c086c487",
  1135 => x"66c887e6",
  1136 => x"6697c91e",
  1137 => x"97cc1e49",
  1138 => x"cf1e4966",
  1139 => x"1e496697",
  1140 => x"496697d2",
  1141 => x"ff49c41e",
  1142 => x"d487e1df",
  1143 => x"49d1c286",
  1144 => x"87c0d7ff",
  1145 => x"d8ff8ef4",
  1146 => x"c31e87d3",
  1147 => x"49bfd3c8",
  1148 => x"c8c3b9c1",
  1149 => x"d4ff59d7",
  1150 => x"78ffc348",
  1151 => x"c048d0ff",
  1152 => x"d4ff78e1",
  1153 => x"c478c148",
  1154 => x"ff787131",
  1155 => x"e0c048d0",
  1156 => x"004f2678",
  1157 => x"1e000000",
  1158 => x"bffcddc3",
  1159 => x"c3b0c148",
  1160 => x"fe58c0de",
  1161 => x"c187f3ee",
  1162 => x"c248c8eb",
  1163 => x"ebc9c350",
  1164 => x"f9fd49bf",
  1165 => x"ebc187c9",
  1166 => x"50c148c8",
  1167 => x"bfe7c9c3",
  1168 => x"faf8fd49",
  1169 => x"c8ebc187",
  1170 => x"c350c348",
  1171 => x"49bfefc9",
  1172 => x"87ebf8fd",
  1173 => x"bffcddc3",
  1174 => x"c398fe48",
  1175 => x"fe58c0de",
  1176 => x"c087f7ed",
  1177 => x"734f2648",
  1178 => x"7f000032",
  1179 => x"8b000032",
  1180 => x"50000032",
  1181 => x"20545843",
  1182 => x"52202020",
  1183 => x"54004d4f",
  1184 => x"59444e41",
  1185 => x"52202020",
  1186 => x"58004d4f",
  1187 => x"45444954",
  1188 => x"52202020",
  1189 => x"52004d4f",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
