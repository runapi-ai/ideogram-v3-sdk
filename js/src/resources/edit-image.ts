import type { HttpClient, RequestOptions, PollingOptions, ActionSchema } from '@runapi.ai/core';
import { compactParams, validateParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import { contract } from '../contract_gen';
import type {
  CompletedIdeogramV3Response,
  EditImageParams,
  IdeogramV3Response,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/ideogram_v3/edit_image';

/** Inpaints a source image using a mask to define the regenerated region. */
export class EditImage {
  constructor(private readonly http: HttpClient) {}

  /**
   * Inpaint an image using a mask to define the regenerated region and wait until complete.
   * @param params Edit-image parameters.
   * @param options Per-request and polling overrides.
   * @returns The completed task with images.
   */
  async run(params: EditImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedIdeogramV3Response> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<IdeogramV3Response>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedIdeogramV3Response;
  }

  /**
   * Inpaint an image using a mask to define the regenerated region; returns immediately with a task id.
   * @param params Edit-image parameters.
   * @param options Per-request overrides.
   * @returns The task creation result with id.
   */
  async create(params: EditImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    const body = compactParams(params);
    validateParams(contract['edit-image'] as ActionSchema, body as Record<string, unknown>);
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body,
      ...options,
    });
  }

  /**
   * Fetch the current status of an edit-image task.
   * @param id The task id.
   * @param options Per-request overrides.
   * @returns The current edit-image task status.
   */
  async get(id: string, options?: RequestOptions): Promise<IdeogramV3Response> {
    return this.http.request<IdeogramV3Response>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
