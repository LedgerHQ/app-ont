/*
 * MIT License, see root folder for full license.
 */

#include "ui.h"
#include "blue_elements.h"
#include "glyphs.h"

/** default font */
#define DEFAULT_FONT BAGL_FONT_OPEN_SANS_EXTRABOLD_11px | BAGL_FONT_ALIGNMENT_CENTER

#define DEFAULT_FONT_BLUE BAGL_FONT_OPEN_SANS_LIGHT_14px | BAGL_FONT_ALIGNMENT_CENTER | BAGL_FONT_ALIGNMENT_MIDDLE

/** text description font. */
#define TX_DESC_FONT BAGL_FONT_OPEN_SANS_REGULAR_11px | BAGL_FONT_ALIGNMENT_CENTER

/** the timer */
int exit_timer;

/** display for the timer */
char timer_desc[MAX_TIMER_TEXT_WIDTH];

/** UI state enum */
enum UI_STATE uiState;

/** UI state flag */
#ifdef TARGET_NANOX
#include "ux.h"
ux_state_t G_ux;
bolos_ux_params_t G_ux_params;
#else // TARGET_NANOX
ux_state_t ux;
#endif // TARGET_NANOX

/** notification to restart the hash */
unsigned char hashTainted;

/** notification to refresh the view, if we are displaying the public key */
unsigned char publicKeyNeedsRefresh;

/** the hash. */
cx_sha256_t hash;

/** index of the current screen. */
unsigned int curr_scr_ix;

/** max index for all screens. */
unsigned int max_scr_ix;

/** raw transaction data. */
unsigned char raw_tx[MAX_TX_RAW_LENGTH];

/** current index into raw transaction. */
unsigned int raw_tx_ix;

/** current length of raw transaction. */
unsigned int raw_tx_len;

/** all text descriptions. */
char tx_desc[MAX_TX_TEXT_SCREENS][MAX_TX_TEXT_LINES][MAX_TX_TEXT_WIDTH];

/** currently displayed text description. */
char curr_tx_desc[MAX_TX_TEXT_LINES+2][MAX_TX_TEXT_WIDTH];

/** currently displayed public key */
char current_public_key[MAX_TX_TEXT_LINES][MAX_TX_TEXT_WIDTH];

/** UI was touched indicating the user wants to exit the app */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e);

/** UI was touched indicating the user wants to deny te signature request */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e);

/** display part of the transaction description */
static void ui_display_tx_desc_1(void);

static void ui_display_tx_desc_2(void);

static void ui_display_tx_desc_3(void);

/** display the UI for signing a transaction */
static void ui_sign(void);

/** display the UI for denying a transaction */
static void ui_deny(void);

/** show the public key screen */
static void ui_public_key_1(void);

static void ui_public_key_2(void);

/** move up in the transaction description list */
static const bagl_element_t *tx_desc_up(const bagl_element_t *e);

/** move down in the transaction description list */
static const bagl_element_t *tx_desc_dn(const bagl_element_t *e);

/** sets the tx_desc variables to no information */
static void clear_tx_desc(void);

/** return app to dashboard */
static const bagl_element_t *bagl_ui_DASHBOARD_blue_button(const bagl_element_t *e);
/** goes to settings menu (pubkey display) on blue */
static const bagl_element_t *bagl_ui_SETTINGS_blue_button(const bagl_element_t *e);
/** returns to ONT app on blue */
static const bagl_element_t *bagl_ui_LEFT_blue_button(const bagl_element_t *e);


////////////////////////////////////  NANO X //////////////////////////////////////////////////
#ifdef TARGET_NANOX

