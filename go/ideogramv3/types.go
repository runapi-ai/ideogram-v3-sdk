package ideogramv3

type Model string

type RenderingSpeed string

type Style string

type AspectRatio string

type OutputCount int

type TaskStatus string

const (
	ModelTextToImage Model = "ideogram-v3-text-to-image"
	ModelEdit        Model = "ideogram-v3-edit"
	ModelRemix       Model = "ideogram-v3-remix"
	ModelCharacter   Model = "ideogram-v3-character"
	ModelCharEdit    Model = "ideogram-v3-character-edit"
	ModelCharRemix   Model = "ideogram-v3-character-remix"
	ModelReframe     Model = "ideogram-v3-reframe"

	RenderingTurbo    RenderingSpeed = "turbo"
	RenderingBalanced RenderingSpeed = "balanced"
	RenderingQuality  RenderingSpeed = "quality"

	StyleAuto      Style = "auto"
	StyleGeneral   Style = "general"
	StyleRealistic Style = "realistic"
	StyleDesign    Style = "design"
	StyleFiction   Style = "fiction"

	AspectRatio1x1  AspectRatio = "1:1"
	AspectRatio3x4  AspectRatio = "3:4"
	AspectRatio9x16 AspectRatio = "9:16"
	AspectRatio4x3  AspectRatio = "4:3"
	AspectRatio16x9 AspectRatio = "16:9"
)

// TextToImageParams are the inputs for `ideogram-v3-text-to-image`.
type TextToImageParams struct {
	Model                 Model          `json:"model" help:"required; model slug"`
	Prompt                string         `json:"prompt" help:"required; max 5000 characters"`
	RenderingSpeed        RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; rendering speed"`
	Style                 Style          `json:"style,omitempty" help:"optional; style preset"`
	EnablePromptExpansion *bool          `json:"enable_prompt_expansion,omitempty" help:"optional; use MagicPrompt to expand the prompt"`
	AspectRatio           AspectRatio    `json:"aspect_ratio,omitempty" help:"optional; output aspect ratio"`
	OutputCount           OutputCount    `json:"output_count,omitempty" help:"optional; number of generated images"`
	Seed                  *int           `json:"seed,omitempty" help:"optional; random seed"`
	NegativePrompt        string         `json:"negative_prompt,omitempty" help:"optional; max 5000 characters"`
	ReferenceImageURLs    []string       `json:"reference_image_urls,omitempty" help:"required for character models; character reference image URLs"`
	CallbackURL           string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// EditImageParams are the inputs for `ideogram-v3-edit` (inpaint with mask).
type EditImageParams struct {
	Model                 Model          `json:"model" help:"required; model slug"`
	Prompt                string         `json:"prompt" help:"required; fill text for the masked area, max 5000 characters"`
	SourceImageURL        string         `json:"source_image_url" help:"required; source image URL. JPEG/PNG/WEBP, max 10 MB"`
	MaskURL               string         `json:"mask_url" help:"required; inpaint mask URL. Must match source dimensions"`
	RenderingSpeed        RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; rendering speed"`
	Style                 Style          `json:"style,omitempty" help:"optional for character edit; style preset"`
	EnablePromptExpansion *bool          `json:"enable_prompt_expansion,omitempty" help:"optional; use MagicPrompt to expand the prompt"`
	OutputCount           OutputCount    `json:"output_count,omitempty" help:"optional; number of generated images"`
	Seed                  *int           `json:"seed,omitempty" help:"optional; random seed"`
	ReferenceImageURLs    []string       `json:"reference_image_urls,omitempty" help:"required for character edit models; character reference image URLs"`
	CallbackURL           string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// RemixImageParams are the inputs for `ideogram-v3-remix`.
type RemixImageParams struct {
	Model                   Model          `json:"model" help:"required; model slug"`
	Prompt                  string         `json:"prompt" help:"required; max 5000 characters"`
	SourceImageURL          string         `json:"source_image_url" help:"required; source image URL. JPEG/PNG/WEBP, max 10 MB"`
	RenderingSpeed          RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; rendering speed"`
	Style                   Style          `json:"style,omitempty" help:"optional; style preset"`
	EnablePromptExpansion   *bool          `json:"enable_prompt_expansion,omitempty" help:"optional; use MagicPrompt to expand the prompt"`
	AspectRatio             AspectRatio    `json:"aspect_ratio,omitempty" help:"optional; output aspect ratio"`
	OutputCount             OutputCount    `json:"output_count,omitempty" help:"optional; number of generated images"`
	Seed                    *int           `json:"seed,omitempty" help:"optional; random seed"`
	Strength                *float64       `json:"strength,omitempty" help:"optional; 0.01-1, or 0.1-1 for character remix"`
	NegativePrompt          string         `json:"negative_prompt,omitempty" help:"optional; max 5000 characters"`
	ReferenceImageURLs      []string       `json:"reference_image_urls,omitempty" help:"required for character remix models; character reference image URLs"`
	StyleReferenceImageURLs []string       `json:"style_reference_image_urls,omitempty" help:"optional for character remix; style reference image URLs"`
	ReferenceMaskURLs       []string       `json:"reference_mask_urls,omitempty" help:"optional for character remix; masks for character references"`
	CallbackURL             string         `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// ReframeImageParams are the inputs for `ideogram-v3-reframe`.
type ReframeImageParams struct {
	Model          Model          `json:"model" help:"required; model slug"`
	SourceImageURL string         `json:"source_image_url" help:"required; source image URL. JPEG/PNG/WEBP, max 10 MB"`
	AspectRatio    AspectRatio    `json:"aspect_ratio" help:"required; output aspect ratio"`
	RenderingSpeed RenderingSpeed `json:"rendering_speed,omitempty" help:"optional; rendering speed"`
	Style          Style          `json:"style,omitempty" help:"optional; style preset"`
	OutputCount    OutputCount    `json:"output_count,omitempty" help:"optional; number of generated images"`
	Seed           *int           `json:"seed,omitempty" help:"optional; random seed"`
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
