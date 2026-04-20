package com.config;

import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Value("${s-mall.remember-me.key}")
        private String rememberMeKey;

        @Autowired
        private CustomAuthenticationSuccessHandler successHandler;

        @Autowired
        private CustomAuthenticationFailureHandler failureHandler;

        @Bean
        public WebSecurityCustomizer webSecurityCustomizer() {
                return (web) -> web.ignoring()
                                .requestMatchers(new AntPathRequestMatcher("/resources/**"))
                                .requestMatchers(new AntPathRequestMatcher("/css/**"))
                                .requestMatchers(new AntPathRequestMatcher("/js/**"))
                                .requestMatchers(new AntPathRequestMatcher("/images/**"))
                                .requestMatchers(new AntPathRequestMatcher("/favicon.ico"));
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .csrf(csrf -> csrf.disable())
                                .authorizeHttpRequests(auth -> auth
                                                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
                                                .requestMatchers("/admin/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                                                .requestMatchers("/shop/register").authenticated()
                                                .requestMatchers("/seller/**").hasAnyRole("SELLER", "ADMIN")
                                                .requestMatchers("/", "/search", "/product/**").permitAll()
                                                .requestMatchers("/login", "/register", "/verify-otp", "/error", "/api/**").permitAll()
                                                .requestMatchers("/WEB-INF/view/**").permitAll()

                                                .anyRequest().authenticated())

                                .formLogin(form -> form
                                                .loginPage("/login")
                                                .loginProcessingUrl("/perform_login")
                                                .successHandler(successHandler)
                                                .failureHandler(failureHandler)
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/")
                                                .clearAuthentication(true)
                                                .invalidateHttpSession(true)
                                                .deleteCookies("JSESSIONID", "remember-me")
                                                .permitAll())
                                .rememberMe(remember -> remember
                                                .key(rememberMeKey)
                                                .tokenValiditySeconds(86400));

                return http.build();
        }
}
