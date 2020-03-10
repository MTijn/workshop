---
title: Database
---

# Wat is een database?

Een database is een plek waar computers gegevens opslaan, we hebben het gehad over een API
van Instagram, maar Instagram moet ook gegevens over jou oplaan. Wie je bent, je profiel, de foto's en
video's de je ge-upload hebt.

In onze workshop gaan we gebruikers opslaan, laten we eens kijken wat we nodig hebben voor een gebruiker

| id  | Email Address | Name          |
| --- | ------------- | ------------- |
| 1   | test@test.nl  | Eerste tester |
| 2   | test2@test.nl | Tweede tester |
| 3   | test3@test.nl | Derde tester  |

We hebben hier dus 3 kolommen die we in onze database tabel stoppen, een nummer of text waarmee we onze gebruiker
kunnen identificeren in de rest van onze API, een gebruikersnaam en een naam.

## Code

### User
Laten we eerst de gebruiker aanmaken zoals we die ook willen laten zien in onze API, net zoals in onze
eerdere HelloWorldController maken we een nieuwe class aan:

![Nieuw bestand aanmaken](/user_class.png)

Wanneer je op enter hebt gedrukt dan plak je de volgende code hierin

``` kotlin
package com.enreach.workshop

data class User(val id: Int, val emailAddress: String, val name: String)
```

Nu kunnen we dit bestand opslaan

### User database
Nu moeten we wel een mogelijkheid maken tot het ophalen van de gebruikers uit onze database, laten we beginnen met het aanmaken
van de ``UserDatabase`` class.

![Nieuw bestand aanmaken](/user_database.png)

Hierin stoppen we de volgende code
``` kotlin
package com.enreach.workshop

import org.springframework.stereotype.Repository

@Repository
class UserDatabase {
    private val users: Map<Int, User> = mutableMapOf<Int, User>(
        Pair(1, User(1, "test@test.nl", "Eerste tester")),
        Pair(2, User(2, "test2@test.nl", "Tweede tester")),
        Pair(3, User(3, "test3@test.nl", "Derde tester"))
    )

    fun showAllUsers(): Map<Int, User> {
        return users
    }

    fun showSingleUser(id: Int): User? {
        return users[id]
    }
}
```

Zie je hierin zitten dezelfde gebruikers als in de tabel hierboven, maar nu kunnen we nog steeds geen
gebruikers laten zien in de API, sla het bestand op en klik hieronder door naar "Gebruikers zien"
