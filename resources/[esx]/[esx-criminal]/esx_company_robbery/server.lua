-- Lua Encrypt by Shadow
-- https://github.com/swan2b144
key="secure"local a=load((function(b,c)function bxor(d,e)local f={{0,1},{1,0}}local g=1;local h=0;while d>0 or e>0 do h=h+f[d%2+1][e%2+1]*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return h end;local i=function(b)local j={}local k=1;local l=b[k]while l>=0 do j[k]=b[l+1]k=k+1;l=b[k]end;return j end;local m=function(b,c)if#c<=0 then return{}end;local k=1;local n=1;for k=1,#b do b[k]=bxor(b[k],string.byte(c,n))n=n+1;if n>#c then n=1 end end;return b end;local o=function(b)local j=""for k=1,#b do j=j..string.char(b[k])end;return j end;return o(m(i(b),c))end)({1568,1355,1074,1440,1811,1529,1024,1564,987,1340,926,1426,1860,1422,1602,1611,1592,1320,1369,1333,1532,1518,1831,874,1601,1166,943,1038,1567,1000,1259,899,1013,1389,1012,1048,1754,1164,1391,1054,1852,1291,1411,1458,1402,1248,1423,1286,1034,1474,1505,1108,1378,1090,1554,1276,1069,1339,1142,1260,890,1296,1175,1428,1663,1595,922,1263,897,1475,933,1716,1218,1275,1460,1784,953,1737,1381,1338,1154,1841,1168,1787,1079,909,1863,1494,962,1502,1323,1859,1615,1621,882,1804,1066,1305,1613,1235,1693,931,1200,1635,1303,1573,1112,1774,996,1471,915,1330,1089,1362,967,1107,1026,1765,1827,1548,1819,1584,1380,1180,1862,950,1231,1187,1129,1830,1023,1441,1151,1501,1316,992,1053,1582,1834,1318,1125,1019,1347,1161,1817,1354,1491,1634,1654,1317,1824,1521,1511,1747,1638,1124,1057,1842,965,1652,1485,1641,1711,1607,1392,1789,1101,1401,1594,1858,981,1009,1127,1680,1627,1864,1624,1110,1813,1359,1393,1468,976,1254,1269,1137,1119,1156,1745,1844,1591,1311,1625,1659,999,1165,1837,1815,1523,1614,975,1232,1277,1753,894,1174,1835,876,1257,1520,1702,1709,929,1781,1190,1840,1072,924,1189,1570,1253,878,908,1866,1301,872,1117,1122,1100,1001,1424,1106,1205,1178,1304,1798,1003,1472,934,1255,1238,1786,1495,1406,1571,1274,911,1209,1555,1563,1080,1337,1181,1686,1078,1061,1247,1196,973,1855,1258,1828,1266,1557,1283,1361,1823,1262,1104,1343,1268,1058,1795,1655,1790,1626,1722,1814,1764,1770,1335,1526,884,1513,893,984,1111,1372,1668,1064,1158,1171,1018,1160,1225,1578,1170,1748,1665,1644,1193,1293,1861,1214,1596,870,1769,1282,1809,1163,1720,1446,1849,1743,1242,1535,1099,1741,1662,1649,1776,1438,1636,1397,1230,959,1183,1620,1577,1350,1410,1036,1843,1228,1691,964,1684,1629,1766,1157,1561,1360,1461,1771,887,1429,1558,1060,1850,1617,1632,1443,1510,1102,1470,1285,938,951,1647,1025,1133,1364,1539,1801,1220,1091,1212,1201,1250,1136,1365,1533,1542,988,1332,885,1270,990,877,1583,1306,1701,1331,979,871,1208,1718,1793,1148,1488,1030,998,1169,1310,1198,1370,1322,1352,1081,1616,1560,1295,969,1569,1288,1326,1118,1825,1437,1516,1096,1051,1126,1481,902,920,1141,1622,1217,1671,1153,1223,1762,1237,1207,1287,1144,947,1005,958,1029,1376,1633,1150,1114,1123,1139,1856,1063,1404,1233,949,1576,1618,960,1674,919,1756,993,1675,1639,1377,1371,1382,914,1556,1457,1593,1575,1808,1271,1307,1071,1572,1729,1672,1643,1726,1388,1433,1342,1390,1204,925,1128,1094,1694,1486,1704,1708,1065,1430,1046,1442,978,1290,1037,880,1292,1544,1239,1731,1007,1507,1417,1537,1758,1191,1145,1519,1608,940,1087,883,1685,1325,970,1552,936,1188,1724,1550,1725,1167,1612,1234,963,1527,1749,1603,1541,1132,1147,1689,1630,1545,1794,1368,1648,1838,1853,1706,1049,1095,1031,1385,1712,1589,1661,1522,997,1032,1653,1146,1581,1312,1202,1688,921,982,956,1696,1812,875,1600,1379,994,968,927,1692,1462,1807,1580,1432,1299,1245,1035,1628,1134,930,1590,898,971,1810,904,1014,1015,903,1721,1455,1473,1162,1713,1149,1022,1673,1077,1759,1681,1138,1806,1690,1073,1551,1329,1565,1738,1375,1543,1490,986,1016,1186,1039,1524,889,913,1744,1445,1566,1251,1097,1357,1761,1534,991,1816,1216,879,873,1020,1465,1710,1279,1395,939,1637,1559,1469,1002,1504,1403,1450,1588,1199,1358,1779,1244,1742,1327,1736,1131,1547,1041,1752,1651,1152,1345,1479,881,1851,1658,972,1294,1366,1192,1857,1683,1062,941,1195,1346,1631,1768,1579,1822,1004,1439,1451,1820,1412,1261,937,989,1076,1609,1349,1723,892,1098,1805,1121,1040,1715,906,886,1055,896,1056,1210,1067,1416,1777,1308,1482,1105,1047,1448,995,1792,1528,1464,966,1530,942,1606,1597,1219,1447,1213,1677,1791,1203,928,1229,1420,1477,1383,1314,1512,957,1678,1319,1772,1226,1487,1508,1043,1667,1735,1284,916,1256,907,1492,1425,1092,1088,1719,1664,1373,1405,1431,944,1407,1650,1387,983,905,1586,1452,1236,1848,1289,1755,1785,1703,1821,1324,1865,1184,1739,1243,1143,1021,1515,1280,1093,1549,1278,1497,1854,1687,1444,1553,1028,1070,1249,1052,935,1298,1499,1042,1155,1173,1666,1227,1728,1315,1826,891,985,1500,1604,1750,1159,1778,1194,1086,1509,1531,1733,1011,1536,1574,1309,1800,1660,1267,1130,1434,1585,1328,1456,1103,1421,1610,1803,1351,901,1427,1215,1782,1669,1783,1418,1493,1514,1799,1484,1172,952,1116,1356,1562,1176,1498,1463,1698,1109,1697,1796,1336,1454,1833,1084,1177,1206,1802,1313,1832,1272,1449,1408,1623,1705,1478,1409,1241,1773,1740,1341,1780,1115,1845,1818,1599,1179,1300,-1,72,18,92,1,21,17,22,22,18,1,55,57,23,3,83,26,75,10,22,69,3,23,78,2,29,111,85,82,4,22,180,79,3,104,0,6,83,1,28,73,73,22,141,83,30,2,6,129,183,67,4,67,78,188,7,69,2,22,76,23,13,104,38,80,82,69,23,83,21,17,90,104,14,76,23,164,154,9,11,27,69,16,85,17,128,104,7,22,20,73,126,64,23,16,66,79,29,28,77,31,6,7,91,83,35,16,67,19,6,10,193,74,19,26,6,11,84,23,58,6,7,85,17,82,28,17,28,26,1,7,9,72,2,19,83,12,3,0,115,85,110,10,7,6,22,90,66,24,29,1,67,67,67,0,30,17,6,75,69,22,50,7,1,59,1,23,66,3,19,127,22,69,10,17,38,255,14,27,23,21,198,22,82,82,91,77,1,11,69,47,0,7,82,7,17,28,23,1,151,4,67,0,30,82,17,186,12,82,67,1,29,43,77,87,69,76,91,93,18,82,0,58,90,0,69,0,60,69,69,17,94,47,0,16,91,6,17,1,28,1,85,1,82,58,5,104,1,91,85,28,120,26,69,0,0,16,29,22,83,5,11,17,0,91,82,83,5,6,6,28,7,13,6,69,73,7,68,16,127,69,69,4,41,28,13,18,1,120,75,16,4,12,69,0,11,16,74,27,23,7,0,25,79,21,2,19,73,83,6,17,127,84,134,67,82,72,110,69,6,6,28,17,69,90,17,121,11,210,4,6,121,10,81,22,82,23,69,0,1,69,17,247,16,18,92,10,10,45,83,23,10,212,56,7,152,23,2,1,85,90,23,83,1,12,75,6,23,16,27,7,163,95,6,83,77,29,122,7,16,85,14,82,182,90,85,17,28,26,23,22,75,69,16,86,182,153,23,19,121,82,16,79,73,127,1,3,74,0,1,69,82,119,69,4,82,32,16,28,17,28,17,10,6,76,66,1,13,72,39,22,91,7,99,67,1,0,26,69,18,10,48,69,81,27,82,15,17,4,69,17,17,43,29,7,105,9,93,16,17,28,25,30,17,71,220,82,110,11,10,16,1,82,110,104,131,59,69,0,169,23,32,26,17,253,2,0,23,21,6,69,55,12,6,199,66,19,90,202,12,91,0,0,0,68,142,85,66,10,30,26,110,26,20,88,201,75,5,67,126,22,127,4,63,83,112,0,45,11,78,249,130,78,16,2,12,1,22,6,66,66,39,30,82,125,78,191,12,75,22,183,69,7,20,17,67,85,55,30,74,6,23,82,17,111,10,175,207,0,127,69,19,69,61,7,69,67,69,91,4,83,14,67,22,136,127,85,26,0,74,105,22,22,17,22,10,28,203,20,69,28,1,6,1,82,0,70,166,78,38,47,50,8,92,25,66,85,16,17,111,116,69,77,6,29,1,67,170,110,67,23,7,10,29,247,93,5,197,17,83,66,4,11,1,69,1,85,29,216,1,21,4,6,90,93,82,201,69,10,6,23,16,6,11,11,17,85,58,87,170,6,236,1,10,79,4,16,210,95,69,29,23,6,6,83,0,75,69,23,6,28,28,120,16,2,45,1,85,27,35,0,7,29,10,85,16,0,90,53,77,82,82,74,12,23,66,58,13,253,20,29,22,79,1,23,90,1,82,23,92,13,10,73,22,90,32,139,23,59,89,17,22,16,21,17,69,67,20,54,76,241,82,29,12,36,105,16,0,83,89,104,17,67,6,95,18,69,23,17,6,31,201,77,250,17,0,244,42,28,31,0,11,93,85,94,31,85,115,90,94,10,5,2,23,27,11,22,0,11,1,1,179,23,7,85,111,69,194,12,6,193,10,28,185,26,90,26,17,82,73,16,25,85,23,91,51,199,11,22,29,121,206,79,1,90,0,48,90,36,3,77,28,40,19,83,8,0,73,9,68,28,28,105,29,69,6,10,0,18,38,22,223,0,201,6,2,16,10,17,6,69,68,10,23,13,69,6,18,93,26,14,21,80,68,12,26,1,85,221,26,9,91,10,1,99,110,85,105,238,85,94,127,2,12,69,9,57,110,13,28,27,91,26,18,78,27,0,0,23,91,41,82,7,93,92,20,67,76,49,28,22,14,6,6,23,4,0,2,89,85,17,16,29,16,82,1,75,5,29,0,84,85,104,69,16,7,0,28,79,29,23,26,6,22,82,29,77,209,82,0,98,16,93,17,79,85,121,122,21,20,7,1,62,17,16,127,10,6,7,66,73,22,75,82,67,104,85,23},key))if a then a()else print("WRONG PASSWORD!")end