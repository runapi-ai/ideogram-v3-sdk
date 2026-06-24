package ai.runapi.ideogramv3.types;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parameters for text to image operations. */
public final class TextToImageParams {
  private final String model;
  private final String prompt;
  private final String renderingSpeed;
  private final String style;
  private final Boolean enablePromptExpansion;
  private final String aspectRatio;
  private final Integer outputCount;
  private final Integer seed;
  private final String negativePrompt;
  private final List<String> referenceImageUrls;
  private final String callbackUrl;

  private TextToImageParams(Builder builder) {
    this.model = builder.model;
    this.prompt = builder.prompt;
    this.renderingSpeed = builder.renderingSpeed;
    this.style = builder.style;
    this.enablePromptExpansion = builder.enablePromptExpansion;
    this.aspectRatio = builder.aspectRatio;
    this.outputCount = builder.outputCount;
    this.seed = builder.seed;
    this.negativePrompt = builder.negativePrompt;
    this.referenceImageUrls = Ideogramv3ParamUtils.strings(builder.referenceImageUrls);
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new TextToImageParams builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key for this request. */
  public String action() {
    return "ideogram-v3/text-to-image";
  }

  /** Converts these parameters to the JSON request body shape. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", Ideogramv3ParamUtils.wireValue(model));
    raw.put("prompt", Ideogramv3ParamUtils.wireValue(prompt));
    raw.put("rendering_speed", Ideogramv3ParamUtils.wireValue(renderingSpeed));
    raw.put("style", Ideogramv3ParamUtils.wireValue(style));
    raw.put("enable_prompt_expansion", Ideogramv3ParamUtils.wireValue(enablePromptExpansion));
    raw.put("aspect_ratio", Ideogramv3ParamUtils.wireValue(aspectRatio));
    raw.put("output_count", Ideogramv3ParamUtils.wireValue(outputCount));
    raw.put("seed", Ideogramv3ParamUtils.wireValue(seed));
    raw.put("negative_prompt", Ideogramv3ParamUtils.wireValue(negativePrompt));
    raw.put("reference_image_urls", Ideogramv3ParamUtils.wireValue(referenceImageUrls));
    raw.put("callback_url", Ideogramv3ParamUtils.wireValue(callbackUrl));
    return Ideogramv3ParamUtils.compact(raw);
  }



  /** Builder for {@link TextToImageParams}. */
  public static final class Builder {
    private String model;
    private String prompt;
    private String renderingSpeed;
    private String style;
    private Boolean enablePromptExpansion;
    private String aspectRatio;
    private Integer outputCount;
    private Integer seed;
    private String negativePrompt;
    private List<String> referenceImageUrls;
    private String callbackUrl;

    private Builder() {}

    /** Sets the model slug using a typed model value. */
    public Builder model(TextToImageModel value) {
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

    /** Sets the webhook URL for task completion notifications. */
    public Builder callbackUrl(String value) {
      this.callbackUrl = Ideogramv3ParamUtils.requireNonBlank(value, "callbackUrl");
      return this;
    }

    /** Builds immutable text to image parameters. */
    public TextToImageParams build() {
      return new TextToImageParams(this);
    }
  }
}
