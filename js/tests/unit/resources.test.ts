import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { HttpClient } from '@runapi.ai/core';
import { Generations } from '../../src/resources/generations';
import { Edits } from '../../src/resources/edits';
import { Remixes } from '../../src/resources/remixes';

describe('Ideogram V3 resources', () => {
  const mockHttp: HttpClient = { request: vi.fn() };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('generations.create sends POST to /api/v1/ideogram_v3/generations', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-1' });

    const generations = new Generations(mockHttp);
    await generations.create({
      model: 'ideogram-v3-text-to-image',
      prompt: 'A cat',
      rendering_speed: 'BALANCED',
      image_size: 'square_hd',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/generations', {
      body: {
        model: 'ideogram-v3-text-to-image',
        prompt: 'A cat',
        rendering_speed: 'BALANCED',
        image_size: 'square_hd',
      },
    });
  });

  it('edits.create sends image_url and mask_url', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-2' });

    const edits = new Edits(mockHttp);
    await edits.create({
      model: 'ideogram-v3-edit',
      prompt: 'Cowboy hat',
      image_url: 'https://x/a.png',
      mask_url: 'https://x/m.png',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/edits', {
      body: {
        model: 'ideogram-v3-edit',
        prompt: 'Cowboy hat',
        image_url: 'https://x/a.png',
        mask_url: 'https://x/m.png',
      },
    });
  });

  it('remixes.create sends num_images and strength', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-3' });

    const remixes = new Remixes(mockHttp);
    await remixes.create({
      model: 'ideogram-v3-remix',
      prompt: 'Remix',
      image_url: 'https://x/i.png',
      num_images: '2',
      strength: 0.8,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/remixes', {
      body: {
        model: 'ideogram-v3-remix',
        prompt: 'Remix',
        image_url: 'https://x/i.png',
        num_images: '2',
        strength: 0.8,
      },
    });
  });

  it('generations.get sends GET to /api/v1/ideogram_v3/generations/:id', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-1', status: 'completed', images: [{ url: 'x' }] });

    const generations = new Generations(mockHttp);
    await generations.get('task-1');

    expect(mockHttp.request).toHaveBeenCalledWith('GET', '/api/v1/ideogram_v3/generations/task-1', {});
  });
});