UX_STEP_NOCB(
    ux_confirm_single_flow_1_step, 
    pnn, 
    {
      &C_icon_eye,
      "Review",
      "Transaction"
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_2_step, 
    bn, 
    {
      "Type",
      curr_tx_desc[0]
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_3_step, 
    bn, 
    {
      "Amount",
      curr_tx_desc[1],
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_4_step, 
    bnnn, 
    {
      "Destination Address",
      curr_tx_desc[2],
      curr_tx_desc[3],
      curr_tx_desc[4]
    });
UX_STEP_VALID(
    ux_confirm_single_flow_5_step, 
    pb,
    io_seproxyhal_touch_approve(NULL), 
    {
      &C_icon_validate_14,
      "Accept",
    });
UX_STEP_VALID(
    ux_confirm_single_flow_6_step, 
    pb, 
    io_seproxyhal_touch_deny(NULL),
    {
      &C_icon_crossmark,
      "Reject",
    });
UX_FLOW(ux_confirm_single_flow,
  &ux_confirm_single_flow_1_step,
  &ux_confirm_single_flow_2_step,
  &ux_confirm_single_flow_3_step,
  &ux_confirm_single_flow_4_step,
  &ux_confirm_single_flow_5_step,
  &ux_confirm_single_flow_6_step
);



UX_STEP_NOCB(
    ux_display_public_flow_step, 
    bnnn, 
    {
      "Address",
      current_public_key[0],
      current_public_key[1],
      current_public_key[2]
    });
UX_STEP_VALID(
    ux_display_public_go_back_step, 
    pb, 
    ui_idle(),
    {
      &C_icon_back,
      "Back",
    });

UX_FLOW(ux_display_public_flow,
  &ux_display_public_flow_step,
  &ux_display_public_go_back_step
);

void display_account_address(){
	if(G_ux.stack_count == 0) {
			ux_stack_push();
		}
	ux_flow_init(0, ux_display_public_flow, NULL);
}

UX_STEP_NOCB(
    ux_idle_flow_1_step, 
    nn, 
    {
      "Application",
      "is ready",
    });
UX_STEP_VALID(
    ux_idle_flow_2_step,
    pbb,
    display_account_address(),
    {
      &C_icon_eye,
      "Display",
	  "Account"
    });
UX_STEP_NOCB(
    ux_idle_flow_3_step, 
    bn, 
    {
      "Version",
      APPVERSION,
    });
UX_STEP_VALID(
    ux_idle_flow_4_step,
    pb,
    os_sched_exit(-1),
    {
      &C_icon_dashboard,
      "Quit",
    });

UX_FLOW(ux_idle_flow,
  &ux_idle_flow_1_step,
  &ux_idle_flow_2_step,
  &ux_idle_flow_3_step,
  &ux_idle_flow_4_step
);


#endif
////////////////////////////////////////////////////////////////////////////////////////////////



/** UI struct for the idle screen */
static const bagl_element_t bagl_ui_idle_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                         NULL,        0, 0, 0, NULL, NULL, NULL,},
        /* center text */
        {{BAGL_LABELINE,  0x02, 0,   12, 128, 11, 0, 0, 0,         0xFFFFFF, 0x000000,
                 DEFAULT_FONT,                                                                       0},                         "Hello ONT", 0, 0, 0, NULL, NULL, NULL,},
        /* left icon is a X */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_CROSS},     NULL,        0, 0, 0, NULL, NULL, NULL,},
        /* right icon is an eye. */
        {{BAGL_ICON,      0x00, 117, 11, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_EYE_BADGE}, NULL,        0, 0, 0, NULL, NULL, NULL,},

/* */
};

/** UI struct for the idle screen, Blue.*/
static const bagl_element_t bagl_ui_idle_blue[] = {
    BG_FILL,
    HEADER_TEXT("ONT"),
    HEADER_BUTTON_R(DASHBOARD),
    HEADER_BUTTON_L(SETTINGS),
    
    BODY_ONT_ICON,
    TEXT_CENTER(OPEN_TITLE, _Y(270), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(OPEN_MESSAGE1, _Y(310), COLOUR_BLACK, FONT_S),
    TEXT_CENTER(OPEN_MESSAGE2, _Y(330), COLOUR_BLACK, FONT_S),
    TEXT_CENTER(OPEN_MESSAGE3, _Y(450), COLOUR_GREY, FONT_XS)
};

/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_idle_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_public_key_1();
            break;
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            io_seproxyhal_touch_exit(NULL);
            break;
    }

    return 0;
}


/** UI struct for the idle screen */
static const bagl_element_t bagl_ui_public_key_nanos_1[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0,         0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                     NULL,                  0, 0, 0, NULL, NULL, NULL,},
        /* first line of description of current public key */
		{	{	BAGL_LABELINE, 0x02, 10, 10, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 }, current_public_key[0], 0, 0, 0, NULL, NULL, NULL, },
        /* second line of description of current public key */
		{	{	BAGL_LABELINE, 0x02, 10, 21, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 }, current_public_key[1], 0, 0, 0, NULL, NULL, NULL, },
        /* right icon is a X */
        {{BAGL_ICON,      0x00, 113, 12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_CROSS}, NULL,                  0, 0, 0, NULL, NULL, NULL,},
        /* left icon is down arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN},  NULL,                  0, 0, 0, NULL, NULL, NULL,},
/* */
};


