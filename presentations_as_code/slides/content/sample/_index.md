+++
title = "Presentations as Code!"
outputs = ["Reveal"]
[reveal_hugo]
custom_theme = "reveal-hugo/themes/robot-lung.css"
margin = 0.2
highlight_theme = "color-brewer"
transition = "slide"
transition_speed = "fast"
+++


# Presentations as Code!

#### In Utopia, Everything is code, why not presentations as well!

https://github.com/tpeterson66

---

# Everything you see is stored in code!

### Even code blocks in your presentation!!!

_Like, yaml config_

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

{{% note %}}
Don't forget to explain what the service is doing!
{{% /note %}}

---
  
<!-- {{< slide id="hello" background="#7d64ff" transition="zoom" transition-speed="slow" >}}

{{% note %}}
Speaker notes here. This shouldn't be visible.
{{% /note %}}

<p style="color:white">
{{% fragment %}}# Isa{{% /fragment %}}
{{% fragment %}}## Deux{{% /fragment %}}
{{% fragment %}}### Drie{{% /fragment %}}

</p> -->

---

{{% section %}}

# You can go up, down, left, right!

---

### Drill into content or skip right over it!

{{% /section %}}

---

The possibilities are endless...
