package org.gmdev.springbootnativedemo.api;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.*;


@Slf4j
@RequestMapping("api/v1")
@Validated
@RestController
public class IntensiveTaskController {

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/test")
    public String task() {
        log.info("Incoming call to [IntensiveTaskController - task]");
        doTask();
        return "Ok";
    }

    private void doTask() {
        new Thread(this::run).start();
    }

    private void run() {
        ExecutorService executor = Executors.newFixedThreadPool(10);
        List<Future<String>> list = new ArrayList<>();

        Callable<String> callable = new BigTask();

        for (int i = 0; i < 5; i++) {
            Future<String> future = executor.submit(callable);
            list.add(future);
        }

        for (Future<String> future : list) {
            try {
                String result = future.get();
                log.info("Result is: {}", result);

            } catch (Exception e) {
                log.error(e.getMessage());
            }
        }
    }

    private static class BigTask implements Callable<String> {
        @Override
        public String call() {
            BigInteger veryBig = new BigInteger(10000, new Random());
            return veryBig.nextProbablePrime().toString();
        }
    }

}