/** UI struct for the idle screen */
static const bagl_element_t bagl_ui_public_key_nanos_2[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0,         0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                     NULL,                  0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current public key */
		{	{	BAGL_LABELINE, 0x02, 10, 10, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 }, current_public_key[1], 0, 0, 0, NULL, NULL, NULL, },
        /* third line of description of current public key  */
		{	{	BAGL_LABELINE, 0x02, 10, 21, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 }, current_public_key[2], 0, 0, 0, NULL, NULL, NULL, },
        /* right icon is a X */
        {{BAGL_ICON,      0x00, 113, 12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_CROSS}, NULL,                  0, 0, 0, NULL, NULL, NULL,},
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},    NULL,                  0, 0, 0, NULL, NULL, NULL,},

/* */
};

/** UI struct for the top "Sign Transaction" screen, Blue. */
static const bagl_element_t bagl_ui_public_key_blue[] = {
    BG_FILL,
    HEADER_TEXT("Public Key"),
    HEADER_BUTTON_L(LEFT),
    
    TEXT_CENTER(current_public_key[0], _Y(240), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(current_public_key[1], _Y(270), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(current_public_key[2], _Y(300), COLOUR_BLACK, FONT_L),
    
    TEXT_CENTER(FOOTER1, _Y(442), COLOUR_GREY, FONT_XS),
    TEXT_CENTER(FOOTER2, _Y(458), COLOUR_GREY, FONT_XS)
};

/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_1_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_idle();
            break;
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            ui_public_key_2();
            break;
    }


    return 0;
}


/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_2_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_idle();
            break;
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            ui_public_key_1();
            break;
    }
    return 0;
}


/** UI struct for the top "Sign Transaction" screen, Nano S. */
static const bagl_element_t bagl_ui_top_sign_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* top left bar */
        {{BAGL_RECTANGLE, 0x00, 3,   1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* top right bar */
        {{BAGL_RECTANGLE, 0x00, 113, 1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* center text */
	{	{	BAGL_LABELINE, 0x02, 0, 20, 128, 11, 0, 0, 0, 0xFFFFFF, 0x000000, DEFAULT_FONT, 0 }, "Sign Tx Now", 0, 0, 0, NULL, NULL, NULL, },
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},   NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* right icon is down arrow */
        {{BAGL_ICON,      0x00, 117, 13, 8,   6,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN}, NULL,      0, 0, 0, NULL, NULL, NULL,},
/* */
};

/** UI struct for the top "Sign Transaction" screen, Blue. */
static const bagl_element_t bagl_ui_top_sign_blue[] = {
    BG_FILL,
    HEADER_TEXT("Transaction"),
    
    TEXT_CENTER(tx_desc[0][1], _Y(110), COLOUR_BLACK, FONT_L),
    
    TEXT_CENTER("Amount", _Y(160), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(curr_tx_desc[0], _Y(190), COLOUR_BLACK, FONT_M),
    TEXT_CENTER(curr_tx_desc[1], _Y(210), COLOUR_BLACK, FONT_M),
    
    TEXT_CENTER("Destination Address", _Y(260), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(curr_tx_desc[2], _Y(290), COLOUR_BLACK, FONT_M),
    TEXT_CENTER(curr_tx_desc[3], _Y(310), COLOUR_BLACK, FONT_M),
    TEXT_CENTER(curr_tx_desc[4], _Y(330), COLOUR_BLACK, FONT_M),
    
    BODY_BUTTON("Deny", _X(30), _Y(390), COLOUR_RED, io_seproxyhal_touch_deny),
    BODY_BUTTON("Approve", _X(170), _Y(390), COLOUR_GREEN_BUTTON, io_seproxyhal_touch_approve),
    
    TEXT_CENTER(TX_FOOTER1, _Y(448), COLOUR_GREY, FONT_XS),
    TEXT_CENTER(TX_FOOTER2, _Y(464), COLOUR_GREY, FONT_XS)
};

/**
 * buttons for the top "Sign Transaction" screen
 *
 * up on Left button, down on right button, sign on both buttons.
 */
static unsigned int bagl_ui_top_sign_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_approve(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

/** UI struct for the bottom "Sign Transaction" screen, Nano S. */
static const bagl_element_t bagl_ui_sign_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0, 0},                    NULL, 0, 0, 0, NULL, NULL, NULL,},
        /* top left bar */
        {{BAGL_RECTANGLE, 0x00, 3,   1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0, 0},                    NULL, 0, 0, 0, NULL, NULL, NULL,},
        /* top right bar */
        {{BAGL_RECTANGLE, 0x00, 113, 1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0, 0},                    NULL, 0, 0, 0, NULL, NULL, NULL,},
        /* center text */
	{	{	BAGL_LABELINE, 0x02, 0, 20, 128, 11, 0, 0, 0, 0xFFFFFF, 0x000000, DEFAULT_FONT, 0 }, "Sign Tx", 0, 0, 0, NULL, NULL, NULL, },
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_UP},   NULL, 0, 0, 0, NULL, NULL, NULL,},
        /* right icon is down arrow */
        {{BAGL_ICON,      0x00, 117, 13, 8,   6,  0, 0, 0,         0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_DOWN}, NULL, 0, 0, 0, NULL, NULL, NULL,},
/* */
};

