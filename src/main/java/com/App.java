package com;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
// @SpringBootApplication
@SpringBootApplication(
	// config toan bo security ngoai tru SecurityAutoConfiguration
	exclude = org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class
)
public class App {
    public static void main(String[] args) {
		// lay ra tat ca cac bean da duoc khoi tao trong spring container
		ApplicationContext abc = SpringApplication.run(App.class, args);
		for (String name : abc.getBeanDefinitionNames()) {
			System.out.println(name);
		}
	}
}
