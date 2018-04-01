package com.prasantk.calculator;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

/**
 * Main Calculator Application.
 */
@Service
public class Calculator {
    @Cacheable("sum")
    int sum(int a, int b) {
        return a + b;
    }
}