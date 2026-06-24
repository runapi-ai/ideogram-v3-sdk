package ai.runapi.ideogramv3.types;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parameters for edit image operations. */
public final class EditImageParams {
  private final String model;
  private final String prompt;
  private final String sourceImageUrl;
  private final String maskUrl;
  private final String renderingSpeed;
  private final String style;
  private final Boolean enablePromptExpansion;
  private final Integer outputCount;
  private final Integer seed;
  private final List<String> referenceImageUrls;
  private final String callbackUrl;

  private EditImageParams(Builder builder) {
    this.model = builder.model;
    this.prompt = builder.prompt;
    this.sourceImageUrl = Ideogramv3ParamUtils.requireNonBlank(builder.sourceImageUrl, "sourceImageUrl");
    this.maskUrl = builder.maskUrl;
    this.renderingSpeed = builder.renderingSpeed;
    this.style = builder.style;
    this.enablePromptExpansion = builder.enablePromptExpansion;
    this.outputCount = builder.outputCount;
    this.seed = builder.seed;
    this.referenceImageUrls = Ideogramv3ParamUtils.strings(builder.referenceImageUrls);
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new EditImageParams builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key for this request. */
  public String action() {
    return "ideogram-v3/edit-image";
  }

  /** Converts these parameters to the JSON request body shape. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", Ideogramv3ParamUtils.wireValue(model));
    raw.put("prompt", Ideogramv3ParamUtils.wireValue(prompt));
    raw.put("source_image_url", Ideogramv3ParamUtils.wireValue(sourceImageUrl));
    raw.put("mask_url", Ideogramv3ParamUtils.wireValue(maskUrl));
    raw.put("rendering_speed", Ideogramv3ParamUtils.wireValue(renderingSpeed));
    raw.put("style", Ideogramv3ParamUtils.wireValue(style));
    raw.put("enable_prompt_expansion", Ideogramv3ParamUtils.wireValue(enablePromptExpansion));
    raw.put("output_count", Ideogramv3ParamUtils.wireValue(outputCount));
    raw.put("seed", Ideogramv3ParamUtils.wireValue(seed));
    raw.put("reference_image_urls", Ideogramv3ParamUtils.wireValue(referenceImageUrls));
    raw.put("callback_url", Ideogramv3ParamUtils.wireValue(callbackUrl));
    return Ideogramv3ParamUtils.compact(raw);
  }



  /** Builder for {@link EditImageParams}. */
  public static final class Builder {
    private String model;
    private String prompt;
    private String sourceImageUrl;
    private String maskUrl;
    private String renderingSpeed;
    private String style;
    private Boolean enablePromptExpansion;
    private Integer outputCount;
    private Integer seed;
    private List<String> referenceImageUrls;
    private String callbackUrl;

    private Builder() {}

    /** Sets the model slug using a typed model value. */
    public Builder model(EditImageModel value) {
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

    /** Sets the mask URL. */
    public Builder maskUrl(String value) {
      this.maskUrl = Ideogramv3ParamUtils.requireNonBlank(value, "maskUrl");
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

    /** Builds immutable edit image parameters. */
    public EditImageParams build() {
      return new EditImageParams(this);
    }
  }
}
