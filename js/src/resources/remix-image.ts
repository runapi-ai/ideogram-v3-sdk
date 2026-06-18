import type { HttpClient, RequestOptions, PollingOptions } from '@runapi.ai/core';
import { compactParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import type {
  CompletedIdeogramV3Response,
  IdeogramV3Response,
  RemixImageParams,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/ideogram_v3/remix_image';

/** Creates a variation of a source image guided by a new text prompt. */
export class RemixImage {
  constructor(private readonly http: HttpClient) {}

  /**
   * Create a variation of a source image guided by a new text prompt and wait until complete.
   * @param params Remix-image parameters.
   * @param options Per-request and polling overrides.
   * @returns The completed task with images.
   */
  async run(params: RemixImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedIdeogramV3Response> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<IdeogramV3Response>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedIdeogramV3Response;
  }

  /**
   * Create a variation of a source image guided by a new text prompt; returns immediately with a task id.
   * @param params Remix-image parameters.
   * @param options Per-request overrides.
   * @returns The task creation result with id.
   */
  async create(params: RemixImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body: compactParams(params),
      ...options,
    });
  }

  /**
   * Fetch the current status of a remix-image task.
   * @param id The task id.
   * @param options Per-request overrides.
   * @returns The current remix-image task status.
   */
  async get(id: string, options?: RequestOptions): Promise<IdeogramV3Response> {
    return this.http.request<IdeogramV3Response>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
