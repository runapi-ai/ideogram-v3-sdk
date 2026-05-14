import type { AsyncTaskStatus } from '@runapi.ai/core';

export type IdeogramV3Model =
  | 'ideogram-v3-text-to-image'
  | 'ideogram-v3-edit'
  | 'ideogram-v3-remix';

export type RenderingSpeed = 'TURBO' | 'BALANCED' | 'QUALITY';
export type IdeogramStyle = 'AUTO' | 'GENERAL' | 'REALISTIC' | 'DESIGN';
export type ImageSize =
  | 'square'
  | 'square_hd'
  | 'portrait_4_3'
  | 'portrait_16_9'
  | 'landscape_4_3'
  | 'landscape_16_9';
export type NumImages = '1' | '2' | '3' | '4';

export interface GenerationParams {
  model: 'ideogram-v3-text-to-image';
  prompt: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle;
  expand_prompt?: boolean;
  image_size?: ImageSize;
  seed?: number;
  negative_prompt?: string;
}

export interface EditParams {
  model: 'ideogram-v3-edit';
  prompt: string;
  image_url: string;
  mask_url: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  expand_prompt?: boolean;
  seed?: number;
}

export interface RemixParams {
  model: 'ideogram-v3-remix';
  prompt: string;
  image_url: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle;
  expand_prompt?: boolean;
  image_size?: ImageSize;
  num_images?: NumImages;
  seed?: number;
  strength?: number;
  negative_prompt?: string;
}

export interface TaskCreateResponse {
  id: string;
}

export interface Image {
  url: string;
}

export interface IdeogramV3Response {
  id: string;
  status: AsyncTaskStatus;
  images?: Image[];
  error?: string;
  [key: string]: unknown;
}

/**
 * Resolved response returned by the `run()` method after polling sees
 * `status: 'completed'`. Narrows the base response so `images` is
 * guaranteed non-optional in user code.
 */
export type CompletedIdeogramV3Response = IdeogramV3Response & {
  status: 'completed';
  images: Image[];
};
