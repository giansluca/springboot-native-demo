package org.gmdev.springbootnativedemo;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;


@Slf4j
@RequestMapping("api/v1")
@Validated
@RestController
public class TestController {

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/test")
    public String test() {
        log.info("Incoming call to [TestController - test]");
        return "Ok";
    }

}
