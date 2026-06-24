// Package ideogramv3 provides the Ideogram V3 image generation API client.
//
//	client, err := ideogramv3.NewClient(option.WithAPIKey("sk-your-api-key"))
//	result, err := client.TextToImage.Run(ctx, ideogramv3.TextToImageParams{
//	    Model: ideogramv3.ModelTextToImage, Prompt: "A cinematic lakeside",
//	})
package ideogramv3

import (
	"context"

	"github.com/runapi-ai/core-sdk/go/base"
	"github.com/runapi-ai/core-sdk/go/core"
	"github.com/runapi-ai/core-sdk/go/option"
)

const (
	textToImagePath  = "/api/v1/ideogram_v3/text_to_image"
	editImagePath    = "/api/v1/ideogram_v3/edit_image"
	remixImagePath   = "/api/v1/ideogram_v3/remix_image"
	reframeImagePath = "/api/v1/ideogram_v3/reframe_image"
)

// Client is the Ideogram V3 image generation API client.
type Client struct {
	base.Base
	// TextToImage provides text-to-image operations.
	TextToImage *TextToImage
	// EditImage provides inpaint-with-mask operations.
	EditImage *EditImage
	// RemixImage provides image remix operations.
	RemixImage *RemixImage
	// ReframeImage provides image reframe operations.
	ReframeImage *ReframeImage
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
		Base:         base.New(httpClient),
		TextToImage:  &TextToImage{http: httpClient},
		EditImage:    &EditImage{http: httpClient},
		RemixImage:   &RemixImage{http: httpClient},
		ReframeImage: &ReframeImage{http: httpClient},
	}
}

// TextToImage generates images from text prompts.
type TextToImage struct{ http core.HTTPClient }

// EditImage inpaints a source image using a mask.
type EditImage struct{ http core.HTTPClient }

// RemixImage creates a variation of a source image guided by a new prompt.
type RemixImage struct{ http core.HTTPClient }

// ReframeImage reframes an input image into a new aspect ratio or size.
type ReframeImage struct{ http core.HTTPClient }

// Create submits a text-to-image task and returns immediately with a task id.
func (r *TextToImage) Create(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["text-to-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, textToImagePath, body, requestOptions)
}

// Get fetches the current status of a text-to-image task by id.
func (r *TextToImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(textToImagePath, id), requestOptions)
}

// Run submits a text-to-image task and polls until it completes.
func (r *TextToImage) Run(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

// Create submits an edit-image task and returns immediately with a task id.
func (r *EditImage) Create(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["edit-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, editImagePath, body, requestOptions)
}

// Get fetches the current status of an edit-image task by id.
func (r *EditImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(editImagePath, id), requestOptions)
}

// Run submits an edit-image task and polls until it completes.
func (r *EditImage) Run(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

// Create submits a remix-image task and returns immediately with a task id.
func (r *RemixImage) Create(ctx context.Context, params RemixImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["remix-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, remixImagePath, body, requestOptions)
}

// Get fetches the current status of a remix-image task by id.
func (r *RemixImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(remixImagePath, id), requestOptions)
}

// Run submits a remix-image task and polls until it completes.
func (r *RemixImage) Run(ctx context.Context, params RemixImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

// Create submits a reframe-image task and returns immediately with a task id.
func (r *ReframeImage) Create(ctx context.Context, params ReframeImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["reframe-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, reframeImagePath, body, requestOptions)
}

// Get fetches the current status of a reframe-image task by id.
func (r *ReframeImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*IdeogramResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[IdeogramResponse](ctx, r.http, core.ResourcePath(reframeImagePath, id), requestOptions)
}

// Run submits a reframe-image task and polls until it completes.
func (r *ReframeImage) Run(ctx context.Context, params ReframeImageParams, opts ...option.RequestOption) (*IdeogramResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*IdeogramResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}
