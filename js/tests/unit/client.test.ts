import { describe, it, expect, beforeEach, afterAll } from 'vitest';
import { AuthenticationError } from '@runapi.ai/core';
import { IdeogramV3Client } from '../../src';

const originalEnv = process.env.RUNAPI_API_KEY;

describe('IdeogramV3Client', () => {
  beforeEach(() => {
    delete process.env.RUNAPI_API_KEY;
  });

  afterAll(() => {
    if (originalEnv === undefined) {
      delete process.env.RUNAPI_API_KEY;
    } else {
      process.env.RUNAPI_API_KEY = originalEnv;
    }
  });

  it('initializes with an API key', () => {
    const client = new IdeogramV3Client({ apiKey: 'test-key' });
    expect(client.generations).toBeDefined();
    expect(client.edits).toBeDefined();
    expect(client.remixes).toBeDefined();
  });

  it('throws when apiKey missing and env unset', () => {
    expect(() => new IdeogramV3Client()).toThrow(AuthenticationError);
  });

  it('reads apiKey from RUNAPI_API_KEY env var', () => {
    process.env.RUNAPI_API_KEY = 'env-key';
    const client = new IdeogramV3Client();
    expect(client.generations).toBeDefined();
  });

  it('exposes all three resources', () => {
    const client = new IdeogramV3Client({ apiKey: 'test-key' });
    expect(typeof client.generations.create).toBe('function');
    expect(typeof client.edits.create).toBe('function');
    expect(typeof client.remixes.create).toBe('function');
  });
});
