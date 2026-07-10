# Day 05 - Bash Scripting

## Objective

The objective of Day 05 is to learn the fundamentals of Bash scripting, understand shell scripting concepts, and automate repetitive tasks using Bash.

---

## Topics Covered

* Introduction to Bash Scripting
* Creating a Bash Script
* Script Execution
* Variables
* User Input
* Conditional Statements (`if`)
* Loops (`for`, `while`)
* Functions
* Command Line Arguments
* Exit Status

---

## Commands Practiced

| Command              | Description                                        |
| -------------------- | -------------------------------------------------- |
| `touch script.sh`    | Creates a new Bash script.                         |
| `chmod +x script.sh` | Makes the script executable.                       |
| `./script.sh`        | Executes the script.                               |
| `bash script.sh`     | Runs the script using Bash.                        |
| `echo`               | Prints output to the terminal.                     |
| `read`               | Reads input from the user.                         |
| `if`                 | Executes code based on a condition.                |
| `for`                | Repeats a block of code for a sequence.            |
| `while`              | Repeats a block of code while a condition is true. |
| `function`           | Defines a reusable block of code.                  |

---

## Hands-on Exercises

### Exercise 1 - Hello World Script

```bash
touch hello.sh
chmod +x hello.sh
```

**hello.sh**

```bash
#!/bin/bash
echo "Hello, DevOps!"
```

Run:

```bash
./hello.sh
```

---

### Exercise 2 - Variables

```bash
#!/bin/bash

name="Moorthi"

echo "Welcome $name"
```

---

### Exercise 3 - User Input

```bash
#!/bin/bash

echo "Enter your name:"
read name

echo "Hello $name"
```

---

### Exercise 4 - If Condition

```bash
#!/bin/bash

num=10

if [ $num -gt 5 ]
then
    echo "Number is greater than 5"
fi
```

---

### Exercise 5 - For Loop

```bash
#!/bin/bash

for i in {1..5}
do
    echo $i
done
```

---

### Exercise 6 - While Loop

```bash
#!/bin/bash

count=1

while [ $count -le 5 ]
do
    echo $count
    count=$((count+1))
done
```

---

### Exercise 7 - Function

```bash
#!/bin/bash

greet() {
    echo "Welcome to DevOps Learning!"
}

greet
```

---

### Exercise 8 - Command Line Arguments

```bash
#!/bin/bash

echo "First Argument: $1"
echo "Second Argument: $2"
```

Run:

```bash
./script.sh Linux DevOps
```

---

### Exercise 9 - Exit Status

```bash
#!/bin/bash

ls

echo $?
```

---

## Learning Outcome

After completing Day 05, I am able to:

* Create and execute Bash scripts.
* Use variables and user input.
* Write conditional statements.
* Use loops for automation.
* Create reusable functions.
* Pass command-line arguments.
* Check command exit status.
* Understand the basics of Linux automation.

---
