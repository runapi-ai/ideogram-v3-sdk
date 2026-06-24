package ai.runapi.ideogramv3.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for text to image operations. */
public final class TextToImageModel extends Ideogramv3Value {
  /** ideogram-v3-character model slug. */
  public static final TextToImageModel IDEOGRAM_V3_CHARACTER = new TextToImageModel("ideogram-v3-character");
  /** ideogram-v3-text-to-image model slug. */
  public static final TextToImageModel IDEOGRAM_V3_TEXT_TO_IMAGE = new TextToImageModel("ideogram-v3-text-to-image");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public TextToImageModel(String value) {
    super(value);
  }
}
