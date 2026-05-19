// Package ideogramv3 provides the Ideogram V3 image generation API client.
//
//	client, err := ideogramv3.NewClient(option.WithAPIKey("sk-your-api-key"))
//	result, err := client.TextToImage.Run(ctx, ideogramv3.TextToImageParams{
//	    Model: ideogramv3.ModelTextToImage, Prompt: "A cinematic lakeside",
//	})
package ideogramv3

import (
	"context"

	"github.com/runapi-ai/core-sdk/go/core"
	"github.com/runapi-ai/core-sdk/go/option"
)

const (
	textToImagePath = "/api/v1/ideogram_v3/text_to_image"
	editImagePath   = "/api/v1/ideogram_v3/edit_image"
	remixImagePath  = "/api/v1/ideogram_v3/remix_image"
)

// Client is the Ideogram V3 image generation API client.
type Client struct {
	// TextToImage provides text-to-image operations.
	TextToImage *TextToImage
	// EditImage provides inpaint-with-mask operations.
	EditImage *EditImage
	// RemixImage provides image remix operations.
	RemixImage *RemixImage
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
		TextToImage: &TextToImage{http: httpClient},
		EditImage:   &EditImage{http: httpClient},
		RemixImage:  &RemixImage{http: httpClient},
	}
}

// TextToImage generates images from text prompts.
type TextToImage struct{ http core.HTTPClient }

// EditImage inpaints a source image using a mask.
type EditImage struct{ http core.HTTPClient }

// RemixImage remixImage an input image with a new prompt.
type RemixImage struct{ http core.HTTPClient }

func (r *TextToImage) Create(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, textToImagePath, core.CompactParams(params), requestOptions)
}
func (r *TextToImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(textToImagePath, id), requestOptions)
}
func (r *TextToImage) Run(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

func (r *EditImage) Create(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, editImagePath, core.CompactParams(params), requestOptions)
}
func (r *EditImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(editImagePath, id), requestOptions)
}
func (r *EditImage) Run(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

func (r *RemixImage) Create(ctx context.Context, params RemixImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, remixImagePath, core.CompactParams(params), requestOptions)
}
func (r *RemixImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(remixImagePath, id), requestOptions)
}
func (r *RemixImage) Run(ctx context.Context, params RemixImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}
