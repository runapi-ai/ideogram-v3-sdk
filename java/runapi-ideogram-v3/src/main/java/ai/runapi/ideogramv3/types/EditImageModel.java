package ai.runapi.ideogramv3.types;

import com.fasterxml.jackson.annotation.JsonCreator;

/** Model slug for edit image operations. */
public final class EditImageModel extends Ideogramv3Value {
  /** ideogram-v3-character-edit model slug. */
  public static final EditImageModel IDEOGRAM_V3_CHARACTER_EDIT = new EditImageModel("ideogram-v3-character-edit");
  /** ideogram-v3-edit model slug. */
  public static final EditImageModel IDEOGRAM_V3_EDIT = new EditImageModel("ideogram-v3-edit");

  /** Creates a model value from a literal model slug. */
  @JsonCreator
  public EditImageModel(String value) {
    super(value);
  }
}
