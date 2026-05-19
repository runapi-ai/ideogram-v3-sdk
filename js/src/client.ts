import { createHttpClient, type ClientOptions } from '@runapi.ai/core';
import { TextToImage } from './resources/text-to-image';
import { EditImage } from './resources/edit-image';
import { RemixImage } from './resources/remix-image';

/**
 * Ideogram V3 text-to-image API client.
 *
 * @example
 * ```typescript
 * const client = new IdeogramV3Client({ apiKey: 'your-api-key' });
 *
 * const result = await client.textToImage.run({
 *   model: 'ideogram-v3-text-to-image',
 *   prompt: 'A cinematic lakeside at twilight',
 * });
 * ```
 */
export class IdeogramV3Client {
  /** Text-to-image operations (`ideogram-v3-text-to-image`). */
  public readonly textToImage: TextToImage;
  /** Inpaint-with-mask operations (`ideogram-v3-edit`). */
  public readonly editImage: EditImage;
  /** Image remix operations (`ideogram-v3-remix`). */
  public readonly remixImage: RemixImage;

  constructor(options: ClientOptions = {}) {
    const http = createHttpClient(options);
    this.textToImage = new TextToImage(http);
    this.editImage = new EditImage(http);
    this.remixImage = new RemixImage(http);
  }
}
