package org.example;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.SoftException;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;

import java.util.logging.Logger;
import java.lang.annotation.Annotation;

/**
 * This class uses a cross-cutting, aspect-oriented approach to detecting when parameters are
 * passed into test methods, where the parameter values are JIRA item numbers such as identify test cases.
 * When AspectJ compilation is run on the Java source code, the resulting bytecode is enhanced with
 * the ability to pick up these parameters and store them in a property named <code>currentJiraCaseId</code>
 * which is read by @link {XrayReportingExtension} and used to update JIRA with the test results.
 */
public aspect JiraCaseAspect {

    private static final Logger logger = Logger.getLogger(JiraCaseAspect.class.getName());

    before() : execution(* *(.., @JiraCase (*), ..)) || @annotation(JiraCase) {

        logger.fine(thisJoinPoint.getSignature().toLongString());
        MethodSignature signature = (MethodSignature) thisJoinPoint.getSignature();
        String methodName = signature.getMethod().getName();
        Class<?>[] parameterTypes = signature.getMethod().getParameterTypes();
        Annotation[][] annotations;
        try
        {
            annotations = thisJoinPoint.getTarget().getClass().
                    getMethod(methodName, parameterTypes).getParameterAnnotations();
        } catch (ReflectiveOperationException e)
        {
            throw new SoftException(e);
        }
        int i = 0;
        for (Object arg : thisJoinPoint.getArgs())
        {
            for (Annotation annotation : annotations[i])
            {
                if (annotation.annotationType() == JiraCase.class)
                {
                    logger.info("  " + annotation + " -> " + arg);
                }
            }
            i++;
        }
    }
}
