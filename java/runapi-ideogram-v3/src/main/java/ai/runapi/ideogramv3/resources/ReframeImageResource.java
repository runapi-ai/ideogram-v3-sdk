package ai.runapi.ideogramv3.resources;

import ai.runapi.core.ClientOptions;
import ai.runapi.core.RequestOptions;
import ai.runapi.core.http.HttpTransport;
import ai.runapi.core.polling.TaskCreateResponse;
import ai.runapi.ideogramv3.types.CompletedReframeImageResponse;
import ai.runapi.ideogramv3.types.ReframeImageParams;
import ai.runapi.ideogramv3.types.ReframeImageResponse;

/** Reframe Image operations. */
public final class ReframeImageResource extends Ideogramv3Resource {
  /** API endpoint path for reframe image operations. */
  public static final String ENDPOINT = "/api/v1/ideogram_v3/reframe_image";

  /** Creates a resource bound to the supplied transport and client options. */
  public ReframeImageResource(HttpTransport transport, ClientOptions options) {
    super(transport, options, ENDPOINT);
  }

  /** Creates a reframe image task. */
  public TaskCreateResponse create(ReframeImageParams params) {
    return create(params, RequestOptions.none());
  }

  /** Creates a reframe image task with per-request options. */
  public TaskCreateResponse create(ReframeImageParams params, RequestOptions options) {
    return createTask(params.action(), params.toMap(), options);
  }

  /** Retrieves a reframe image task by ID. */
  public ReframeImageResponse get(String id) {
    return get(id, RequestOptions.none());
  }

  /** Retrieves a reframe image task by ID with per-request options. */
  public ReframeImageResponse get(String id, RequestOptions options) {
    return getTask(id, options, ReframeImageResponse.class);
  }

  /** Creates a reframe image task and polls until it completes. */
  public CompletedReframeImageResponse run(ReframeImageParams params) {
    return run(params, RequestOptions.none());
  }

  /** Creates a reframe image task with per-request options and polls until it completes. */
  public CompletedReframeImageResponse run(ReframeImageParams params, RequestOptions options) {
    return runTask(params.action(), params.toMap(), options, ReframeImageResponse.class, CompletedReframeImageResponse.class);
  }
}
