import org.example.app.Example;
import org.junit.Assert;
import org.junit.Test;

public class ExampleTest {

    @Test
    public void testItWorks() {
        Assert.assertEquals("YES", new Example().makeUpperCase("yes", "anything"));
    }
}
