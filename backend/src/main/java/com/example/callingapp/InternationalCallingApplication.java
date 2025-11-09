package com.example.callingapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class InternationalCallingApplication {

    public static void main(String[] args) {
        SpringApplication.run(InternationalCallingApplication.class, args);
    }
}
