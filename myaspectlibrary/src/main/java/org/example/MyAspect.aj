package org.example;

public aspect MyAspect {
    before() : execution(* *(..)) && @annotation(Marker) {
        System.out.println("I found " + thisJoinPoint);
    }
}
