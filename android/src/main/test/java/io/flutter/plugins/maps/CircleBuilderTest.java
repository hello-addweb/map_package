package android.src.main.test.java.io.flutter.plugins.maps;

import static junit.framework.TestCase.assertEquals;

import com.google.android.gms.maps.model.CircleOptions;
import org.junit.Test;

public class CircleBuilderTest {

  @Test
  public void density_AppliesToStrokeWidth() {
    final float density = 5;
    final float strokeWidth = 3;
    final CircleBuilder builder = new CircleBuilder(density);
    builder.setStrokeWidth(strokeWidth);

    final CircleOptions options = builder.build();
    final float width = options.getStrokeWidth();

    assertEquals(density * strokeWidth, width);
  }
}
