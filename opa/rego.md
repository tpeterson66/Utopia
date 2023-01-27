# Open Policy Agent

Policies are written in Rego

## Rego

Each policy must start with a package, the name is arbitrary, but is used when evaluating policies later. In this case, just using the package name of `policy` to start.

```go
package policy
```
### Rules

Rules are used to complete some level of verification or check and then return a value based on the success of the conditions.

```go
default allow = false
allow = true {
  1 == 1
  2 == 2
  3 == 3
}
```

If the rules are true, the value is returned, if not, no value is returned unless there is a `default` statement in the policy.

```rego

ruleName = responseValue {
  conditions
}
```

# Command line to eval policy
# opa eval --data policy.rego 'data.policy.allow'

