package policy

# rules - allow is the name of the rule

default allow = false
allow = true {
  1 == 1
  2 == 2
  3 == 3
}
# as long as all the rules are true, the value is returned
# the default returned value is true, no need to define it.

```rego

ruleName = responseValue {
  conditions
}
```

# Command line to eval policy
# opa eval --data policy.rego 'data.policy.allow'

