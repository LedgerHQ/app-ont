#pragma once

#include <stdbool.h>  // bool
#include "../transaction/tx_types.h"
#include "nbgl_use_case.h"

#if defined(TARGET_NANOX) || defined(TARGET_NANOS2)
#define ICON_APP_ONTOLOGY    C_app_ont14px
#define ICON_APP_WARNING     C_icon_warning
#elif defined(TARGET_STAX)
#define ICON_APP_ONTOLOGY    C_app_ont32px
#define ICON_APP_WARNING     C_Warning_64px
#elif defined(TARGET_FLEX)
#define ICON_APP_ONTOLOGY    C_app_ont40px
#define ICON_APP_WARNING     C_Warning_64px
#elif defined(TARGET_APEX_P)
#define ICON_APP_ONTOLOGY    C_app_ont_32px
#define ICON_APP_WARNING     C_Warning_48px
#endif

#define NUM_PAIRS          (PARAMETERS_MAX_NUM + 2)  // gas fee and signer
#define MAX_BUFFER_LEN     67

extern nbgl_contentTagValue_t g_pairs[NUM_PAIRS];
extern nbgl_contentTagValueList_t g_pairList;

// g_buffers[(PARAMETERS_MAX_NUM + 1)* MAX_BUFFER_LEN]: signer
extern char g_buffers[NUM_PAIRS * MAX_BUFFER_LEN];

/**
 * Callback to reuse action with approve/reject in step FLOW.
 */
typedef void (*action_validate_cb)(bool);

/**
 * Display address on the device and ask confirmation to export.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_address(void);

/**
 * Display transaction information on the device and ask confirmation to sign.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_transaction(bool is_blind_signed);
/**
 * Display personal msg information on the device and ask confirmation to sign.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_message(void);



