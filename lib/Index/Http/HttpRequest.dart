//地址
const String baseUrl = "https://api.lolicon.app/setu/";

// apikey	false		APIKEY
// r18	false	0	0为非 R18，1为 R18，2为混合
// keyword	false		若指定关键字，将会返回从插画标题、作者、标签中模糊搜索的结果
// num	false	1	一次返回的结果数量，范围为1到10，不提供 APIKEY 时固定为1；在指定关键字的情况下，结果数量可能会不足指定的数量
// proxy	false	i.pixiv.cat	设置返回的原图链接的域名，你也可以设置为disable来得到真正的原图链接[1]
// size1200	false	false	是否使用 master_1200 缩略图，即长或宽最大为 1200px 的缩略图，以节省流量或提升加载速度（某些原图的大小可以达到十几MB）