/**
 * buttons for the bottom "Sign Transaction" screen
 *
 * up on Left button, down on right button, sign on both buttons.
 */
static unsigned int bagl_ui_sign_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_approve(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

/** UI struct for the bottom "Deny Transaction" screen, Nano S. */
static const bagl_element_t bagl_ui_deny_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* top left bar */
        {{BAGL_RECTANGLE, 0x00, 3,   1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* top right bar */
        {{BAGL_RECTANGLE, 0x00, 113, 1,  12,  2,  0, 0, BAGL_FILL, 0xFFFFFF, 0x000000, 0,            0},                    NULL,      0, 0, 0, NULL, NULL, NULL,},
        /* center text */
	{	{	BAGL_LABELINE, 0x02, 0, 20, 128, 11, 0, 0, 0, 0xFFFFFF, 0x000000, DEFAULT_FONT, 0 }, "Deny Tx", 0, 0, 0, NULL, NULL, NULL, },
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},   NULL,      0, 0, 0, NULL, NULL, NULL,},
        {{BAGL_ICON,      0x00, 117, 13, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN}, NULL,      0, 0, 0, NULL, NULL, NULL,},
/* */
};

/**
 * buttons for the bottom "Deny Transaction" screen
 *
 * up on Left button, down on right button, deny on both buttons.
 */
