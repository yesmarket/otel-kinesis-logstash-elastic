package com.demo.javaapi.controllers;

import com.demo.javaapi.model.Student;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/students")
@RequiredArgsConstructor
@Slf4j
public class StudentController {

   @GetMapping(path = "/{id}")
   public @ResponseBody ResponseEntity<Student> get(@PathVariable("id") String id) {

      log.info("requested student with id: {}", id);

      var student = new Student();

      return new ResponseEntity<>(student, HttpStatus.OK);
   }
}
