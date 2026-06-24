import type { HttpClient, RequestOptions, PollingOptions, ActionSchema } from '@runapi.ai/core';
import { compactParams, validateParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import { contract } from '../contract_gen';
import type {
  CompletedIdeogramV3Response,
  IdeogramV3Response,
  ReframeImageParams,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/ideogram_v3/reframe_image';

/** Extends or crops an image to a new aspect ratio without regenerating content. */
export class ReframeImage {
  constructor(private readonly http: HttpClient) {}

  /**
   * Extend or crop an image to a new aspect ratio without regenerating content and wait until complete.
   * @param params Reframe-image parameters.
   * @param options Per-request and polling overrides.
   * @returns The completed task with images.
   */
  async run(params: ReframeImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedIdeogramV3Response> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<IdeogramV3Response>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedIdeogramV3Response;
  }

  /**
   * Extend or crop an image to a new aspect ratio without regenerating content; returns immediately with a task id.
   * @param params Reframe-image parameters.
   * @param options Per-request overrides.
   * @returns The task creation result with id.
   */
  async create(params: ReframeImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    const body = compactParams(params);
    validateParams(contract['reframe-image'] as ActionSchema, body as Record<string, unknown>);
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body,
      ...options,
    });
  }

  /**
   * Fetch the current status of a reframe-image task.
   * @param id The task id.
   * @param options Per-request overrides.
   * @returns The current reframe-image task status.
   */
  async get(id: string, options?: RequestOptions): Promise<IdeogramV3Response> {
    return this.http.request<IdeogramV3Response>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