static unsigned int bagl_ui_deny_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_deny(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

/** UI struct for the transaction description screen, Nano S. */
static const bagl_element_t bagl_ui_tx_desc_nanos_1[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0,         0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                    NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* screen 1 number */
        {{BAGL_LABELINE,  0x02, 0,   10, 20,  11, 0x80 | 10, 0, 0,         0xFFFFFF, 0x000000,
                                                                                               TX_DESC_FONT, 0},                    "1/3",           0, 0, 0, NULL, NULL, NULL,},
        /* first line of description of current screen */
        {{BAGL_LABELINE,  0x02, 10,  15, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[0], 0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current screen */
        {{BAGL_LABELINE,  0x02, 10,  26, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[1], 0, 0, 0, NULL, NULL, NULL,},
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},   NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* right icon is down arrow */
        {{BAGL_ICON,      0x00, 117, 13, 8,   6,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN}, NULL,            0, 0, 0, NULL, NULL, NULL,},
/* */
};

/** UI struct for the transaction description screen, Nano S. */
static const bagl_element_t bagl_ui_tx_desc_nanos_2[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0,         0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                    NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* screen 2 number */
        {{BAGL_LABELINE,  0x02, 0,   10, 20,  11, 0x80 | 10, 0, 0,         0xFFFFFF, 0x000000,
                                                                                               TX_DESC_FONT, 0},                    "2/3",           0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current screen */
        {{BAGL_LABELINE,  0x02, 10,  15, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[2], 0, 0, 0, NULL, NULL, NULL,},
        /* third line of description of current screen  */
        {{BAGL_LABELINE,  0x02, 10,  26, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[3], 0, 0, 0, NULL, NULL, NULL,},
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},   NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* right icon is down arrow */
        {{BAGL_ICON,      0x00, 117, 13, 8,   6,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN}, NULL,            0, 0, 0, NULL, NULL, NULL,},
/* */
};

/** UI struct for the transaction description screen, Nano S. */
static const bagl_element_t bagl_ui_tx_desc_nanos_3[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0,         0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                    NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* screen 2 number */
        {{BAGL_LABELINE,  0x02, 0,   10, 20,  11, 0x80 | 10, 0, 0,         0xFFFFFF, 0x000000,
                                                                                               TX_DESC_FONT, 0},                    "3/3",           0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current screen */
        {{BAGL_LABELINE,  0x02, 10,  15, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[3], 0, 0, 0, NULL, NULL, NULL,},
        /* third line of description of current screen  */
        {{BAGL_LABELINE,  0x02, 10,  26, 108, 11, 0x80 |
                                                  10,        0, 0,         0xFFFFFF, 0x000000, TX_DESC_FONT, 0},                    curr_tx_desc[4], 0, 0, 0, NULL, NULL, NULL,},
        /* left icon is up arrow  */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_UP},   NULL,            0, 0, 0, NULL, NULL, NULL,},
        /* right icon is down arrow */
        {{BAGL_ICON,      0x00, 117, 13, 8,   6,  0,         0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_DOWN}, NULL,            0, 0, 0, NULL, NULL, NULL,},
/* */
};

/**
 * buttons for the transaction description screen
 *
 * up on Left button, down on right button.
 */
static unsigned int bagl_ui_tx_desc_nanos_1_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

/**
 * buttons for the transaction description screen
 *
 * up on Left button, down on right button.
 */
static unsigned int bagl_ui_tx_desc_nanos_2_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

static unsigned int bagl_ui_tx_desc_nanos_3_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
}

/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
    // Go back to the dashboard
    os_sched_exit(0);
    return NULL; // do not redraw the widget
}

/** copy the current row of the tx_desc buffer into curr_tx_desc to display on the screen */
static void copy_tx_desc(void) {
    os_memmove(curr_tx_desc, tx_desc[curr_scr_ix], CURR_TX_DESC_LEN);
    curr_tx_desc[0][MAX_TX_TEXT_WIDTH - 1] = '\0';
    curr_tx_desc[1][MAX_TX_TEXT_WIDTH - 1] = '\0';
    curr_tx_desc[2][MAX_TX_TEXT_WIDTH - 1] = '\0';
}

/** processes the Up button */
static const bagl_element_t *tx_desc_up(const bagl_element_t *e) {
    switch (uiState) {
        case UI_TOP_SIGN:
            ui_deny();
            break;
        case UI_TX_DESC_1:
            ui_top_sign();
            break;

        case UI_TX_DESC_2:
            ui_display_tx_desc_1();
            break;

        case UI_TX_DESC_3:
            ui_display_tx_desc_2();
            break;

        case UI_SIGN:
            ui_display_tx_desc_3();
            break;
        case UI_DENY:
            ui_sign();
            break;

        default:
            hashTainted = 1;
            THROW(0x6D02);
            break;
    }
    return NULL;
}

/** processes the Down button */
static const bagl_element_t *tx_desc_dn(const bagl_element_t *e) {
    switch (uiState) {
        case UI_TOP_SIGN:
            ui_display_tx_desc_1();
            break;

        case UI_TX_DESC_1:
            ui_display_tx_desc_2();
            break;

        case UI_TX_DESC_2:
            ui_display_tx_desc_3();
            break;

        case UI_TX_DESC_3:
            ui_sign();
            break;

        case UI_SIGN:
            ui_deny();
            break;

        case UI_DENY:
            ui_top_sign();
            break;

        default:
            hashTainted = 1;
            THROW(0x6D01);
            break;
    }
    return NULL;
}

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t *io_seproxyhal_touch_approve(const bagl_element_t *e) {
    unsigned int tx = 0;

    if (G_io_apdu_buffer[2] == P1_LAST) {
        unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
        // Update and sign the hash
        cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL);

        unsigned char *bip44_in = raw_tx + raw_tx_len_except_bip44;

        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
        unsigned int bip44_path[BIP44_PATH_LEN];
        uint32_t i;
        for (i = 0; i < BIP44_PATH_LEN; i++) {
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
            bip44_in += 4;
        }

        unsigned char privateKeyData[32];
        os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);

        cx_ecfp_private_key_t privateKey;
        cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);

        // Hash is finalized, send back the signature
        unsigned char tmp[32];
        unsigned char result[32];

        cx_hash(&hash.header, CX_LAST, raw_tx, 0, tmp);

        cx_sha256_init(&hash);
        cx_hash(&hash.header, CX_LAST, tmp, 32, tmp);

        cx_sha256_init(&hash);
        cx_hash(&hash.header, CX_LAST, tmp, 32, result);
#if CX_APILEVEL >= 8
        tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer, NULL);
#else
		tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer);
#endif
        // G_io_apdu_buffer[0] &= 0xF0; // discard the parity information
        hashTainted = 1;
