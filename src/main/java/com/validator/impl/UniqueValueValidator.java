package com.validator.impl;

import com.validator.UniqueValue;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.transaction.annotation.Transactional;

public class UniqueValueValidator implements ConstraintValidator<UniqueValue, Object> {

    @PersistenceContext
    private EntityManager entityManager;

    private Class<?> entityClass;
    private String fieldName;

    @Override
    public void initialize(UniqueValue constraintAnnotation) {
        this.entityClass = constraintAnnotation.entity();
        this.fieldName = constraintAnnotation.field();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        if (value == null || (value instanceof String && ((String) value).isBlank())) {
            return true; 
        }

        // Tạo câu truy vấn động JPQL: SELECT COUNT(e) FROM [EntityName] e WHERE e.[fieldName] = :val
        String jpql = "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e WHERE e." + fieldName + " = :val";
        
        Long count = (Long) entityManager.createQuery(jpql)
                .setParameter("val", value)
                .getSingleResult();

        return count == 0;
    }
}
