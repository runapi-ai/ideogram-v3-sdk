import type { HttpClient, RequestOptions, PollingOptions } from '@runapi.ai/core';
import { compactParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import type {
  CompletedIdeogramV3Response,
  GenerationParams,
  IdeogramV3Response,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/ideogram_v3/generations';

export class Generations {
  constructor(private readonly http: HttpClient) {}

  async run(params: GenerationParams, options?: RequestOptions & PollingOptions): Promise<CompletedIdeogramV3Response> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<IdeogramV3Response>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedIdeogramV3Response;
  }

  async create(params: GenerationParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body: compactParams(params),
      ...options,
    });
  }

  async get(id: string, options?: RequestOptions): Promise<IdeogramV3Response> {
    return this.http.request<IdeogramV3Response>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
