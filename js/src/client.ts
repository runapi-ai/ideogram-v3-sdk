import { createHttpClient, type ClientOptions } from '@runapi.ai/core';
import { Generations } from './resources/generations';
import { Edits } from './resources/edits';
import { Remixes } from './resources/remixes';

/**
 * Ideogram V3 image generation API client.
 *
 * @example
 * ```typescript
 * const client = new IdeogramV3Client({ apiKey: 'your-api-key' });
 *
 * const result = await client.generations.run({
 *   model: 'ideogram-v3-text-to-image',
 *   prompt: 'A cinematic lakeside at twilight',
 * });
 * ```
 */
export class IdeogramV3Client {
  /** Text-to-image operations (`ideogram-v3-text-to-image`). */
  public readonly generations: Generations;
  /** Inpaint-with-mask operations (`ideogram-v3-edit`). */
  public readonly edits: Edits;
  /** Image remix operations (`ideogram-v3-remix`). */
  public readonly remixes: Remixes;

  constructor(options: ClientOptions = {}) {
    const http = createHttpClient(options);
    this.generations = new Generations(http);
    this.edits = new Edits(http);
    this.remixes = new Remixes(http);
  }
}
