# Day 03 - Linux Processes & Services

## Objective

The objective of Day 03 is to understand Linux processes and services, monitor running processes, manage services, and perform basic process management through hands-on exercises.

---

## Topics Covered

* What is a Process?
* Process Lifecycle
* Foreground Process
* Background Process
* Process ID (PID)
* Parent Process
* What is a Service?
* Systemd
* Managing Services

---

## Commands Practiced

| Command                       | Description                                                     |
| ----------------------------- | --------------------------------------------------------------- |
| `ps`                          | Displays currently running processes.                           |
| `ps -ef`                      | Displays all running processes with detailed information.       |
| `top`                         | Displays real-time running processes and system resource usage. |
| `htop`                        | Interactive process viewer (if installed).                      |
| `kill <PID>`                  | Terminates a process using its Process ID.                      |
| `pkill <process-name>`        | Terminates a process using its name.                            |
| `jobs`                        | Displays background jobs.                                       |
| `bg`                          | Resumes a stopped job in the background.                        |
| `fg`                          | Brings a background job to the foreground.                      |
| `systemctl status <service>`  | Displays the status of a service.                               |
| `systemctl start <service>`   | Starts a service.                                               |
| `systemctl stop <service>`    | Stops a service.                                                |
| `systemctl restart <service>` | Restarts a service.                                             |
| `systemctl enable <service>`  | Enables a service at system boot.                               |
| `systemctl disable <service>` | Disables a service from starting automatically.                 |

---

## Hands-on Exercises

### Exercise 1 - View Running Processes

```bash
ps
```

---

### Exercise 2 - View All Running Processes

```bash
ps -ef
```

---

### Exercise 3 - Monitor Processes

```bash
top
```

(Press **q** to exit.)

---

### Exercise 4 - Check Service Status

```bash
systemctl status ssh
```

---

### Exercise 5 - Start a Service

```bash
sudo systemctl start ssh
```

---

### Exercise 6 - Stop a Service

```bash
sudo systemctl stop ssh
```

---

### Exercise 7 - Restart a Service

```bash
sudo systemctl restart ssh
```

---

### Exercise 8 - Enable a Service

```bash
sudo systemctl enable ssh
```

---

### Exercise 9 - Disable a Service

```bash
sudo systemctl disable ssh
```

---

### Exercise 10 - Kill a Process

Find a process:

```bash
ps -ef
```

Terminate it:

```bash
kill <PID>
```

Replace `<PID>` with the actual Process ID.

---

## Learning Outcome

After completing Day 03, I am able to:

* Understand Linux processes and services.
* View and monitor running processes.
* Identify Process IDs (PID).
* Start, stop, restart, enable, and disable Linux services.
* Terminate processes using PID or process name.
* Understand the role of systemd in service management.

---
