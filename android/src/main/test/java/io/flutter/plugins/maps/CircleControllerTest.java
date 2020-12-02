package android.src.main.test.java.io.flutter.plugins.maps;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;

import com.google.android.gms.internal.maps.zzh;
import com.google.android.gms.maps.model.Circle;
import org.junit.Test;
import org.mockito.Mockito;

public class CircleControllerTest {

  @Test
  public void controller_SetsStrokeDensity() {
    final zzh z = mock(zzh.class);
    final Circle circle = spy(new Circle(z));

    final float density = 5;
    final float strokeWidth = 3;
    final CircleController controller = new CircleController(circle, false, density);
    controller.setStrokeWidth(strokeWidth);

    Mockito.verify(circle).setStrokeWidth(density * strokeWidth);
  }
}
