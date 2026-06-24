package ai.runapi.ideogramv3.types;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parameters for reframe image operations. */
public final class ReframeImageParams {
  private final String model;
  private final String sourceImageUrl;
  private final String aspectRatio;
  private final String renderingSpeed;
  private final String style;
  private final Integer outputCount;
  private final Integer seed;
  private final String callbackUrl;

  private ReframeImageParams(Builder builder) {
    this.model = builder.model;
    this.sourceImageUrl = Ideogramv3ParamUtils.requireNonBlank(builder.sourceImageUrl, "sourceImageUrl");
    this.aspectRatio = builder.aspectRatio;
    this.renderingSpeed = builder.renderingSpeed;
    this.style = builder.style;
    this.outputCount = builder.outputCount;
    this.seed = builder.seed;
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new ReframeImageParams builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key for this request. */
  public String action() {
    return "ideogram-v3/reframe-image";
  }

  /** Converts these parameters to the JSON request body shape. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", Ideogramv3ParamUtils.wireValue(model));
    raw.put("source_image_url", Ideogramv3ParamUtils.wireValue(sourceImageUrl));
    raw.put("aspect_ratio", Ideogramv3ParamUtils.wireValue(aspectRatio));
    raw.put("rendering_speed", Ideogramv3ParamUtils.wireValue(renderingSpeed));
    raw.put("style", Ideogramv3ParamUtils.wireValue(style));
    raw.put("output_count", Ideogramv3ParamUtils.wireValue(outputCount));
    raw.put("seed", Ideogramv3ParamUtils.wireValue(seed));
    raw.put("callback_url", Ideogramv3ParamUtils.wireValue(callbackUrl));
    return Ideogramv3ParamUtils.compact(raw);
  }



  /** Builder for {@link ReframeImageParams}. */
  public static final class Builder {
    private String model;
    private String sourceImageUrl;
    private String aspectRatio;
    private String renderingSpeed;
    private String style;
    private Integer outputCount;
    private Integer seed;
    private String callbackUrl;

    private Builder() {}

    /** Sets the model slug using a typed model value. */
    public Builder model(ReframeImageModel value) {
      this.model = java.util.Objects.requireNonNull(value, "model").value();
      return this;
    }

    /** Sets the model slug using a string value. */
    public Builder model(String value) {
      this.model = Ideogramv3ParamUtils.requireNonBlankTrim(value, "model");
      return this;
    }


    /** Sets the source image URL. */
    public Builder sourceImageUrl(String value) {
      this.sourceImageUrl = Ideogramv3ParamUtils.requireNonBlank(value, "sourceImageUrl");
      return this;
    }

    /** Sets the output aspect ratio. */
    public Builder aspectRatio(String value) {
      this.aspectRatio = Ideogramv3ParamUtils.requireNonBlank(value, "aspectRatio");
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

    /** Sets the webhook URL for task completion notifications. */
    public Builder callbackUrl(String value) {
      this.callbackUrl = Ideogramv3ParamUtils.requireNonBlank(value, "callbackUrl");
      return this;
    }

    /** Builds immutable reframe image parameters. */
    public ReframeImageParams build() {
      return new ReframeImageParams(this);
    }
  }
}
