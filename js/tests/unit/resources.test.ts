import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { HttpClient } from '@runapi.ai/core';
import { TextToImage } from '../../src/resources/text-to-image';
import { EditImage } from '../../src/resources/edit-image';
import { RemixImage } from '../../src/resources/remix-image';
import { ReframeImage } from '../../src/resources/reframe-image';

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
      rendering_speed: 'balanced',
      aspect_ratio: '1:1',
      output_count: 2,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/text_to_image', {
      body: {
        model: 'ideogram-v3-text-to-image',
        prompt: 'A cat',
        rendering_speed: 'balanced',
        aspect_ratio: '1:1',
        output_count: 2,
      },
    });
  });

  it('textToImage.create can send character reference images', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-character' });

    const textToImage = new TextToImage(mockHttp);
    await textToImage.create({
      model: 'ideogram-v3-character',
      prompt: 'A character in a garden',
      reference_image_urls: ['https://x/ref.webp'],
      style: 'fiction',
      output_count: 2,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/text_to_image', {
      body: {
        model: 'ideogram-v3-character',
        prompt: 'A character in a garden',
        reference_image_urls: ['https://x/ref.webp'],
        style: 'fiction',
        output_count: 2,
      },
    });
  });

  it('editImage.create sends source_image_url and mask_url', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-2' });

    const editImage = new EditImage(mockHttp);
    await editImage.create({
      model: 'ideogram-v3-edit',
      prompt: 'Cowboy hat',
      source_image_url: 'https://x/a.png',
      mask_url: 'https://x/m.png',
      output_count: 2,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/edit_image', {
      body: {
        model: 'ideogram-v3-edit',
        prompt: 'Cowboy hat',
        source_image_url: 'https://x/a.png',
        mask_url: 'https://x/m.png',
        output_count: 2,
      },
    });
  });

  it('editImage.create can send character reference images', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-character-edit' });

    const editImage = new EditImage(mockHttp);
    await editImage.create({
      model: 'ideogram-v3-character-edit',
      prompt: 'Add a smile',
      source_image_url: 'https://x/a.png',
      mask_url: 'https://x/m.png',
      reference_image_urls: ['https://x/ref.webp'],
      output_count: 2,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/edit_image', {
      body: {
        model: 'ideogram-v3-character-edit',
        prompt: 'Add a smile',
        source_image_url: 'https://x/a.png',
        mask_url: 'https://x/m.png',
        reference_image_urls: ['https://x/ref.webp'],
        output_count: 2,
      },
    });
  });

  it('remixImage.create sends output_count and strength', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-3' });

    const remixImage = new RemixImage(mockHttp);
    await remixImage.create({
      model: 'ideogram-v3-remix',
      prompt: 'Remix',
      source_image_url: 'https://x/i.png',
      output_count: 2,
      strength: 0.8,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/remix_image', {
      body: {
        model: 'ideogram-v3-remix',
        prompt: 'Remix',
        source_image_url: 'https://x/i.png',
        output_count: 2,
        strength: 0.8,
      },
    });
  });

  it('remixImage.create can send character and style references', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-character-remix' });

    const remixImage = new RemixImage(mockHttp);
    await remixImage.create({
      model: 'ideogram-v3-character-remix',
      prompt: 'Restyle this character',
      source_image_url: 'https://x/i.png',
      reference_image_urls: ['https://x/character.webp'],
      style_reference_image_urls: ['https://x/style.webp'],
      reference_mask_urls: ['https://x/mask.webp'],
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/remix_image', {
      body: {
        model: 'ideogram-v3-character-remix',
        prompt: 'Restyle this character',
        source_image_url: 'https://x/i.png',
        reference_image_urls: ['https://x/character.webp'],
        style_reference_image_urls: ['https://x/style.webp'],
        reference_mask_urls: ['https://x/mask.webp'],
      },
    });
  });

  it('reframeImage.create sends POST to /api/v1/ideogram_v3/reframe_image', async () => {
    vi.mocked(mockHttp.request).mockResolvedValueOnce({ id: 'task-reframe' });

    const reframeImage = new ReframeImage(mockHttp);
    await reframeImage.create({
      model: 'ideogram-v3-reframe',
      source_image_url: 'https://x/source.png',
      aspect_ratio: '3:4',
      rendering_speed: 'quality',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/ideogram_v3/reframe_image', {
      body: {
        model: 'ideogram-v3-reframe',
        source_image_url: 'https://x/source.png',
        aspect_ratio: '3:4',
        rendering_speed: 'quality',
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
