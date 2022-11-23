# Terraform Notes

General notes around Terraform - most of what is worth noting is already documented and searchable, but here is a collection of things I keep handy.

## Terraform Module Options

There are various options for creating and storing modules for use within a single project or multiple projects. Each option has some benefits and drawbacks, like anything in the world of DevOps. Here are the popular options that many folks have adopted and are successful deploying TF using modules.

I want to describe two things;

1. Module: a set of configuration files which can be called from one or more projects. This promotes usability and keeps the main project code cleaner.
2. Project Code: Is the code that is ran to create infrastructure. This is where you call modules and other resources to create your IaC.

### A Single Repo Containing Project Code and Modules

This is a common beginner deployment option where the single repository contains both the project code and the modules, typically in a `modules` directory in the repository. This is common as it allows folks to quickly add modules, reference the local directories using `../modules/resource_group` for example without having to deal with registries, separate repos, etc.

The drawbacks for this method are what make this so simple starting out. When or if you create a new project, you will need to either copy the modules you want over to the other project or reference them from the current project. The copy and paste option means you now need to maintain the same module in two locations. This becomes more complex as you continue to get further into module sharing between projects. When referencing the modules, you need to make sure you can clone both repos and manage the path to those repos in your code correctly.

This should only be used for small projects where there is no immediate need to create two or more projects. This should be used if the modules and IaC created are only going to be used for one workload or use-case or if the code is being handed over as a deliverable.

### Modules in a Dedicated Repository

If you have a need to share some modules between multiple projects and want to make sure the modules are not local to any specific project, this is the next best option. This method means you have a single repository which contains all of your modules. To start, this may only be 10 or 20, however, when you get further into IaC, this can grow quickly. The general idea is that each project references the modules repository using the git url for the repo.

At this point, you can introduce tagging, which can compliment this deployment and allow maintainers of the module repository to create tags, almost like named snapshots of the repo at any given point. This can be used to reference a specific version of the modules repo at a certain point, Ie, before a provider update or before a major change to the module which may potentially break workloads in the future.

The drawback to the method is that you need to maintain the module registry, which means another repo to work from when creating code for a new project or updating an existing. Managing tags can also be a small administrative burden as well.

This method does solve a lot of problems and should be used if you do not have a registry such as Terraform Cloud or something similar. This also should only be used if you have a low amount of updates to the modules for each project. This can depend on the number of projects that are working from the modules. It is suggested to use the tag approach when referencing modules with this method to ensure you know exactly what to expect.

### Terraform Cloud Module Registry

Terraform Cloud and like providers offer a solution for managing Terraform modules. With Terraform Cloud, it is the module private registry. This provides an authenticated method to allow multiple projects to access the modules required for their project. It supports documentation, provides an easy to read and use interface, and supports versioning, which allows you to managing the modules version for multiple projects.

This method currently requires that every module be its own repository with a specific name. This is a strict requirement, so if you have 50 modules, you will need 50 repositories. This can be a huge inconvenience if you need to make updates to 50 modules, that means, cloning 50 modules using git, updating the code 50 times, 50 commits, 50 pull requests, 50 reviews, etc.

This method should only be used if you're going to adopt Terraform Private Registry and build very robust modules which contain multiple resources to get the most value from managing this type of solution. This should not be used for single resource modules. This can be used in conjunction with a shared module approach, however, you would need to manage the authentication and orchestration between the various systems.

### Terraform Cloud Module Registry with Sub-Modules

As mentioned, each module in Terraform Cloud Private Module Registry requires its own repository. One way to reduce the number of repos required is by using sub-modules within a module. Essentially, you would create a module, for instance, a network module, which would contain all the network module resources. Each sub-module can be accessed similar to a primary module providing all the benefits of the module registry with less of the headache associated with managing large numbers of modules.

This does mean that each sub-module is versioned with the main module. This means, if you update the route_table sub-module and create a new version of the network module, all the sub-modules will also be updated. This is less of an issue if you call each module using a specific version, however, if not defined, this can be problematic when modules are updated and dependent projects are not updated to match the new changes.

This should be used if you want to leverage the TFC Private Registry or similar service but to not want to managing a large amount of repositories.
