package com.yhams;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.yhams.common.CommonService;


@SpringBootTest
@TestInstance(Lifecycle.PER_METHOD)
@SuppressWarnings("all")
public class OptionalTest {
	
	private static final Logger log = LoggerFactory.getLogger(OptionalTest.class);

	
	@Autowired
	private CommonService commonService;
	
	@Test
	public void optional_method_test() {
		List<String> tmpStrList = Arrays.asList("옵셔널", "테스트");
		
		//Optional<String> maybeStr = tmpStrList.stream().findFirst();
		//if(maybeStr.isPresent()) log.info("maybeStr : {}", maybeStr.get());
		//else log.info("maybeStr is absent");
		
		Optional<String> maybeString = Optional.of(null);
		//Optional<String> maybeString = Optional.ofNullable("안녕하세요");
		//Optional<String> maybeString2 = Optional.ofNullable(null);
		//log.info("maybeString : {}, maybeString2 : {}", maybeString, maybeString2);
		log.info("maybeString : {}", maybeString);
	}
	

}
