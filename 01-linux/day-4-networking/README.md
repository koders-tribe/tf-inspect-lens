# Day 04 - Linux Networking

## Objective

The objective of Day 04 is to understand the fundamentals of Linux networking, inspect network configuration, test connectivity, troubleshoot network issues, and transfer data using common networking commands.

---

## Topics Covered

* Introduction to Computer Networks
* IP Address
* Public IP vs Private IP
* Hostname
* DNS (Domain Name System)
* Network Interfaces
* Connectivity Testing
* Downloading Files from the Internet
* Network Connections
* Open Ports

---

## Commands Practiced

| Command                    | Description                                         |
| -------------------------- | --------------------------------------------------- |
| `hostname`                 | Displays the system hostname.                       |
| `hostname -I`              | Displays the system IP address.                     |
| `ip addr`                  | Displays all network interfaces and IP addresses.   |
| `ip route`                 | Displays the routing table.                         |
| `ping google.com`          | Tests connectivity to another host.                 |
| `curl https://example.com` | Retrieves data from a URL.                          |
| `wget <URL>`               | Downloads a file from the Internet.                 |
| `ss -tuln`                 | Displays listening TCP/UDP ports.                   |
| `netstat -tuln`            | Displays network connections (if installed).        |
| `nslookup google.com`      | Looks up the IP address of a domain (if installed). |

---

## Hands-on Exercises

### Exercise 1 - Check Hostname

```bash
hostname
```

---

### Exercise 2 - Display IP Address

```bash
hostname -I
```

---

### Exercise 3 - View Network Interfaces

```bash
ip addr
```

---

### Exercise 4 - View Routing Table

```bash
ip route
```

---

### Exercise 5 - Test Internet Connectivity

```bash
ping google.com
```

Press **Ctrl + C** to stop the ping.

---

### Exercise 6 - Fetch Web Page Content

```bash
curl https://example.com
```

---

### Exercise 7 - Download a File

```bash
wget https://example.com
```

---

### Exercise 8 - View Listening Ports

```bash
ss -tuln
```

---

### Exercise 9 - Check Active Network Connections

```bash
netstat -tuln
```

*(Install `net-tools` if `netstat` is not available.)*

---

### Exercise 10 - DNS Lookup

```bash
nslookup google.com
```

*(Install `dnsutils` if `nslookup` is not available.)*

---

## Learning Outcome

After completing Day 04, I am able to:

* Understand Linux networking fundamentals.
* Identify the system hostname and IP address.
* Inspect network interfaces and routing information.
* Test network connectivity.
* Retrieve and download data from the Internet.
* View listening ports and active network connections.
* Perform basic DNS lookups.

---
