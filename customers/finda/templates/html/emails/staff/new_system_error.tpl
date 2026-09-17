System error
=============================================
Date: {$error.created|date_format:"%c"}
Type: {$error.type}
Message: {$error.details.response.actualError}
Details:
{$error.details|print_r}