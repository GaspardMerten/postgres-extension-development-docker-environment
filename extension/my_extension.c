#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(hello_world);

Datum
hello_world(PG_FUNCTION_ARGS)
{
    // Use cstring_to_text_with_len in PG16
    const char *msg = "Hello from my_extension!";
    text *result = cstring_to_text_with_len(msg, strlen(msg));
    PG_RETURN_TEXT_P(result);
}
