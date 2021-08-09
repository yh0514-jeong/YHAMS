package com.yhams;

import org.apache.log4j.BasicConfigurator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class YhamsApplication {
	public static void main(String[] args) {
		SpringApplication.run(YhamsApplication.class, args);
		BasicConfigurator.configure();
	}
}
