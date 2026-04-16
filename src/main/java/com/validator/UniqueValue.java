package com.validator;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import com.validator.impl.UniqueValueValidator;
import java.lang.annotation.*;

@Constraint(validatedBy = UniqueValueValidator.class)
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface UniqueValue {
    String message() default "Giá trị này đã tồn tại";

    Class<?> entity();

    String field();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
