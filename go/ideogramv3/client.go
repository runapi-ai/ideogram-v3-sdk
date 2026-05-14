// Package ideogramv3 provides the Ideogram V3 image generation API client.
//
//	client, err := ideogramv3.NewClient(option.WithAPIKey("sk-your-api-key"))
//	result, err := client.Generations.Run(ctx, ideogramv3.GenerationParams{
//	    Model: ideogramv3.ModelTextToImage, Prompt: "A cinematic lakeside",
//	})
package ideogramv3

import (
	"context"

	"github.com/runapi-ai/core-sdk/go/core"
	"github.com/runapi-ai/core-sdk/go/option"
)

const (
	generationsPath = "/api/v1/ideogram_v3/generations"
	editsPath       = "/api/v1/ideogram_v3/edits"
	remixesPath     = "/api/v1/ideogram_v3/remixes"
)

// Client is the Ideogram V3 image generation API client.
type Client struct {
	// Generations provides text-to-image operations.
	Generations *Generations
	// Edits provides inpaint-with-mask operations.
	Edits *Edits
	// Remixes provides image remix operations.
	Remixes *Remixes
}

// NewClient creates an Ideogram V3 client with the given options.
func NewClient(opts ...option.ClientOption) (*Client, error) {
	resolved, err := option.ResolveClientOptions(opts...)
	if err != nil {
		return nil, err
	}
	httpClient, err := core.NewHTTPClient(resolved)
	if err != nil {
		return nil, err
	}
	return NewClientWithHTTP(httpClient), nil
}

// NewClientWithHTTP creates an Ideogram V3 client with a pre-configured HTTP transport.
func NewClientWithHTTP(httpClient core.HTTPClient) *Client {
	return &Client{
		Generations: &Generations{http: httpClient},
		Edits:       &Edits{http: httpClient},
		Remixes:     &Remixes{http: httpClient},
	}
}

// Generations generates images from text prompts.
type Generations struct{ http core.HTTPClient }

// Edits inpaints a source image using a mask.
type Edits struct{ http core.HTTPClient }

// Remixes remixes an input image with a new prompt.
type Remixes struct{ http core.HTTPClient }

func (r *Generations) Create(ctx context.Context, params GenerationParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, generationsPath, core.CompactParams(params), requestOptions)
}
func (r *Generations) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(generationsPath, id), requestOptions)
}
func (r *Generations) Run(ctx context.Context, params GenerationParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

func (r *Edits) Create(ctx context.Context, params EditParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, editsPath, core.CompactParams(params), requestOptions)
}
func (r *Edits) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(editsPath, id), requestOptions)
}
func (r *Edits) Run(ctx context.Context, params EditParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

func (r *Remixes) Create(ctx context.Context, params RemixParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, remixesPath, core.CompactParams(params), requestOptions)
}
func (r *Remixes) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(remixesPath, id), requestOptions)
}
func (r *Remixes) Run(ctx context.Context, params RemixParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}
