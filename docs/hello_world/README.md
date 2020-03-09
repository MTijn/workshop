---
title: Hello world
---

# Hello world

Laten we starten met misschien het meest gebruikte zinnetje voor het leren van programmeren
``hello, world``

::: tip
Dit zinnetje is al sinds 1974 in gebruik voor het leren programmeren!
:::

## Nieuw bestand aanmaken
We gaan een nieuw bestand aanmaken in de map: src/main/kotlin/com.enreach.workshop, linker muis knop op de map com.enreach.workshop
en dan kiezen voor new / Kotlin file / class
![Nieuw bestand aanmaken](/new_class.png)

Dan vraagt de editor wat de naam is van de class, hier voor je de naam ```HelloWorldController``` in
![Nieuwe class aanmaken](/new_class_modal.png)
Wanneer je op enter drukt zul je zien dat de nieuwe class aangemaakt is.

## Een controller maken

Plak nu deze code in de HelloWorldController die je net aangemaakt hebt
```kotlin
package com.enreach.workshop

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HelloWorldController {
    @GetMapping("/hello")
    fun helloWorld(): ResponseEntity<Any> {
        return ResponseEntity.ok("Hello, World!")
    }
}
```

Je kan nu de applicatie starten door op het pijltje te klikken: ![Run application](/run_application.png)