# Security-Utils
A collection of small security utilities, including tools for parsing Loki IOC logs, configuring host-based IDS, timestomping files, and more.

### Timestomp
Module that provides functions for timestomping files on Windows and generating random dates.
### OSSEC
Module that provides a function for pairing a Windows OSSEC agent with an OSSEC server.  Modifies client.keys.  Uses WSMAN on Windows to partially emulate the function of agent-auth of Unix.
### Loki
Utility for parsing the output of a Loki IOC log and generating reports.
### LogRhythm
Utility for parsing a LogRhythm Mediator log for instances of agents whose heartbeat offset falls outside of a specified range, indicating the local time on these agents should be corrected.
