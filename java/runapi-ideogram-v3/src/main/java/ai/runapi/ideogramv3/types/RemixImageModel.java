package ai.runapi.ideogramv3.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for remix image operations. */
public final class RemixImageModel extends Ideogramv3Value {
  /** ideogram-v3-character-remix model slug. */
  public static final RemixImageModel IDEOGRAM_V3_CHARACTER_REMIX = new RemixImageModel("ideogram-v3-character-remix");
  /** ideogram-v3-remix model slug. */
  public static final RemixImageModel IDEOGRAM_V3_REMIX = new RemixImageModel("ideogram-v3-remix");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public RemixImageModel(String value) {
    super(value);
  }
}
