package com.yhams.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LogAop {
	
	@Around("execution(* com.yhams..*.*(..))")
	public Object addLog(ProceedingJoinPoint joinPoint) throws Throwable {
		String methodname = joinPoint.getSignature().toString();
		try {
			Object result = joinPoint.proceed();
			return result;
		}finally {
		}
	}

}
