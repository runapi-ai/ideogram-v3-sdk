package ai.runapi.ideogramv3.types;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parameters for remix image operations. */
public final class RemixImageParams {
  private final String model;
  private final String prompt;
  private final String sourceImageUrl;
  private final String renderingSpeed;
  private final String style;
  private final Boolean enablePromptExpansion;
  private final String aspectRatio;
  private final Integer outputCount;
  private final Integer seed;
  private final Double strength;
  private final String negativePrompt;
  private final List<String> referenceImageUrls;
  private final List<String> styleReferenceImageUrls;
  private final List<String> referenceMaskUrls;
  private final String callbackUrl;

  private RemixImageParams(Builder builder) {
    this.model = builder.model;
    this.prompt = builder.prompt;
    this.sourceImageUrl = Ideogramv3ParamUtils.requireNonBlank(builder.sourceImageUrl, "sourceImageUrl");
    this.renderingSpeed = builder.renderingSpeed;
    this.style = builder.style;
    this.enablePromptExpansion = builder.enablePromptExpansion;
    this.aspectRatio = builder.aspectRatio;
    this.outputCount = builder.outputCount;
    this.seed = builder.seed;
    this.strength = builder.strength;
    this.negativePrompt = builder.negativePrompt;
    this.referenceImageUrls = Ideogramv3ParamUtils.strings(builder.referenceImageUrls);
    this.styleReferenceImageUrls = Ideogramv3ParamUtils.strings(builder.styleReferenceImageUrls);
    this.referenceMaskUrls = Ideogramv3ParamUtils.strings(builder.referenceMaskUrls);
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new RemixImageParams builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key for this request. */
  public String action() {
    return "ideogram-v3/remix-image";
  }

  /** Converts these parameters to the JSON request body shape. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", Ideogramv3ParamUtils.wireValue(model));
    raw.put("prompt", Ideogramv3ParamUtils.wireValue(prompt));
    raw.put("source_image_url", Ideogramv3ParamUtils.wireValue(sourceImageUrl));
    raw.put("rendering_speed", Ideogramv3ParamUtils.wireValue(renderingSpeed));
    raw.put("style", Ideogramv3ParamUtils.wireValue(style));
    raw.put("enable_prompt_expansion", Ideogramv3ParamUtils.wireValue(enablePromptExpansion));
    raw.put("aspect_ratio", Ideogramv3ParamUtils.wireValue(aspectRatio));
    raw.put("output_count", Ideogramv3ParamUtils.wireValue(outputCount));
    raw.put("seed", Ideogramv3ParamUtils.wireValue(seed));
    raw.put("strength", Ideogramv3ParamUtils.wireValue(strength));
    raw.put("negative_prompt", Ideogramv3ParamUtils.wireValue(negativePrompt));
    raw.put("reference_image_urls", Ideogramv3ParamUtils.wireValue(referenceImageUrls));
    raw.put("style_reference_image_urls", Ideogramv3ParamUtils.wireValue(styleReferenceImageUrls));
    raw.put("reference_mask_urls", Ideogramv3ParamUtils.wireValue(referenceMaskUrls));
    raw.put("callback_url", Ideogramv3ParamUtils.wireValue(callbackUrl));
    return Ideogramv3ParamUtils.compact(raw);
  }



  /** Builder for {@link RemixImageParams}. */
  public static final class Builder {
    private String model;
    private String prompt;
    private String sourceImageUrl;
    private String renderingSpeed;
    private String style;
    private Boolean enablePromptExpansion;
    private String aspectRatio;
    private Integer outputCount;
    private Integer seed;
    private Double strength;
    private String negativePrompt;
    private List<String> referenceImageUrls;
    private List<String> styleReferenceImageUrls;
    private List<String> referenceMaskUrls;
    private String callbackUrl;

    private Builder() {}

    /** Sets the model slug using a typed model value. */
    public Builder model(RemixImageModel value) {
      this.model = java.util.Objects.requireNonNull(value, "model").value();
      return this;
    }

    /** Sets the model slug using a string value. */
    public Builder model(String value) {
      this.model = Ideogramv3ParamUtils.requireNonBlankTrim(value, "model");
      return this;
    }


    /** Sets the text prompt. */
    public Builder prompt(String value) {
      this.prompt = Ideogramv3ParamUtils.requireNonBlank(value, "prompt");
      return this;
    }

    /** Sets the source image URL. */
    public Builder sourceImageUrl(String value) {
      this.sourceImageUrl = Ideogramv3ParamUtils.requireNonBlank(value, "sourceImageUrl");
      return this;
    }

    /** Sets the rendering speed. */
    public Builder renderingSpeed(String value) {
      this.renderingSpeed = Ideogramv3ParamUtils.requireNonBlank(value, "renderingSpeed");
      return this;
    }

    /** Sets the style. */
    public Builder style(String value) {
      this.style = Ideogramv3ParamUtils.requireNonBlank(value, "style");
      return this;
    }

    /** Sets the prompt expansion toggle. */
    public Builder enablePromptExpansion(boolean value) {
      this.enablePromptExpansion = value;
      return this;
    }

    /** Sets the output aspect ratio. */
    public Builder aspectRatio(String value) {
      this.aspectRatio = Ideogramv3ParamUtils.requireNonBlank(value, "aspectRatio");
      return this;
    }

    /** Sets the number of generated outputs. */
    public Builder outputCount(int value) {
      this.outputCount = value;
      return this;
    }

    /** Sets the random seed. */
    public Builder seed(int value) {
      this.seed = value;
      return this;
    }

    /** Sets the strength. */
    public Builder strength(double value) {
      this.strength = value;
      return this;
    }

    /** Sets the negative prompt describing what to avoid. */
    public Builder negativePrompt(String value) {
      this.negativePrompt = Ideogramv3ParamUtils.requireNonBlank(value, "negativePrompt");
      return this;
    }

    /** Sets the reference image URLs. */
    public Builder referenceImageUrls(List<String> value) {
      this.referenceImageUrls = value;
      return this;
    }

    /** Sets the style reference image URLs. */
    public Builder styleReferenceImageUrls(List<String> value) {
      this.styleReferenceImageUrls = value;
      return this;
    }

    /** Sets the reference mask URLs. */
    public Builder referenceMaskUrls(List<String> value) {
      this.referenceMaskUrls = value;
      return this;
    }

    /** Sets the webhook URL for task completion notifications. */
    public Builder callbackUrl(String value) {
      this.callbackUrl = Ideogramv3ParamUtils.requireNonBlank(value, "callbackUrl");
      return this;
    }

    /** Builds immutable remix image parameters. */
    public RemixImageParams build() {
      return new RemixImageParams(this);
    }
  }
}
