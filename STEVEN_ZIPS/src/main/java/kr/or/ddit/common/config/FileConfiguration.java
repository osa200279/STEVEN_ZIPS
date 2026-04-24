package kr.or.ddit.common.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Slf4j
@Configuration
public class FileConfiguration implements WebMvcConfigurer {

//    @Value("${upload_path}")
//    private String uploadPath;
//
//    // 웹 주소와 파일의 위치를 매핑한다.
//    @Override
//    public void addResourceHandlers(ResourceHandlerRegistry registry) {
////        // 웹 브라우저에서 http://localhost/xxx로 요청 시,
////        registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
//    }
}

