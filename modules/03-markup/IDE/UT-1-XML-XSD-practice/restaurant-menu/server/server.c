#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <microhttpd.h>

#include <libxml/parser.h>
#include <libxml/xmlschemas.h>

#define PORT 8080
#define MAX_XML_SIZE (1024 * 1024)

#define XSD_PATH "../schemas/menu.xsd"

struct request_data {
    char *body;
    size_t size;
    int too_large;
};

/*
 * Validate XML content held in memory against an XSD file.
 *
 * Return values:
 *   0  = valid XML
 *   1  = XML is invalid
 *  -1  = internal validation error
 */
static int validate_xml_memory(
    const char *xml_data,
    size_t xml_size,
    const char *xsd_file
) {
    xmlDocPtr document = NULL;
    xmlSchemaParserCtxtPtr schema_parser = NULL;
    xmlSchemaPtr schema = NULL;
    xmlSchemaValidCtxtPtr validation_context = NULL;

    int result = -1;

    if (xml_data == NULL || xml_size == 0 || xml_size > INT_MAX) {
        return -1;
    }

    document = xmlReadMemory(
        xml_data,
        (int)xml_size,
        "request.xml",
        NULL,
        XML_PARSE_NONET
    );

    if (document == NULL) {
        fprintf(stderr, "Could not parse XML request\n");
        goto cleanup;
    }

    schema_parser = xmlSchemaNewParserCtxt(xsd_file);

    if (schema_parser == NULL) {
        fprintf(stderr, "Could not create schema parser\n");
        goto cleanup;
    }

    schema = xmlSchemaParse(schema_parser);

    if (schema == NULL) {
        fprintf(stderr, "Could not parse XSD schema\n");
        goto cleanup;
    }

    validation_context = xmlSchemaNewValidCtxt(schema);

    if (validation_context == NULL) {
        fprintf(stderr, "Could not create validation context\n");
        goto cleanup;
    }

    result = xmlSchemaValidateDoc(
        validation_context,
        document
    );

    if (result == 0) {
        printf("XML is valid\n");
    } else if (result > 0) {
        printf("XML is invalid\n");
    } else {
        fprintf(stderr, "Validation internal error\n");
    }

cleanup:

    if (validation_context != NULL) {
        xmlSchemaFreeValidCtxt(validation_context);
    }

    if (schema != NULL) {
        xmlSchemaFree(schema);
    }

    if (schema_parser != NULL) {
        xmlSchemaFreeParserCtxt(schema_parser);
    }

    if (document != NULL) {
        xmlFreeDoc(document);
    }

    return result;
}

/*
 * Queue an HTTP response.
 */
static enum MHD_Result send_response(
    struct MHD_Connection *connection,
    unsigned int status_code,
    const char *message
) {
    struct MHD_Response *response;

    response = MHD_create_response_from_buffer(
        strlen(message),
        (void *)message,
        MHD_RESPMEM_MUST_COPY
    );

    if (response == NULL) {
        return MHD_NO;
    }

    MHD_add_response_header(
        response,
        "Content-Type",
        "text/plain; charset=utf-8"
    );

    enum MHD_Result result = MHD_queue_response(
        connection,
        status_code,
        response
    );

    MHD_destroy_response(response);

    return result;
}

/*
 * Free per-request memory after the request has completed.
 */
static void request_completed(
    void *cls,
    struct MHD_Connection *connection,
    void **con_cls,
    enum MHD_RequestTerminationCode toe
) {
    struct request_data *request = *con_cls;

    (void)cls;
    (void)connection;
    (void)toe;

    if (request != NULL) {
        free(request->body);
        free(request);
        *con_cls = NULL;
    }
}

/*
 * HTTP access handler.
 */
static enum MHD_Result access_handler(
    void *cls,
    struct MHD_Connection *connection,
    const char *url,
    const char *method,
    const char *version,
    const char *upload_data,
    size_t *upload_data_size,
    void **con_cls
) {
    struct request_data *request;

    (void)cls;
    (void)version;

    /*
     * Only accept POST /api/menu.
     */
    if (strcmp(url, "/api/menu") != 0) {
        return send_response(
            connection,
            MHD_HTTP_NOT_FOUND,
            "Route not found"
        );
    }

    if (strcmp(method, "POST") != 0) {
        return send_response(
            connection,
            MHD_HTTP_METHOD_NOT_ALLOWED,
            "Only POST is supported"
        );
    }

    /*
     * First call: initialize request context.
     */
    if (*con_cls == NULL) {
        request = calloc(1, sizeof(*request));

        if (request == NULL) {
            return send_response(
                connection,
                MHD_HTTP_INTERNAL_SERVER_ERROR,
                "Could not allocate request context"
            );
        }

        *con_cls = request;

        return MHD_YES;
    }

    request = *con_cls;

    /*
     * Receive a chunk of the HTTP request body.
     */
    if (*upload_data_size > 0) {
        size_t incoming_size = *upload_data_size;

        if (incoming_size > MAX_XML_SIZE - request->size) {
            request->too_large = 1;
            *upload_data_size = 0;

            return MHD_YES;
        }

        char *new_body = realloc(
            request->body,
            request->size + incoming_size + 1
        );

        if (new_body == NULL) {
            return send_response(
                connection,
                MHD_HTTP_INTERNAL_SERVER_ERROR,
                "Could not allocate request body"
            );
        }

        request->body = new_body;

        memcpy(
            request->body + request->size,
            upload_data,
            incoming_size
        );

        request->size += incoming_size;
        request->body[request->size] = '\0';

        /*
         * Tell libmicrohttpd this chunk has been consumed.
         */
        *upload_data_size = 0;

        return MHD_YES;
    }

    /*
     * All request-body chunks have been received.
     */
    if (request->too_large) {
        return send_response(
            connection,
            MHD_HTTP_PAYLOAD_TOO_LARGE,
            "XML request is too large"
        );
    }

    if (request->body == NULL || request->size == 0) {
        return send_response(
            connection,
            MHD_HTTP_BAD_REQUEST,
            "Empty XML request"
        );
    }

    int validation_result = validate_xml_memory(
        request->body,
        request->size,
        XSD_PATH
    );

    if (validation_result == 0) {
        return send_response(
            connection,
            MHD_HTTP_OK,
            "Menu accepted: XML is valid"
        );
    }

    if (validation_result > 0) {
        return send_response(
            connection,
            MHD_HTTP_BAD_REQUEST,
            "Invalid XML: does not match menu.xsd"
        );
    }

    return send_response(
        connection,
        MHD_HTTP_INTERNAL_SERVER_ERROR,
        "Internal XML validation error"
    );
}

int main(void) {
    struct MHD_Daemon *daemon;

    /*
     * Initialize libxml2.
     */
    xmlInitParser();

    /*
     * Start HTTP server.
     */
    daemon = MHD_start_daemon(
        MHD_USE_INTERNAL_POLLING_THREAD,
        PORT,
        NULL,
        NULL,
        &access_handler,
        NULL,
        MHD_OPTION_NOTIFY_COMPLETED,
        &request_completed,
        NULL,
        MHD_OPTION_END
    );

    if (daemon == NULL) {
        fprintf(stderr, "Could not start HTTP server\n");
        xmlCleanupParser();
        return EXIT_FAILURE;
    }

    printf("Restaurant server listening on port %d\n", PORT);
    printf("Endpoint: POST http://localhost:%d/api/menu\n", PORT);
    printf("Press Enter to stop the server...\n");

    getchar();

    MHD_stop_daemon(daemon);
    xmlCleanupParser();

    return EXIT_SUCCESS;
}