#ifndef TARGET_NANOS
        clear_tx_desc();
#endif
        raw_tx_ix = 0;
        raw_tx_len = 0;

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
        G_io_apdu_buffer[tx++] = 0xFF;
        for (int ix = 0; ix < 32; ix++) {
            G_io_apdu_buffer[tx++] = tmp[ix];
        }
    }
    G_io_apdu_buffer[tx++] = 0x90;
    G_io_apdu_buffer[tx++] = 0x00;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
    hashTainted = 1;
#ifndef TARGET_NANOS
        clear_tx_desc();
#endif    raw_tx_ix = 0;
    raw_tx_len = 0;
    G_io_apdu_buffer[0] = 0x69;
    G_io_apdu_buffer[1] = 0x85;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

static unsigned int bagl_ui_idle_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_public_key_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

/** show the public key screen */
void ui_public_key_1(void) {
    uiState = UI_PUBLIC_KEY_1;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
    } else {
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
    }
}

/** show the public key screen */
void ui_public_key_2(void) {
    uiState = UI_PUBLIC_KEY_2;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
    } else {
        UX_DISPLAY(bagl_ui_public_key_nanos_2, NULL);
    }
}

/** show the idle screen. */
void ui_idle(void) {
    uiState = UI_IDLE;

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_idle_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
#elif defined(TARGET_NANOX)
    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_idle_flow, NULL);
#endif // #if TARGET_ID
}

/** show the transaction description screen. */
static void ui_display_tx_desc_1(void) {
    uiState = UI_TX_DESC_1;
#if defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_tx_desc_nanos_1, NULL);
#endif // #if TARGET_ID
}


/** show the transaction description screen. */
static void ui_display_tx_desc_2(void) {
    uiState = UI_TX_DESC_2;
#if defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_tx_desc_nanos_2, NULL);
#endif // #if TARGET_ID
}

/** show the transaction description screen. */
static void ui_display_tx_desc_3(void) {
    uiState = UI_TX_DESC_3;
#if defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_tx_desc_nanos_3, NULL);
#endif // #if TARGET_ID
}

/** show the bottom "Sign Transaction" screen. */
static void ui_sign(void) {
    uiState = UI_SIGN;
#if defined(TARGET_NANOS)
    UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
#endif // #if TARGET_ID
}

/** show the top "Sign Transaction" screen. */
void ui_top_sign(void) {
    uiState = UI_TOP_SIGN;

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
#elif defined(TARGET_NANOX)
    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}

/** show the "deny" screen */
static void ui_deny(void) {
    uiState = UI_DENY;
#if defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_deny_nanos, NULL);
#endif // #if TARGET_ID
}

/** returns the length of the transaction in the buffer. */
unsigned int get_apdu_buffer_length() {
    unsigned int len0 = G_io_apdu_buffer[APDU_BODY_LENGTH_OFFSET];
    return len0;
}

/** set the blue menu bar colour */
void ui_set_menu_bar_colour(void) {
#if defined(TARGET_BLUE)
    UX_SET_STATUS_BAR_COLOR(COLOUR_WHITE, COLOUR_ONT_GREEN);
    clear_tx_desc();
#endif // #if TARGET_ID
}

/** sets the tx_desc variables to no information */
static void clear_tx_desc(void) {
    for(uint8_t i=0; i<MAX_TX_TEXT_SCREENS; i++) {
        for(uint8_t j=0; j<MAX_TX_TEXT_LINES; j++) {
            tx_desc[i][j][0] = '\0';
            tx_desc[i][j][MAX_TX_TEXT_WIDTH - 1] = '\0';
        }
    }
    
    strncpy(tx_desc[1][0], NO_INFO, sizeof(NO_INFO));
    strncpy(tx_desc[2][0], NO_INFO, sizeof(NO_INFO));
}

/** returns to dashboard */
static const bagl_element_t *bagl_ui_DASHBOARD_blue_button(const bagl_element_t *e)
{
    os_sched_exit(0);
    return NULL;
}

/** goes to settings menu (pubkey display) on blue */
static const bagl_element_t *bagl_ui_SETTINGS_blue_button(const bagl_element_t *e)
{
    UX_DISPLAY(bagl_ui_public_key_blue, NULL);
    return NULL;
}

/** returns to ONT app on blue */
static const bagl_element_t *bagl_ui_LEFT_blue_button(const bagl_element_t *e)
{
    ui_idle();
    return NULL;
}
