package ai.runapi.ideogramv3.resources;

import ai.runapi.core.ClientOptions;
import ai.runapi.core.RequestOptions;
import ai.runapi.core.http.HttpTransport;
import ai.runapi.core.polling.TaskCreateResponse;
import ai.runapi.ideogramv3.types.CompletedRemixImageResponse;
import ai.runapi.ideogramv3.types.RemixImageParams;
import ai.runapi.ideogramv3.types.RemixImageResponse;

/** Remix Image operations. */
public final class RemixImageResource extends Ideogramv3Resource {
  /** API endpoint path for remix image operations. */
  public static final String ENDPOINT = "/api/v1/ideogram_v3/remix_image";

  /** Creates a resource bound to the supplied transport and client options. */
  public RemixImageResource(HttpTransport transport, ClientOptions options) {
    super(transport, options, ENDPOINT);
  }

  /** Creates a remix image task. */
  public TaskCreateResponse create(RemixImageParams params) {
    return create(params, RequestOptions.none());
  }

  /** Creates a remix image task with per-request options. */
  public TaskCreateResponse create(RemixImageParams params, RequestOptions options) {
    return createTask(params.action(), params.toMap(), options);
  }

  /** Retrieves a remix image task by ID. */
  public RemixImageResponse get(String id) {
    return get(id, RequestOptions.none());
  }

  /** Retrieves a remix image task by ID with per-request options. */
  public RemixImageResponse get(String id, RequestOptions options) {
    return getTask(id, options, RemixImageResponse.class);
  }

  /** Creates a remix image task and polls until it completes. */
  public CompletedRemixImageResponse run(RemixImageParams params) {
    return run(params, RequestOptions.none());
  }

  /** Creates a remix image task with per-request options and polls until it completes. */
  public CompletedRemixImageResponse run(RemixImageParams params, RequestOptions options) {
    return runTask(params.action(), params.toMap(), options, RemixImageResponse.class, CompletedRemixImageResponse.class);
  }
}
