package ideogramv3

type Model string

type RenderingSpeed string

type Style string

type ImageSize string

type NumImages string

type TaskStatus string

const (
	ModelTextToImage Model = "ideogram-v3-text-to-image"
	ModelEdit        Model = "ideogram-v3-edit"
	ModelRemix       Model = "ideogram-v3-remix"

	RenderingTurbo    RenderingSpeed = "TURBO"
	RenderingBalanced RenderingSpeed = "BALANCED"
	RenderingQuality  RenderingSpeed = "QUALITY"

	StyleAuto      Style = "AUTO"
	StyleGeneral   Style = "GENERAL"
	StyleRealistic Style = "REALISTIC"
	StyleDesign    Style = "DESIGN"

	ImageSizeSquare         ImageSize = "square"
	ImageSizeSquareHD       ImageSize = "square_hd"
	ImageSizePortrait4_3    ImageSize = "portrait_4_3"
	ImageSizePortrait16_9   ImageSize = "portrait_16_9"
	ImageSizeLandscape4_3   ImageSize = "landscape_4_3"
	ImageSizeLandscape16_9  ImageSize = "landscape_16_9"
)

// GenerationParams are the inputs for `ideogram-v3-text-to-image`.
type GenerationParams struct {
	Model          Model          `json:"model" help:"required; must be ideogram-v3-text-to-image"`
	Prompt         string         `json:"prompt" help:"required; max 5000 characters"`
	RenderingSpeed RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; TURBO (3.5¢), BALANCED (7¢, default), QUALITY (10¢)"`
	Style          Style          `json:"style,omitempty" help:"optional; AUTO, GENERAL, REALISTIC, DESIGN"`
	ExpandPrompt   *bool          `json:"expand_prompt,omitempty" help:"optional; use MagicPrompt to enhance the request"`
	ImageSize      ImageSize      `json:"image_size,omitempty" help:"optional; square, square_hd, portrait_4_3, portrait_16_9, landscape_4_3, landscape_16_9"`
	Seed           *int           `json:"seed,omitempty" help:"optional; random seed"`
	NegativePrompt string         `json:"negative_prompt,omitempty" help:"optional; max 5000 characters"`
	CallbackURL    string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// EditParams are the inputs for `ideogram-v3-edit` (inpaint with mask).
type EditParams struct {
	Model          Model          `json:"model" help:"required; must be ideogram-v3-edit"`
	Prompt         string         `json:"prompt" help:"required; fill text for the masked area, max 5000 characters"`
	ImageURL       string         `json:"image_url" help:"required; source image URL. JPEG/PNG/WEBP, max 10 MB"`
	MaskURL        string         `json:"mask_url" help:"required; inpaint mask URL. Must match source dimensions"`
	RenderingSpeed RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; TURBO (3.5¢), BALANCED (7¢, default), QUALITY (10¢)"`
	ExpandPrompt   *bool          `json:"expand_prompt,omitempty" help:"optional; use MagicPrompt to enhance the request"`
	Seed           *int           `json:"seed,omitempty" help:"optional; random seed"`
	CallbackURL    string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// RemixParams are the inputs for `ideogram-v3-remix`.
type RemixParams struct {
	Model          Model          `json:"model" help:"required; must be ideogram-v3-remix"`
	Prompt         string         `json:"prompt" help:"required; max 5000 characters"`
	ImageURL       string         `json:"image_url" help:"required; source image URL. JPEG/PNG/WEBP, max 10 MB"`
	RenderingSpeed RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; TURBO (3.5¢), BALANCED (7¢, default), QUALITY (10¢)"`
	Style          Style          `json:"style,omitempty" help:"optional; AUTO, GENERAL, REALISTIC, DESIGN"`
	ExpandPrompt   *bool          `json:"expand_prompt,omitempty" help:"optional; use MagicPrompt to enhance the request"`
	ImageSize      ImageSize      `json:"image_size,omitempty" help:"optional; square, square_hd, portrait_4_3, portrait_16_9, landscape_4_3, landscape_16_9"`
	NumImages      NumImages      `json:"num_images,omitempty" help:"optional; 1, 2, 3, 4"`
	Seed           *int           `json:"seed,omitempty" help:"optional; random seed"`
	Strength       *float64       `json:"strength,omitempty" help:"optional; 0.01-1, influence of the input image"`
	NegativePrompt string         `json:"negative_prompt,omitempty" help:"optional; max 5000 characters"`
	CallbackURL    string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

type AsyncTaskResponse struct {
	ID     string     `json:"id"`
	Status TaskStatus `json:"status"`
	Error  string     `json:"error,omitempty"`
}

func (r AsyncTaskResponse) GetID() string     { return r.ID }
func (r AsyncTaskResponse) GetStatus() string { return string(r.Status) }
func (r AsyncTaskResponse) GetError() string  { return r.Error }

type Image struct {
	URL string `json:"url"`
}

// IdeogramResponse is the normalized response for all three Ideogram V3 endpoints.
type IdeogramResponse struct {
	AsyncTaskResponse
	Images []Image `json:"images,omitempty"`
}
