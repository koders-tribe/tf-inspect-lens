# Day 02 - Linux Users & Groups

## Objective

The objective of Day 02 is to understand Linux users, groups, user management, group management, and basic permission concepts through hands-on practice.

---

## Topics Covered

* Introduction to Linux Users
* Types of Users

  * Root User
  * Normal User
  * System User
* What is a Group?
* User IDs (UID)
* Group IDs (GID)
* User Management
* Group Management
* Sudo Privileges

---

## Commands Practiced

| Command                                   | Description                                         |
| ----------------------------------------- | --------------------------------------------------- |
| `whoami`                                  | Displays the currently logged-in user.              |
| `id`                                      | Displays the user's UID, GID, and group membership. |
| `groups`                                  | Shows the groups the user belongs to.               |
| `sudo useradd <username>`                 | Creates a new user.                                 |
| `sudo passwd <username>`                  | Sets or changes the user's password.                |
| `sudo userdel <username>`                 | Deletes a user.                                     |
| `sudo groupadd <groupname>`               | Creates a new group.                                |
| `sudo groupdel <groupname>`               | Deletes a group.                                    |
| `sudo usermod -aG <groupname> <username>` | Adds a user to a group.                             |

---

## Hands-on Exercises

### Exercise 1 - Check Current User

```bash
whoami
```

---

### Exercise 2 - Display User Information

```bash
id
```

---

### Exercise 3 - Check User Groups

```bash
groups
```

---

### Exercise 4 - Create a New User

```bash
sudo useradd devuser
```

---

### Exercise 5 - Set Password for the User

```bash
sudo passwd devuser
```

---

### Exercise 6 - Create a New Group

```bash
sudo groupadd devops
```

---

### Exercise 7 - Add User to the Group

```bash
sudo usermod -aG devops devuser
```

---

### Exercise 8 - Verify Group Membership

```bash
groups devuser
```

---

### Exercise 9 - Delete the User

```bash
sudo userdel devuser
```

---

### Exercise 10 - Delete the Group

```bash
sudo groupdel devops
```

---

## Learning Outcome

After completing Day 02, I am able to:

* Understand different types of Linux users.
* Create and manage users.
* Create and manage groups.
* Add users to groups.
* Verify user and group information.
* Understand the purpose of `sudo` for administrative tasks.

---
