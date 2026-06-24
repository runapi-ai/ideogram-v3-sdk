package ai.runapi.ideogramv3.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for reframe image operations. */
public final class ReframeImageModel extends Ideogramv3Value {
  /** ideogram-v3-reframe model slug. */
  public static final ReframeImageModel IDEOGRAM_V3_REFRAME = new ReframeImageModel("ideogram-v3-reframe");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public ReframeImageModel(String value) {
    super(value);
  }
}
