import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { HttpClient } from '@runapi.ai/core';
import { TextToImage } from '../../src/resources/text-to-image';
import { EditImage } from '../../src/resources/edit-image';
import { RemixImage } from '../../src/resources/remix-image';

describe('Ideogram V3 resources', () => {
  const mockHttp: HttpClient = { request: vi.fn() };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('textToImage.create sends POST to /api/v1/ideogram_v3/text_to_image', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-1' });

    const textToImage = new TextToImage(mockHttp);
    await textToImage.create({
      model: 'ideogram-v3-text-to-image',
      prompt: 'A cat',
      rendering_speed: 'BALANCED',
      image_size: 'square_hd',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/text_to_image', {
      body: {
        model: 'ideogram-v3-text-to-image',
        prompt: 'A cat',
        rendering_speed: 'BALANCED',
        image_size: 'square_hd',
      },
    });
  });

  it('editImage.create sends image_url and mask_url', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-2' });

    const editImage = new EditImage(mockHttp);
    await editImage.create({
      model: 'ideogram-v3-edit',
      prompt: 'Cowboy hat',
      image_url: 'https://x/a.png',
      mask_url: 'https://x/m.png',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/edit_image', {
      body: {
        model: 'ideogram-v3-edit',
        prompt: 'Cowboy hat',
        image_url: 'https://x/a.png',
        mask_url: 'https://x/m.png',
      },
    });
  });

  it('remixImage.create sends num_images and strength', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-3' });

    const remixImage = new RemixImage(mockHttp);
    await remixImage.create({
      model: 'ideogram-v3-remix',
      prompt: 'Remix',
      image_url: 'https://x/i.png',
      num_images: '2',
      strength: 0.8,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/remix_image', {
      body: {
        model: 'ideogram-v3-remix',
        prompt: 'Remix',
        image_url: 'https://x/i.png',
        num_images: '2',
        strength: 0.8,
      },
    });
  });

  it('textToImage.get sends GET to /api/v1/ideogram_v3/text_to_image/:id', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-1', status: 'completed', images: [{ url: 'x' }] });

    const textToImage = new TextToImage(mockHttp);
    await textToImage.get('task-1');

    expect(mockHttp.request).toHaveBeenCalledWith('GET', '/api/v1/ideogram_v3/text_to_image/task-1', {});
  });
});
