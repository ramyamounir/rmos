// #define PATH(name)			"/home/yigit/.local/bin/status-bar/"name
// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
static const Block blocks[] = {
    /*Icon*/ /*Command*/ /*Update Interval*/ /*Update Signal*/
    {"", "sb-memory",	10,  0},
    {"", "sb-disk",	10,  0},
    {"", "sb-nettraf",5,7}, // network.sh
    {"", "sb-volume", 1, 4}, //volume.sh
    {"", "sb-internet", 5, 2}, //wifi.sh
    {"", "sb-vpn", 5, 2}, //wifi.sh
    {"", "time.sh", 1, 1},

};

// sets delimeter between status commands. NULL character ('\0') means no
// delimeter.
static char delim[] = " ";
static unsigned int delimLen = 5;

