package com.validator;

import com.validator.impl.FutureDateTimeValidator;
import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = FutureDateTimeValidator.class)
@Documented
public @interface FutureDateTime {
    String message() default "Ngày hết hạn phải ở trong tương lai";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
