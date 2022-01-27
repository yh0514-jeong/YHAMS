package com.yhams.aop;

import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LogAop {
	
//	@Around("execution(* com.yhams..*.*(..))")
//	public Object addLog(ProceedingJoinPoint joinPoint) throws Throwable {
//		String methodname = joinPoint.getSignature().toString();
//		try {
//			System.out.println(methodname + "is started..");
//			Object result = joinPoint.proceed();
//			return result;
//		}finally {
//			System.out.println(methodname + "is Ended...");
//		}
//	}

}
