---
title: Database
---

# Wat is een database?

Een database is een plek waar computers gegevens opslaan, we hebben het gehad over een API
van Instagram, maar Instagram moet ook gegevens over jou oplaan. Wie je bent, je profiel, de foto's en
video's de je ge-upload hebt.

In onze workshop gaan we gebruikers opslaan, laten we eens kijken wat we nodig hebben voor een gebruiker

| id  | Email Address                | Name          |
| --- | ---------------------------- | ------------- |
| 1   | yari.rietveld@enreach.com    | Yari Rietveld |
| 2   | martijn.klene@voiceworks.com | Martijn Klene |

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
import java.lang.RuntimeException

@Repository
class UserDatabase {
    private val users: MutableMap<Int, User> = mutableMapOf<Int, User>(
        Pair(1, User(1, "yari.rietveld@enreach.com", "Yari Rietveld")),
        Pair(2, User(2, "martijn.klene@voiceworks.com", "Martijn Klene"))
    )

    fun showAllUsers(): Map<Int, User> {
        return users
    }

    fun showSingleUser(id: Int): User? {
        return users[id]
    }

    @Throws(RuntimeException::class)
    fun addUser(user: User) {
        if (users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID: %d already exists, can not add that user again", user.id))
        }
        users[user.id] = user
    }

    @Throws(RuntimeException::class)
    fun editUser(user: User) {
        if (!users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID %d was not found for editing", user.id))
        }
        users.replace(user.id, user)
    }

    @Throws(RuntimeException::class)
    fun deleteUser(user: User) {
        if (!users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID %d was not found for deleting", user.id))
        }
        users.remove(user.id)
    }
}
```

Zie je hierin zitten dezelfde gebruikers als in de tabel hierboven, maar nu kunnen we nog steeds geen
gebruikers laten zien in de API, sla het bestand op en klik hieronder door naar "Gebruikers zien"
