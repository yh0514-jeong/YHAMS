package com.yhams;

import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;


@SpringBootTest
@TestInstance(Lifecycle.PER_METHOD)
@SuppressWarnings("all")
public class OptionalTest {
	
	private static final Logger log = LoggerFactory.getLogger(OptionalTest.class);

	
	@Test
	public void optional_method_test() {
		
		ArrayList<Integer> intList = new ArrayList<>();
		IntStream.range(1, 10).forEach(x -> {
			intList.add(x);
		});
		AtomicInteger defaultValue = new AtomicInteger(1);
		log.info("defaultValue(before) : {}", defaultValue);
		// Optional<AtomicInteger> maybeDefaultValue =  Optional.ofNullable(defaultValue).map(defaultValue::getOpaque);
		log.info("defaultValue(after) : {}", defaultValue);

	}
	
	@Test
	public void uuid_generate_test() {
		UUID uuid = UUID.randomUUID();
		System.out.println("uuid : "+ uuid);
	}

}
