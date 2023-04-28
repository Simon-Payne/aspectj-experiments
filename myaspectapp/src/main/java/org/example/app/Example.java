package org.example.app;

import org.example.JiraCase;

public class Example {

		@JiraCase
    public String makeUpperCase(String input, @JiraCase String other) {
        return input.toUpperCase();
    }

}
