/* See LICENSE file for copyright and license details. */

/* appearance */
// clang-format off
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static const int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "IosevkaTerm Nerd Font:size=10", "Noto Color Emoji:size=10" };
static const char dmenufont[]       = "IosevkaTerm Nerd Font:size=10";
static const char col_gray1[]       = "#504945";
static const char col_gray2[]       = "#7c6f64";
static const char col_gray3[]       = "#a89984";
static const char col_gray4[]       = "#bdae93";
static const char col_cyan[]        = "#b16286";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"st", "-n", "spterm", "-g", "120x34", NULL };
const char *spcmd2[] = {"pcmanfm", NULL };
const char *spcmd3[] = {"keepassxc", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",      spcmd1},
	{"spranger",    spcmd2},
	{"keepassxc",   spcmd3},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",	  NULL,			NULL,		0,				1,			 -1 },
	{ "Firefox",  NULL,			NULL,		1 << 8,			0,			 -1 },
	{ NULL,		  "spterm",		NULL,		SPTAG(0),		1,			 -1 },
	{ NULL,		  "spfm",		NULL,		SPTAG(1),		1,			 -1 },
	{ NULL,		  "keepassxc",	NULL,		SPTAG(2),		0,			 -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[TILE]",      tile },    /* first entry is default */
	{ "[FLOAT]",      NULL },    /* no layout function means floating behavior */
	{ "[FULL]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "alacritty", NULL };

#include "shift-tools-scratchpads.c"
#include <X11/XF86keysym.h>

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,        spawn,          {.v = dmenucmd } },
	{ MODKEY,	                      XK_Return,   spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_j,        focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,        focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,        incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,        incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,        setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,        setmfact,       {.f = +0.05} },
	//{ MODKEY|Mod4Mask,              XK_h,      incrgaps,       {.i = +1 } },
	//{ MODKEY|Mod4Mask,              XK_l,      incrgaps,       {.i = -1 } },
	//{ MODKEY|Mod4Mask|ShiftMask,    XK_h,      incrogaps,      {.i = +1 } },
	//{ MODKEY|Mod4Mask|ShiftMask,    XK_l,      incrogaps,      {.i = -1 } },
	//{ MODKEY|Mod4Mask|ControlMask,  XK_h,      incrigaps,      {.i = +1 } },
	//{ MODKEY|Mod4Mask|ControlMask,  XK_l,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,                XK_G,      togglegaps,     {0} },
	//{ MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	//{ MODKEY,                       XK_y,      incrihgaps,     {.i = +1 } },
	//{ MODKEY,                       XK_o,      incrihgaps,     {.i = -1 } },
	//{ MODKEY|ControlMask,           XK_y,      incrivgaps,     {.i = +1 } },
	//{ MODKEY|ControlMask,           XK_o,      incrivgaps,     {.i = -1 } },
	//{ MODKEY|Mod4Mask,              XK_y,      incrohgaps,     {.i = +1 } },
	//{ MODKEY|Mod4Mask,              XK_o,      incrohgaps,     {.i = -1 } },
	//{ MODKEY|ShiftMask,             XK_y,      incrovgaps,     {.i = +1 } },
	//{ MODKEY|ShiftMask,             XK_o,      incrovgaps,     {.i = -1 } },
	{ MODKEY|ShiftMask,               XK_Return, zoom,           {0} },
	// { MODKEY,                         XK_Tab,    view,           {0} },
	{ MODKEY,	                        XK_c,      killclient,     {0} },
	{ MODKEY,                         XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                         XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                         XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                         XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,               XK_space,  togglefloating, {0} },
	{ MODKEY,                         XK_agrave, view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,               XK_agrave, tag,            {.ui = ~0 } },
	{ MODKEY,                         XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                         XK_semicolon, focusmon,    {.i = +1 } },
	{ MODKEY|ShiftMask,               XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,               XK_semicolon, tagmon,      {.i = +1 } },
	{ MODKEY,            		          XK_y,  	   togglescratch,  {.ui = 0 } },
	{ MODKEY,      			              XK_e,	   togglescratch,  {.ui = 1 } },
	{ MODKEY,           		          XK_x,	   togglescratch,  {.ui = 2 } },
	{ MODKEY,			                    XK_Tab,	   shiftview,	   {.i = +1}  },
	{ MODKEY|ShiftMask,			          XK_Tab,	   shiftview,	   {.i = -1}  },
	{ MODKEY|ShiftMask,               XK_q,      quit,           {0} },
  { 0, XF86XK_MonBrightnessUp,      spawn, {.v = (const char*[]){"changebrightness", "up", NULL } } },
  { 0, XF86XK_MonBrightnessDown,    spawn, {.v = (const char*[]){"changebrightness", "down", NULL } } },
  TAGKEYS(                          XK_ampersand,              0)
  TAGKEYS(                          XK_eacute,                 1)
  TAGKEYS(                          XK_quotedbl,               2)
  TAGKEYS(                          XK_apostrophe,             3)
  TAGKEYS(                          XK_parenleft,              4)
  TAGKEYS(                          XK_minus,                  5)
  TAGKEYS(                          XK_egrave,                 6)
  TAGKEYS(                          XK_underscore,             7)
  TAGKEYS(                          XK_ccedilla,               8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button1,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
// clang-format on
