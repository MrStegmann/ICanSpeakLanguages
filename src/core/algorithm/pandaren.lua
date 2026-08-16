local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = {
            -- Mandarin & Cantonese Initials
            "B", "P", "M", "F", "D", "T", "N", "L",
            "G", "K", "H", "J", "Q", "X", "Zh", "Ch",
            "Sh", "R", "Z", "C", "S", "Gw", "Kw", "Ng", "W", "Y"
        },
        vowels = {
            -- Combined Syllabic Nuclei & Diphthongs
            "a", "e", "i", "o", "u", "ü", "ai", "ei",
            "ao", "ou", "an", "en", "ang", "eng", "ong",
            "ia", "ie", "iao", "iu", "ian", "in", "iang",
            "ing", "iong", "ua", "uo", "uai", "ui", "uan",
            "un", "uang", "ue", "ün", "oe", "eo", "aa",
            "aai", "aau", "aam", "aan", "aang", "aat", "aak",
            "oi", "ou", "ui", "iu", "eung", "euk"
        },
        endings = {
            -- Standard Syllable Final Coda Marks
            "n", "ng", "m", "p", "t", "k", "i", "u", ""
        }
    },
    lexicon = {
        verbs = {
            ["brew"]     = { root = "Jiu",   tense = "present" },
            ["brewed"]   = { root = "Jiu",   tense = "past" },
            ["fight"]    = { root = "Da",    tense = "present" },
            ["fought"]   = { root = "Da",    tense = "past" },
            ["drink"]    = { root = "He",    tense = "present" },
            ["drank"]    = { root = "He",    tense = "past" },
            ["strike"]   = { root = "Zhang", tense = "present" },
            ["protect"]  = { root = "Bao",   tense = "present" },
            ["meditate"] = { root = "Chuan", tense = "present" }
        },
        nouns = {
            ["beer"]      = { root = "Jiu",     gender = "neutral",   isPlural = false },
            ["beers"]     = { root = "Jiu",     gender = "neutral",   isPlural = true },
            ["pandaren"]  = { root = "Xiong",   gender = "masculine", isPlural = false },
            ["pandarens"] = { root = "Xiong",   gender = "masculine", isPlural = true },
            ["mist"]      = { root = "Yun",     gender = "feminine",  isPlural = false },
            ["mists"]     = { root = "Yun",     gender = "feminine",  isPlural = true },
            ["dragon"]    = { root = "Long",    gender = "masculine", isPlural = false },
            ["dragons"]   = { root = "Long",    gender = "masculine", isPlural = true },
            ["tiger"]     = { root = "Hu",      gender = "masculine", isPlural = false },
            ["staff"]     = { root = "Gun",     gender = "neutral",   isPlural = false },
            ["peace"]     = { root = "Heping",  gender = "neutral",   isPlural = false }
        },
        fallbacks = {
            short = {
                "A", "E", "I", "O", "U", "An", "Ai", "Ba", "Bi", "Bo", "Ci", "Da", "Di",
                "Du", "Fa", "Fu", "Ge", "Gu", "Ha", "He", "Hu", "Ji", "Ju", "Ke", "Ku",
                "La", "Le", "Li", "Lu", "Ma", "Me", "Mi", "Mu", "Na", "Ne", "Ni", "Po",
                "Qi", "Ru", "Si", "Su", "Ti", "Tu", "Xi", "Xu", "Ya", "Ye", "Yi", "Yu",
                "Za", "Zi", "Zu"
            },
            medium = {
                "Ang", "Bai", "Ban", "Bao", "Bei", "Ben", "Cai", "Can", "Cao", "Cha", "Chu",
                "Cong", "Dai", "Dan", "Dao", "Dun", "Fan", "Fei", "Fen", "Gan", "Gao", "Gen",
                "Gong", "Hai", "Han", "Hao", "Hen", "Hong", "Jia", "Jin", "Kai", "Kan", "Kong",
                "Lan", "Lao", "Lei", "Lin", "Long", "Mai", "Man", "Mao", "Men", "Miao", "Min",
                "Nan", "Nian", "Nong", "Pai", "Piao", "Qiao", "Qing", "Rao", "Ren", "Rong",
                "Shao", "Shu", "Song", "Tai", "Tao", "Tian", "Wan", "Wei", "Xia", "Xiao", "Xin",
                "Xue", "Yan", "Yao", "Yin", "Yun", "Zao", "Zhao", "Zhen", "Zhu", "Bang", "Bian",
                "Biao", "Bing", "Cang", "Chao", "Chen", "Chun", "Diao", "Ding", "Dong", "Fang",
                "Feng", "Gang", "Geng", "Guan", "Gui", "Hang", "Heng", "Huan", "Hui", "Jian",
                "Jiao", "Jing", "Jiong", "Kang", "Kuan", "Lang", "Lian", "Ling", "Luan", "Mang",
                "Mian", "Ming", "Niao", "Ning", "Pang", "Pian", "Ping", "Qian", "Quan", "Rang",
                "Ruan", "Shan", "Shen", "Shou", "Shui", "Shun", "Tang", "Teng", "Ting", "Tong",
                "Wang", "Weng", "Xian", "Xing", "Xiong", "Yuan", "Yue", "Zhan", "Zhou"
            },
            long = {
                "Chang", "Cheng", "Chong", "Chuan", "Chuang", "Guang", "Huang", "Jiang",
                "Kuang", "Liang", "Niang", "Qiang", "Qiong", "Shang", "Sheng", "Shuang",
                "Xiang", "Zhang", "Zheng", "Zhong", "Zhuang", "Nushun", "Sanpao", "Yubian",
                "Xiemiao", "Guniang", "Kuhuua", "Sanjie", "Jiaozhi", "Baoyun", "Caifeng",
                "Daoxue", "Feilian", "Guanhe", "Haoyun", "Jinshui", "Lanqiao", "Mingxia",
                "Qinghe", "Ronghua", "Shanlu", "Taoyun", "Wanling", "Xueyan", "Yunhai",
                "Zhuyin", "Leishan", "Hualin", "Qiaoyu", "Renshu", "Songlan", "Nushuai",
                "Koutian", "Huashen", "Bazaoge", "Chenghua", "Jiemeia", "Zizhiye", "Baishan",
                "Caixiao", "Daoyuan", "Feiyang", "Guanghe", "Hailong", "Jinling", "Lanxue",
                "Mingyue", "Qingyun", "Rongshan", "Shuilan", "Taofeng", "Wanqiao", "Xiaolian",
                "Yunshao", "Zhenyuan", "Zhuxiao", "Leiming", "Huanyue", "Qiaoshan", "Ruiling",
                "Songhua", "Nushubian", "Liaojiao", "Shanzhiye", "Chenghuua", "Koushang",
                "Baoyunhe", "Caifenglu", "Daoxuelin", "Feilianyu", "Guanhaixu", "Huangshan",
                "Jinshuiao", "Lanqiaoyu", "Mingxiahe", "Qinghelan", "Ronghuayi", "Shanluyun",
                "Taoyunxi", "Wanlinghe", "Xueyanlu", "Yunhaizhi", "Zhuyinhe", "Leishanyu",
                "Hualinxue", "Sanpaozhai", "Yubianhua", "Xiemiaoshe", "Baishanyun", "Caixiaolin",
                "Daoyuanhe", "Feiyangluo", "Guangheyun", "Hailongzhi", "Jinlingxue", "Lanxueqiao",
                "Mingyuehan", "Qingyunshan", "Rongshanlu", "Shuilanfeng", "Taofengyu", "Wanqiaozhi",
                "Xiaolianhe", "Yunshaoling", "Zhenyuanxi", "Guniangzhai", "Jiaozhixiea", "Baoyunshan",
                "Caifengyue", "Daoxueling", "Feilianqiao", "Guanhaizhen", "Huangyunhe", "Jinshuilan",
                "Lanqiaofeng", "Mingxiayun", "Qingheluo", "Ronghuashan", "Shanluying", "Taoyunling",
                "Wanlingxue", "Xueyanfeng", "Yunhaishan", "Zhuyinluo", "Nushuaijiao", "Jiemeiazuo",
                "Baishanyueli", "Caixiaoyunhe", "Daoyuanling", "Feiyangshui", "Guanghelian", "Hailongyue",
                "Jinlingyun", "Lanxuefeng", "Mingyueshan", "Qingyunqiao", "Rongshanling", "Shuilanyue",
                "Taofengxue", "Wanqiaoyun", "Xiaolianyu", "Zhenyuanhe", "Nushubianhua", "Baoyunshanhe",
                "Caifengyueling", "Daoxuelianyu", "Feilianyunhe", "Guanhaishanlu", "Huangyunqia",
                "Jinshuilingyu", "Lanqiaoxueyan", "Mingxiayunhe", "Qingheluofeng", "Ronghuashanxi",
                "Shanluyueling", "Taoyunxuehe", "Wanlingfengyu", "Xueyanshanhe", "Yunhaizhuling", "Zhuyinluoyue"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "guo-",
            ["future"]     = "hui-",
            ["imperative"] = "ya-"
        },
        personSuffixes = {
            [1] = "",
            [2] = "men",
            [3] = "lao"
        }
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.PandarenHasher = Hasher
_G.PandarenHasher = Hasher
return Hasher