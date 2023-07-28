// Feather disable all
function __scribble_get_krutidev_lookup_map()
{
    static _map = ds_map_create();
    return _map;
}

function __scribble_krutidev_lookup_map_initialize()
{
    var _lookup_map = __scribble_get_krutidev_lookup_map();
    
    //TODO - Precalculate the lookup table
    //TODO - Move this to __scribble_glyph_data_initialize()
    var _unicode_source_array = [
        "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".",
        "०",  "१",  "२",  "३",     "४",   "५",  "६",   "७",   "८",   "९", "x", 
        
        "फ़्",  "क़",  "ख़",  "ग़", "ज़्", "ज़",  "ड़",  "ढ़",   "फ़",  "य़",  "ऱ",  "ऩ",  
        "त्त्",   "त्त",     "क्त",  "दृ",  "कृ",
        
        "ह्न",  "ह्य",  "हृ",  "ह्म",  "ह्र",  "ह्",   "द्द",  "क्ष्", "क्ष", "त्र्", "त्र","ज्ञ",
        "छ्य",  "ट्य",  "ठ्य",  "ड्य",  "ढ्य", "द्य","द्व",
        "श्र",  "ट्र",    "ड्र",    "ढ्र",    "छ्र",   "क्र",  "फ्र",  "द्र",   "प्र",   "ग्र", "रु",  "रू",
        "्र",
        
        "ओ",  "औ",  "आ",   "अ",   "ई",   "इ",  "उ",   "ऊ",  "ऐ",  "ए", "ऋ",
        
        "क्",  "क",  "क्क",  "ख्",   "ख",    "ग्",   "ग",  "घ्",  "घ",    "ङ",
        "चै",   "च्",   "च",   "छ",  "ज्", "ज",   "झ्",  "झ",   "ञ",
        
        "ट्ट",   "ट्ठ",   "ट",   "ठ",   "ड्ड",   "ड्ढ",  "ड",   "ढ",  "ण्", "ण",  
        "त्",  "त",  "थ्", "थ",  "द्ध",  "द", "ध्", "ध",  "न्",  "न",  
        
        "म्म्",
        
        "प्",  "प",  "फ्", "फ",  "ब्",  "ब", "भ्",  "भ",  "म्",  "म",
        "य्",  "य",  "र",  "ल्", "ल",  "ळ",  "व्",  "व", 
        "श्", "श",  "ष्", "ष",  "स्",   "स",   "ह",     
        
        "ऑ",   "ॉ",  "ो",   "ौ",   "ा",   "ी",   "ु",   "ू",   "ृ",   "े",   "ै",
        "ं",   "ँ",   "ः",   "ॅ",    "ऽ", chr(0x94D), //virama
    ];
    
    var _krutidev_source_array = [
        "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-", 
        "å",  "ƒ",  "„",   "…",   "†",   "‡",   "ˆ",   "‰",   "Š",   "‹","Û",
        
        "¶",   "d",    "[k",  "x",  "T",  "t",   "M+", "<+", "Q",  ";",    "j",   "u",
        "Ù",   "Ùk",   "Dr",    "–",   "—",       
        
        "à",   "á",    "â",   "ã",   "ºz",  "º",   "í", "{", "{k",  "«", "=","K", 
        "Nî",   "Vî",    "Bî",   "Mî",   "<î", "|","}",
        "J",   "Vª",   "Mª",  "<ªª",  "Nª",   "Ø",  "Ý",   "æ", "ç", "xz", "#", ":",
        "z",
        
        "vks",  "vkS",  "vk",    "v",   "bZ",  "b",  "m",  "Å",  ",s",  ",",   "_",
        
        "D",  "d",    "ô",     "[",     "[k",    "X",   "x",  "?",    "?k",   "³", 
        "pkS",  "P",    "p",  "N",   "T",    "t",   "÷",  ">",   "¥",
        
        "ê",      "ë",      "V",  "B",   "ì",       "ï",     "M",  "<",  ".", ".k",   
        "R",  "r",   "F", "Fk",  ")",    "n", "/",  "/k",  "U", "u",   
        
        "Ee~",
        
        "I",  "i",   "¶", "Q",   "C",  "c",  "H",  "Hk", "E",   "e",
        "¸",   ";",    "j",  "Y",   "y",  "G",  "O",  "o",
        "'", "'k",  "\"", "\"k", "L",   "l",   "g",      
        
        "v‚",    "‚",    "ks",   "kS",   "k",     "h",    "q",   "w",   "`",    "s",    "S",
        "a",    "¡",    "%",     "W",   "·", "~",
    ];
    
    var _i = 0;
    repeat(array_length(_unicode_source_array))
    {
        var _string = _unicode_source_array[_i];
        
        var _searchInteger = 0;
        var _j = string_length(_string);
        repeat(_j)
        {
            _searchInteger = (_searchInteger << 16) | ord(string_char_at(_string, _j));
            --_j;
        }
        
        var _string = _krutidev_source_array[_i];
        var _writeArray = [];
        var _j = 1;
        repeat(string_length(_string))
        {
            array_push(_writeArray, ord(string_char_at(_string, _j)));
            ++_j;
        }
        
        _lookup_map[? _searchInteger] = _writeArray;
        
        ++_i;
    }
}
